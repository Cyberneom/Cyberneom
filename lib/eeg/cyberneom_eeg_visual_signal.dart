import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:neom_core/domain/use_cases/neom_audio_visual_signal.dart';
import 'package:neom_core/domain/use_cases/neuro_state_service.dart';
import 'package:neom_eeg/data/implementations/eeg_neuro_state_adapter.dart';
import 'package:neom_generator/ui/neom_generator_controller.dart';
import 'package:sint/sint.dart';

/// The Cámara Neom's audio-visual signal with one field replaced: when a
/// headset is streaming, `hemisphericCoherence` is the EEG's measured
/// left/right coherence instead of the phase relationship of the two
/// audio channels.
///
/// Everything else (wave height, phases, breath pulse, glow, the session
/// snapshot) is delegated untouched to the generator's own painter engine,
/// and the engine's change notifications are forwarded, so the experiences
/// (Neuromandala, Fractal, Flocking, Breathing) behave exactly as before —
/// they just resolve this object first, through the `NeomAudioSessionSignal`
/// registration `ExperienceAudioConnection` looks up before the plain
/// `NeomAudioVisualSignal` one the generator registers for itself.
///
/// The generator is only *read*; none of its code changes. Readings older
/// than [freshness] fall back to the audio inference, so a headset that
/// stops sending never freezes the visuals at the last value.
class CyberneomEegVisualSignal extends ChangeNotifier implements NeomAudioSessionSignal {
  CyberneomEegVisualSignal({this.freshness = const Duration(seconds: 2)});

  final Duration freshness;

  NeomAudioSessionSignal? _inner;
  NeuroStateService? _neuro;
  bool _adapterStarted = false;

  /// Whether the last `hemisphericCoherence` read came from the headset.
  bool get usingEeg => _eegCoherence() != null;

  NeomAudioSessionSignal? get _engine {
    if (_inner != null) return _inner;
    if (!Sint.isRegistered<NeomGeneratorController>()) return null;
    final engine = Sint.find<NeomGeneratorController>().painterEngine;
    _inner = engine;
    engine.addListener(notifyListeners);
    return engine;
  }

  NeuroStateService? get _neuroService {
    if (_neuro != null) return _neuro;
    if (!Sint.isRegistered<NeuroStateService>()) return null;
    final service = Sint.find<NeuroStateService>();
    _neuro = service;
    // The adapter observes the hub only once started; nothing else in the
    // app starts it, so the first visual that asks for coherence does.
    if (service is EegNeuroStateAdapter && !_adapterStarted) {
      _adapterStarted = true;
      unawaited(service.start());
    }
    return service;
  }

  double? _eegCoherence() {
    final neuro = _neuroService;
    if (neuro == null || !neuro.isActive) return null;
    final snap = neuro.latestSnapshot;
    if (DateTime.now().difference(snap.timestamp) > freshness) return null;
    return snap.coherence.clamp(0.0, 1.0);
  }

  @override
  double get hemisphericCoherence => _eegCoherence() ?? _engine?.hemisphericCoherence ?? 0.0;

  @override
  double get waveHeight => _engine?.waveHeight ?? 0.0;

  @override
  double get waveStretch => _engine?.waveStretch ?? 1.0;

  @override
  double get visualPhase => _engine?.visualPhase ?? 0.0;

  @override
  double get binauralPhase => _engine?.binauralPhase ?? 0.0;

  @override
  double get breathPulse => _engine?.breathPulse ?? 0.0;

  @override
  double get glowIntensity => _engine?.glowIntensity ?? 0.0;

  @override
  NeomAudioSessionSnapshot get audioSession =>
      _engine?.audioSession ?? const NeomAudioSessionSnapshot();

  @override
  void dispose() {
    final Object? inner = _inner;
    if (inner is Listenable) inner.removeListener(notifyListeners);
    super.dispose();
  }
}
