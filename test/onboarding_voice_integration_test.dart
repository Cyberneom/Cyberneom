import 'dart:async';
import 'dart:io';

import 'package:cyberneom/localization/app_translations.dart';
import 'package:cyberneom/ui/onboarding/cyberneom_onboarding_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neom_core/domain/model/neom/neom_neuro_state.dart';
import 'package:neom_generator/engine/audio/neom_voice_pitch_measurement.dart';
import 'package:neom_generator/engine/neom_breath_engine.dart';
import 'package:neom_generator/ui/neom_generator_controller.dart';
import 'package:neom_generator/utils/enums/neom_spatial_mode.dart';
import 'package:neom_home/ui/web/neom_onboarding_overlay.dart';
import 'package:sint/sint.dart';

class _Measurement implements VoicePitchMeasurement {
  @override
  Duration get measurementDuration => const Duration(seconds: 5);
  @override
  Duration get permissionTimeout => const Duration(seconds: 15);

  int starts = 0;
  int cancellations = 0;
  int disposals = 0;
  final result = Completer<double?>();

  @override
  Future<double?> measure({required void Function(double) onPitch}) {
    starts++;
    onPitch(219.8);
    return result.future;
  }

  @override
  Future<void> cancel() async {
    cancellations++;
  }

  @override
  Future<void> dispose() async {
    disposals++;
  }
}

/// Models the persistent controller's inherited preset and octave behavior.
class _Generator extends SintController implements NeomGeneratorController {
  final Completer<void> preparation = Completer<void>();
  int preparationStarts = 0;
  int starts = 0;
  int settingsChanges = 0;
  bool hasPreset = true;
  int octave = 3;
  bool multiFrequency = true;
  bool modulation = true;
  bool isochronic = true;
  NeomBreathMode breath = NeomBreathMode.box;
  NeomSpatialMode spatial = NeomSpatialMode.orbit;
  NeomNeuroState state = NeomNeuroState.focus;
  List<double> position = [1, 2, 3];
  double frequency = 432;
  double beat = 7;
  double? playedFrequency;
  @override
  final RxBool playbackRequested = false.obs;
  @override
  final RxBool isPlaying = false.obs;

  @override
  Future<void> startFreeSession() async {
    preparationStarts++;
    await preparation.future;
    hasPreset = false;
  }

  @override
  Future<void> stopRecording({bool applyDetectedFrequency = true}) async {}
  @override
  Future<void> stopChannelCheck() async {}
  @override
  void setNeuroState(NeomNeuroState value) {
    state = value;
    settingsChanges++;
  }

  @override
  void setOctave(int value) {
    octave = value;
    settingsChanges++;
  }

  @override
  void disableMultiFrequency() {
    multiFrequency = false;
    settingsChanges++;
  }

  @override
  void setModulationEnabled(bool value) {
    modulation = value;
    settingsChanges++;
  }

  @override
  void setBreathMode(NeomBreathMode value) {
    breath = value;
    settingsChanges++;
  }

  @override
  void setSpatialMode(NeomSpatialMode value) {
    spatial = value;
    settingsChanges++;
  }

  @override
  void setParameterPosition({
    required double x,
    required double y,
    required double z,
  }) {
    position = [x, y, z];
    settingsChanges++;
  }

  @override
  Future<void> setIsochronicEnabled(bool value) async {
    isochronic = value;
    settingsChanges++;
  }

  @override
  Future<void> setFrequency(double value) async {
    frequency = value;
  }

  @override
  void setBinauralBeat({double beat = 0}) {
    this.beat = beat;
  }

