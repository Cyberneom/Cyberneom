import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import test from 'node:test';
import vm from 'node:vm';

const html=readFileSync(new URL('../web/generator.html',import.meta.url),'utf8');
const script=html.match(/<script>([\s\S]*?)<\/script>/)[1];
const visualState=script.match(/^let vizAF=.*;$/m)[0];
const visual=script.slice(script.indexOf('const vizCanvas='),script.indexOf('// ─── UI UPDATES'));
const toggle=script.slice(script.indexOf('function togglePlay(){'),script.indexOf('function onFreq('));

// Evaluate only the production visual code. Audio, network, and animation
// scheduling are fakes: these tests cannot play sound or contact Firebase.
function harness(){
  const pending=new Map(),callbacks=new Map(),documentEvents=new Map(),windowEvents=new Map();
  const paints=[],audioCalls=[],gainCalls=[];
  let nextId=0,timestamp=0;
  const drawing={
    clearRect(){paints.push(timestamp);},beginPath(){},moveTo(){},lineTo(){},stroke(){},
  };
  const canvas={width:8,height:8,getContext:()=>drawing};
  const button={style:{},classList:{add(){},remove(){}}};
  const icon={innerHTML:''};
  const document={
    hidden:false,
    getElementById:id=>id==='viz'?canvas:id==='playBtn'?button:icon,
    addEventListener:(name,callback)=>documentEvents.set(name,callback),
  };
  const context=vm.createContext({
    document,window:{addEventListener:(name,callback)=>windowEvents.set(name,callback)},
    requestAnimationFrame(callback){
      const id=nextId++;
      pending.set(id,callback);callbacks.set(id,callback);return id;
    },
    cancelAnimationFrame:id=>pending.delete(id),
    getEEG:()=>({col:'#00CED1'}),getBreathEnvelope:()=>({env:1}),
    getIsoEnvelope:()=>1,getAMEnvelope:()=>1,
    audioStart:()=>audioCalls.push('start'),audioStop:()=>audioCalls.push('stop'),
    startGainLoop:()=>gainCalls.push('start'),stopGainLoop:()=>gainCalls.push('stop'),
    fbInc(){},todayKey:()=>'test-date',
  });
  vm.runInContext(`let playing=false,freq=432,beat=10,breathStartTime=0;\n${visualState}\n${visual}\n${toggle}`,context);
  return {
    pending,callbacks,paints,audioCalls,gainCalls,
    run:code=>vm.runInContext(code,context),
    visibility(hidden){document.hidden=hidden;documentEvents.get('visibilitychange')();},
    page(name){windowEvents.get(name)();},
    frame(time){
      assert.equal(pending.size,1,'At most one visual frame may be scheduled.');
      const [id,callback]=pending.entries().next().value;
      pending.delete(id);timestamp=time;callback(time);
    },
  };
}

test('entire inline script parses',()=>{
  assert.doesNotThrow(()=>new vm.Script(script));
});

test('idle initialization and visibility changes schedule no frames',()=>{
  const h=harness();
  h.run('startViz();startViz();');
  h.visibility(true);h.visibility(false);h.page('pageshow');
  assert.equal(h.pending.size,0);
  assert.equal(h.paints.length,0);
  assert.deepEqual(h.audioCalls,[]);
});

test('repeated start is idempotent and canvas paints no faster than 30 fps',()=>{
  const h=harness();
  h.run('playing=true;startViz();startViz();startViz();');
  assert.equal(h.pending.size,1);
  for(let time=0;time<=1000;time+=5){
    h.frame(time);
    h.run('startViz();');
  }
  assert.ok(h.paints.length>20);
  assert.ok(h.paints.length<=31);
  for(let i=1;i<h.paints.length;i++)assert.ok(h.paints[i]-h.paints[i-1]>=1000/30);
  assert.equal(h.pending.size,1);
});

test('play and stop synchronize only the visual loop alongside existing audio calls',()=>{
  const h=harness();
  h.run('togglePlay();');
  assert.equal(h.pending.size,1);
  h.frame(0);
  h.run('togglePlay();');
  assert.equal(h.pending.size,0);
  assert.equal(h.run('playing'),false);
  assert.deepEqual(h.audioCalls,['start','stop']);
  assert.deepEqual(h.gainCalls,['start','stop']);
});

test('hidden cancels visuals without audio changes and visible resumes one loop',()=>{
  const h=harness();
  h.run('playing=true;startViz();');
  h.frame(0);
  h.visibility(true);
  assert.equal(h.pending.size,0);
  assert.equal(h.run('playing'),true);
  h.run('startViz();');
  assert.equal(h.pending.size,0);
  h.visibility(false);h.visibility(false);
  assert.equal(h.pending.size,1);
  h.frame(5000);
  assert.deepEqual(h.paints,[0,5000]);
  assert.deepEqual(h.audioCalls,[]);
  assert.deepEqual(h.gainCalls,[]);
});

test('pagehide pauses visual work until pageshow, retaining playback state',()=>{
  const h=harness();
  h.run('playing=true;startViz();');
  h.page('pagehide');
  h.run('startViz();');
  h.visibility(false);
  assert.equal(h.pending.size,0);
  assert.equal(h.run('playing'),true);
  h.page('pageshow');h.page('pageshow');
  assert.equal(h.pending.size,1);
  assert.deepEqual(h.audioCalls,[]);
});

test('late callbacks from a cancelled generation cannot alter a resumed loop',()=>{
  const h=harness();
  h.run('playing=true;startViz();');
  const oldCallback=h.callbacks.values().next().value;
  h.visibility(true);h.visibility(false);
  const resumedId=h.pending.keys().next().value;
  oldCallback(300);
  assert.deepEqual([...h.pending.keys()],[resumedId]);
  assert.equal(h.paints.length,0);
  h.frame(350);
  assert.deepEqual(h.paints,[350]);
});

test('a pending frame exits if playback stopped before it runs',()=>{
  const h=harness();
  h.run('playing=true;startViz();playing=false;');
  h.frame(20);
  assert.equal(h.pending.size,0);
  assert.equal(h.paints.length,0);
  h.page('pagehide');h.page('pageshow');
  assert.equal(h.pending.size,0);
});
