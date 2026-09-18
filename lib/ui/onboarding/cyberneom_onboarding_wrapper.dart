import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neom_core/domain/model/neom/neom_neuro_state.dart';
import 'package:neom_generator/engine/audio/neom_voice_pitch_measurement.dart';
import 'package:neom_generator/engine/neom_breath_engine.dart';
import 'package:neom_generator/ui/neom_generator_controller.dart';
import 'package:neom_generator/utils/enums/neom_spatial_mode.dart';
import 'package:neom_home/ui/web/neom_onboarding_overlay.dart';
import 'package:neom_states/data/state_catalog.dart';
import 'package:sint/sint.dart';

/// Wraps [NeomOnboardingOverlay] with Hive persistence, state catalog,
/// and audio via [NeomGeneratorController] (registered in root_binding).
///
/// All audio goes through the controller so the mini player, INCIENSO tracker,
/// and Cámara Neom share the same state.
class CyberneomOnboardingWrapper extends StatefulWidget {
  /// Injectable for tests: a synthetic source must never request a real mic.
  final VoicePitchMeasurement? voiceMeasurement;

  const CyberneomOnboardingWrapper({super.key, this.voiceMeasurement});

  @override
  State<CyberneomOnboardingWrapper> createState() =>
      _CyberneomOnboardingWrapperState();
}