  @override
  void setVolume(double value, {bool? rightOrLeft}) {}
  @override
  Future<void> playStopPreview({bool stop = false}) async {
    if (stop) {
      playbackRequested.value = false;
      isPlaying.value = false;
      return;
    }
    starts++;
    playedFrequency = (hasPreset ? 432.0 : frequency) * (1 << octave);
    playbackRequested.value = true;
    isPlaying.value = true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Directory storage;
  setUpAll(() async {
    storage = await Directory.systemTemp.createTemp('cyberneom_voice_ui_');
    Hive.init(storage.path);
    await Hive.openBox('settings');
  });
  tearDownAll(() async {
    await Hive.close();
    await storage.delete(recursive: true);
  });
  setUp(() async {
    await Hive.box('settings').clear();
    Sint.locale = const Locale('en');
    Sint.addTranslations(AppTranslations().keys);
  });
  tearDown(() {
    Sint.locale = null;
    Sint.clearTranslations();
  });

  Future<NeomOnboardingOverlay> mountWrapper(
    WidgetTester tester,
    _Measurement measurement,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: CyberneomOnboardingWrapper(voiceMeasurement: measurement),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await Hive.box('settings').flush();
    });
    await tester.pump();
    return tester.widget<NeomOnboardingOverlay>(
      find.byType(NeomOnboardingOverlay),
    );
  }

  testWidgets(
    'demo preparation overlaps capture, clears inherited sound and preserves exact pitch',
    (tester) async {
      final generator = _Generator();
      Bind.put<NeomGeneratorController>(generator);
      addTearDown(() => Bind.delete<NeomGeneratorController>(force: true));
      final measurement = _Measurement();
      final overlay = await mountWrapper(tester, measurement);
      var finished = false;
      final result = overlay.onMeasureFrequency!((_) {}).then((value) {
        finished = true;
        return value;
      });
      expect(
        measurement.starts,
        1,
        reason: 'Capture activation must stay synchronous',
      );
      expect(generator.preparationStarts, 1);
      overlay.onPlayFrequency!(220.125);
      expect(
        generator.starts,
        0,
        reason: 'Preparation must never queue an autoplay',
      );
      measurement.result.complete(220.125);
      await tester.pump();
      expect(finished, isFalse);
      generator.preparation.complete();
      await tester.pump();
      expect(await result, 220.125);
      expect(generator.hasPreset, isFalse);
      expect(generator.octave, 0);
      expect(generator.multiFrequency, isFalse);
      expect(generator.modulation, isFalse);
      expect(generator.isochronic, isFalse);
      expect(generator.breath, NeomBreathMode.off);
      expect(generator.position, [0, 0, 0]);
      expect(generator.state, NeomNeuroState.neutral);
      // Overlay calls this after success as well as on cancellation.
      await overlay.onCancelMeasurement!();
      overlay.onPlayFrequency!(220.125);
      expect(
        generator.starts,
        1,
        reason: 'No asynchronous wait may precede explicit Play',
      );
      expect(generator.playedFrequency, 220.125);
      expect(generator.beat, 0);
      expect(generator.spatial, NeomSpatialMode.softPan);
      overlay.onPlayBinaural!(220.125, 4);
      expect(generator.starts, 1);
      expect(generator.beat, 4);
      overlay.onStopAudio!();
      overlay.onPlaySpatial!(220.125);
      expect(generator.starts, 1, reason: 'Stopped demo callbacks are stale');
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );

  for (final close in [false, true]) {
    testWidgets(
      'pending preparation cannot autoplay after ${close ? 'close' : 'cancel'}',
      (tester) async {
        final generator = _Generator();
        Bind.put<NeomGeneratorController>(generator);
        addTearDown(() => Bind.delete<NeomGeneratorController>(force: true));
        final measurement = _Measurement();
        final overlay = await mountWrapper(tester, measurement);
        final result = overlay.onMeasureFrequency!((_) {});
        measurement.result.complete(219.75);
        await tester.pump();
        if (close) {
          overlay.onStopAudio!();
          await tester.pumpWidget(const SizedBox.shrink());
        } else {
          await overlay.onCancelMeasurement!();
        }
        generator.preparation.complete();
        await tester.pump();
        expect(await result, isNull);
        expect(generator.settingsChanges, 0);
        overlay.onPlayFrequency!(219.75);
        expect(generator.starts, 0);
        await tester.pumpWidget(const SizedBox.shrink());
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('wrapper wires real measurement contract without eager capture', (
    tester,
  ) async {
    final measurement = _Measurement();
    await tester.runAsync(() async {
      // Hive performs real file IO; do not start that work in FakeAsync.
      await tester.pumpWidget(
        MaterialApp(
          home: CyberneomOnboardingWrapper(voiceMeasurement: measurement),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await Hive.box('settings').flush();
    });
    await tester.pump();
    final overlay = tester.widget<NeomOnboardingOverlay>(
      find.byType(NeomOnboardingOverlay),
    );
    expect(measurement.starts, 0);
    final pitches = <double>[];
    final result = overlay.onMeasureFrequency!(pitches.add);
    expect(measurement.starts, 1);
    expect(pitches, [219.8]);
    measurement.result.complete(220.1);
    expect(await result, 220.1);
    await overlay.onCancelMeasurement!();
    expect(measurement.cancellations, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(measurement.disposals, 1);
    expect(tester.takeException(), isNull);
  });
}
