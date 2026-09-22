import 'dart:async';

import 'package:cyberneom/eeg/cyberneom_eeg_visual_signal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neom_core/domain/model/neom/neom_neuro_state.dart';
import 'package:neom_core/domain/use_cases/neuro_state_service.dart';
import 'package:sint/sint.dart';

/// Stand-in for the headset adapter: scripted activity and snapshot.
class _FakeNeuro implements NeuroStateService {
  bool active = true;
  NeuroStateSnapshot snapshot = NeuroStateSnapshot.neutral();

  @override
  NeomNeuroState get currentState => snapshot.state;

  @override
  bool get isActive => active;

  @override
  NeuroStateSnapshot get latestSnapshot => snapshot;

  @override
  Stream<NeuroStateSnapshot> get stateStream => const Stream.empty();

  @override
  void setNeuroState(NeomNeuroState state) {}
}

void main() {
  late _FakeNeuro neuro;
  late CyberneomEegVisualSignal signal;

  setUp(() {
    neuro = _FakeNeuro();
    Sint.put<NeuroStateService>(neuro);
    signal = CyberneomEegVisualSignal(freshness: const Duration(seconds: 2));
  });

  tearDown(() {
    signal.dispose();
    Sint.delete<NeuroStateService>(force: true);
  });

  test('uses the measured coherence while the headset is active and fresh', () {
    neuro.snapshot = NeuroStateSnapshot(
      state: NeomNeuroState.calm,
      coherence: 0.83,
      timestamp: DateTime.now(),
    );
    expect(signal.hemisphericCoherence, closeTo(0.83, 1e-9));
    expect(signal.usingEeg, isTrue);
  });

  test('falls back when the headset is inactive or the reading is stale', () {
    neuro.snapshot = NeuroStateSnapshot(
      state: NeomNeuroState.calm,
      coherence: 0.83,
      timestamp: DateTime.now().subtract(const Duration(seconds: 5)),
    );
    // No generator registered in this test, so the fallback is the neutral 0.
    expect(signal.usingEeg, isFalse);
    expect(signal.hemisphericCoherence, 0.0);

    neuro.snapshot = NeuroStateSnapshot(
      state: NeomNeuroState.calm,
      coherence: 0.9,
      timestamp: DateTime.now(),
    );
    neuro.active = false;
    expect(signal.usingEeg, isFalse);
  });

  test('every other field delegates and is safe without a generator', () {
    expect(signal.waveHeight, 0.0);
    expect(signal.waveStretch, 1.0);
    expect(signal.breathPulse, 0.0);
    expect(signal.audioSession.isPlaying, isFalse);
  });
}
