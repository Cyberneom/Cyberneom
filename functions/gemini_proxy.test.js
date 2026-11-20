'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const geminiProxy = require('./gemini_proxy');

function createMockDb() {
  const store = new Map();
  return {
    collection(col) {
      return {
        doc(id) {
          const key = `${col}/${id}`;
          return { key };
        },
      };
    },
    async runTransaction(fn) {
      const tx = {
        async get(ref) {
          const val = store.get(ref.key);
          return {
            exists: val !== undefined,
            data: () => val,
          };
        },
        set(ref, data, opts) {
          if (opts && opts.merge && store.has(ref.key)) {
            store.set(ref.key, { ...store.get(ref.key), ...data });
          } else {
            store.set(ref.key, { ...data });
          }
        },
      };
      return await fn(tx);
    },
  };
}

function createMockRes() {
  const res = {
    statusCode: 200,
    headers: {},
    headersSent: false,
    chunks: [],
    jsonBody: null,
    ended: false,
    setHeader(k, v) {
      this.headers[k.toLowerCase()] = v;
    },
    status(code) {
      this.statusCode = code;
      return this;
    },
    json(body) {
      this.headersSent = true;
      this.jsonBody = body;
      this.ended = true;
      return this;
    },
    write(chunk) {
      this.headersSent = true;
      this.chunks.push(String(chunk));
    },
    end() {
      this.ended = true;
      return this;
    },
  };
  return res;
}

test('rejects unauthenticated requests without trusted Cyberneom origin with 401', async () => {
  await assert.rejects(
    () => geminiProxy.handleGeminiProxy({
      params: { contents: [{ role: 'user', parts: [{ text: 'hola' }] }] },
      auth: null,
      req: { headers: { origin: 'https://evil.example' } },
      db: createMockDb(),
    }),
    (err) => err instanceof geminiProxy.GeminiProxyError &&
      err.code === 'unauthenticated' &&
      err.httpStatus === 401,
  );
});

test('allows guest request from trusted Cyberneom origin billed to itzli-app with 1024 token cap', async () => {
  let capturedBody = null;
  let capturedInit = null;
  let capturedUrl = '';
  const result = await geminiProxy.handleGeminiProxy({
    params: {
      contents: [{ role: 'user', parts: [{ text: '¿Qué ves?' }] }],
      generationConfig: { maxOutputTokens: 4096 },
    },
    auth: null,
    req: { headers: { origin: 'https://cyberneom.xyz', 'x-forwarded-for': '203.0.113.10' } },
    db: createMockDb(),
    getAccessToken: async () => 'fake-adc-token',
    fetchImpl: async (url, init) => {
      capturedUrl = url;
      capturedInit = init;
      capturedBody = JSON.parse(init.body);
      return {
        ok: true,
        status: 200,
        async json() {
          return {
            candidates: [{
              content: { role: 'model', parts: [{ text: 'Soy Itzli en Cyberneom.' }] },
              finishReason: 'STOP',
            }],
          };
        },
      };
    },
  });

  assert.match(capturedUrl, /projects\/itzli-app\/locations\/us-central1/);
  assert.equal(capturedInit.headers['x-goog-user-project'], 'itzli-app');
  assert.equal(capturedBody.generationConfig.maxOutputTokens, 1024);
  assert.equal(result.candidates[0].content.parts[0].text, 'Soy Itzli en Cyberneom.');
});

test('enforces model allowlist, sovereign lock, and clamps maxOutputTokens', () => {
  assert.throws(
    () => geminiProxy.validateAndBuildVertexRequest({
      model: 'gemini-3.9-ultra-expensive',
      contents: [{ role: 'user', parts: [{ text: 'hola' }] }],
    }),
    (err) => err instanceof geminiProxy.GeminiProxyError && err.code === 'invalid-argument',
  );

  const built = geminiProxy.validateAndBuildVertexRequest({
    model: 'gemini-2.5-flash-lite',
    contents: [{ role: 'user', parts: [{ text: 'hola' }] }],
    systemInstruction: 'Eres Itzli en Cyberneom',
    generationConfig: { maxOutputTokens: 999999, temperature: 0.5 },
  });

  assert.equal(built.targetModel, 'gemini-2.5-flash-lite');
  assert.equal(built.body.generationConfig.maxOutputTokens, 4096);
  assert.match(built.body.systemInstruction.parts[0].text, /Eres Itzli/);
  assert.match(built.body.systemInstruction.parts[0].text, /Eres Itzli en Cyberneom/);
});