class _CyberneomOnboardingWrapperState
    extends State<CyberneomOnboardingWrapper> {
  bool _show = false;
  bool _isFirstVisit = true;
  late final VoicePitchMeasurement _voiceMeasurement;
  int _demoRequest = 0;
  int? _preparedRequest;
  NeomGeneratorController? _preparedGenerator;
  bool _measurementInFlight = false;

  @override
  void initState() {
    super.initState();
    _voiceMeasurement = widget.voiceMeasurement ?? VoicePitchMeasurement();
    _checkVisitHistory();
  }

  @override
  void dispose() {
    _invalidateDemo();
    unawaited(_voiceMeasurement.dispose());
    super.dispose();
  }

  Future<double?> _measureFrequency(ValueChanged<double> onPitch) {
    // Stop generated tones before measuring so we do not measure our speakers.
    // Keep capture activation in this same user gesture (browser requirement).
    final generator = _generator;
    final request = ++_demoRequest;
    _preparedGenerator = null;
    _preparedRequest = null;
    _measurementInFlight = true;
    Future<void> preparation = Future<void>.value();
    if (generator != null) {
      unawaited(generator.stopRecording(applyDetectedFrequency: false));
      unawaited(generator.stopChannelCheck());
      preparation = _prepareDemo(generator, request);
    }
    // Capture starts synchronously; preparation runs during the measurement.
    final measured = _voiceMeasurement.measure(onPitch: onPitch);
    return _completeMeasurement(measured, preparation, generator, request);
  }

  bool _isCurrentDemo(int request) =>
      mounted && _show && request == _demoRequest;

  Future<void> _prepareDemo(
    NeomGeneratorController generator,
    int request,
  ) async {
    await generator.startFreeSession();
    if (!_isCurrentDemo(request)) return;
    // A measured tone must not inherit a recording, octave or effect chain.
    generator.setNeuroState(NeomNeuroState.neutral);
    generator.setOctave(0);
    generator.disableMultiFrequency();
    generator.setModulationEnabled(false);
    generator.setBreathMode(NeomBreathMode.off);
    generator.setSpatialMode(NeomSpatialMode.softPan);
    generator.setParameterPosition(x: 0, y: 0, z: 0);
    await generator.setIsochronicEnabled(false);
  }

  Future<double?> _completeMeasurement(
    Future<double?> measured,
    Future<void> preparation,
    NeomGeneratorController? generator,
    int request,
  ) async {
    try {
      final results = await Future.wait<Object?>([
        measured,
        preparation,
      ], eagerError: true);
      if (!_isCurrentDemo(request)) return null;
      final pitch = results.first as double?;
      if (pitch != null && pitch.isFinite && pitch > 0) {
        _preparedGenerator = generator;
        _preparedRequest = request;
      }
      return pitch;
    } catch (_) {
      if (_isCurrentDemo(request)) await _voiceMeasurement.cancel();
      rethrow;
    } finally {
      if (request == _demoRequest) _measurementInFlight = false;
    }
  }

  void _invalidateDemo() {
    ++_demoRequest;
    _preparedGenerator = null;
    _preparedRequest = null;
    _measurementInFlight = false;
  }

  Future<void> _cancelMeasurement() {
    // Successful measurement cleanup must retain the prepared demo. Explicit
    // cancellation while permission/preparation is pending invalidates it.
    if (_measurementInFlight) _invalidateDemo();
    return _voiceMeasurement.cancel();
  }

  Future<void> _checkVisitHistory() async {
    try {
      final box = await Hive.openBox('settings');
      final hasVisited =
          box.get('cyberneom_has_visited', defaultValue: false) as bool;
      final lastShownMs =
          box.get('cyberneom_onboarding_last_shown', defaultValue: 0) as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      const eightHoursMs = 8 * 60 * 60 * 1000;

      // Show if: never visited, OR last shown > 8 hours ago
      final shouldShow = !hasVisited || (now - lastShownMs > eightHoursMs);

      if (mounted) {
        if (shouldShow) {
          setState(() {
            _show = true;
            _isFirstVisit = !hasVisited;
          });
          await box.put('cyberneom_onboarding_last_shown', now);
        }
        // else: _show stays false, overlay doesn't appear
      }
    } catch (_) {}
  }

  void _dismiss() async {
    _invalidateDemo();
    unawaited(_voiceMeasurement.cancel());
    try {
      final box = Hive.box('settings');
      await box.put('cyberneom_has_visited', true);
    } catch (_) {}
    if (mounted) {
      setState(() => _show = false);
    }
  }

  void _onStateSelected(String stateId) {
    _stopAudio();
    _dismiss();
    Sint.toNamed('/x/$stateId');
  }

  // ── Audio callbacks via NeomGeneratorController ──

  NeomGeneratorController? get _generator {
    try {
      return Sint.find<NeomGeneratorController>();
    } catch (_) {
      return null;
    }
  }

  void _playFrequency(double frequencyHz) => _playDemo(frequencyHz, 0);

  void _playBinaural(double frequencyHz, double beatHz) =>
      _playDemo(frequencyHz, beatHz);

  void _playSpatial(double frequencyHz) =>
      _playDemo(frequencyHz, 0, spatial: true);

  void _playDemo(double frequencyHz, double beatHz, {bool spatial = false}) {
    final gen = _preparedGenerator;
    final request = _preparedRequest;
    if (gen == null ||
        request == null ||
        !_isCurrentDemo(request) ||
        !frequencyHz.isFinite ||
        frequencyHz <= 0) {
      return;
    }
    // No await before Play: all asynchronous preparation already completed.
    unawaited(gen.setFrequency(frequencyHz));
    gen.setBinauralBeat(beat: beatHz);
    gen.setVolume(0.5);
    gen.setSpatialMode(
      spatial ? NeomSpatialMode.orbit : NeomSpatialMode.softPan,
    );
    if (!gen.playbackRequested.value) unawaited(gen.playStopPreview());
  }

  void _stopAudio() {
    _invalidateDemo();
    try {
      final gen = _generator;
      if (gen != null) {
        unawaited(gen.playStopPreview(stop: true));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return const SizedBox.shrink();

    final freeStates = StateCatalog.free;
    final language = Sint.locale?.languageCode ?? 'en';
    final cards = freeStates
        .map(
          (s) => OnboardingStateCard(
            id: s.id,
            name: s.names[language] ?? s.names['en'] ?? s.id,
            description: s.descriptions[language] ?? s.descriptions['en'] ?? '',
            icon: s.icon,
            accentColor: s.screenColor,
            binauralBeat: s.binauralBeat,
            duration: s.duration,
          ),
        )
        .toList();

    return NeomOnboardingOverlay(
      stateCards: cards,
      isFirstVisit: _isFirstVisit,
      onStateSelected: _onStateSelected,
      onDismiss: _dismiss,
      onPlayFrequency: _playFrequency,
      onPlayBinaural: _playBinaural,
      onPlaySpatial: _playSpatial,
      onStopAudio: _stopAudio,
      onMeasureFrequency: _measureFrequency,
      onCancelMeasurement: _cancelMeasurement,
    );
  }
}