test('never exposes Gemini, Vertex AI, or Google brand names in client-facing errors', async () => {
  await assert.rejects(
    () => geminiProxy.handleGeminiProxy({
      params: {
        model: 'gemini-2.5-flash-lite',
        contents: [{ role: 'user', parts: [{ text: 'hola' }] }],
      },
      auth: { uid: 'user_cyb_err', token: { firebase: { sign_in_provider: 'password' } } },
      db: createMockDb(),
      getAccessToken: async () => 'fake-adc-token',
      fetchImpl: async () => ({
        ok: false,
        status: 503,
        async text() {
          return 'Vertex AI Gemini backend overloaded at googleapis.com';
        },
      }),
    }),
    (err) => err instanceof geminiProxy.GeminiProxyError &&
      !/gemini|vertex|google/i.test(err.message) &&
      /itzli/i.test(err.message),
  );
});

test('handleGeminiStreamProxy translates Vertex AI SSE frames to NDJSON chunks', async () => {
  const ssePayload = [
    'data: {"candidates":[{"content":{"role":"model","parts":[{"text":"Hola "}]}}]}',
    '',
    'data: {"candidates":[{"content":{"role":"model","parts":[{"text":"Cyberneom!"}]},"finishReason":"STOP"}]}',
    '',
  ].join('\n');

  const encoder = new TextEncoder();
  const stream = new ReadableStream({
    start(controller) {
      controller.enqueue(encoder.encode(ssePayload));
      controller.close();
    },
  });

  const res = createMockRes();
  await geminiProxy.handleGeminiStreamProxy({
    params: {
      model: 'gemini-2.5-flash-lite',
      contents: [{ role: 'user', parts: [{ text: 'saluda' }] }],
    },
    auth: { uid: 'user_cyb_2', token: { firebase: { sign_in_provider: 'password' } } },
    res,
    db: createMockDb(),
    getAccessToken: async () => 'fake-adc-token',
    fetchImpl: async () => ({
      ok: true,
      status: 200,
      body: stream,
    }),
  });

  assert.equal(res.ended, true);
  assert.equal(res.chunks.length, 2);
  assert.equal(JSON.parse(res.chunks[0]).candidates[0].content.parts[0].text, 'Hola ');
  assert.equal(JSON.parse(res.chunks[1]).candidates[0].content.parts[0].text, 'Cyberneom!');
});

test('enforces anonymous hourly rate limit and resets after window expires', async () => {
  const db = createMockDb();
  const guestAuth = { uid: 'anon_guest_1', token: { firebase: { sign_in_provider: 'anonymous' } } };
  const t0 = 1_700_000_000_000;

  for (let i = 0; i < geminiProxy.GUEST_HOURLY_LIMIT; i++) {
    await geminiProxy.enforceGeminiRateLimit({ db, auth: guestAuth, now: t0 + i * 1000 });
  }

  await assert.rejects(
    () => geminiProxy.enforceGeminiRateLimit({ db, auth: guestAuth, now: t0 + 30_000 }),
    (err) => err instanceof geminiProxy.GeminiProxyError &&
      err.code === 'resource-exhausted' &&
      err.httpStatus === 429,
  );

  await geminiProxy.enforceGeminiRateLimit({
    db,
    auth: guestAuth,
    now: t0 + 60 * 60 * 1000 + 1,
  });
});

test('redacts bearer tokens and API keys from error messages', () => {
  const cleaned = geminiProxy.sanitizeText(
    'Auth failed Bearer ya29.secretTokenValue and AIzaSyDummyKeyValue12345678901234',
  );
  assert.doesNotMatch(cleaned, /ya29\.secretTokenValue/);
  assert.doesNotMatch(cleaned, /AIzaSyDummyKeyValue/);
  assert.match(cleaned, /\[REDACTED\]/);
  assert.match(cleaned, /\[REDACTED_KEY\]/);
});
