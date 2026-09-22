import 'package:neom_eeg/data/implementations/eeg_calibration_controller.dart';
import 'package:neom_eeg/data/implementations/eeg_connection_controller.dart';
import 'package:neom_eeg/data/implementations/eeg_practice_link.dart';
import 'package:neom_eeg/data/implementations/eeg_session_capture_controller.dart';
import 'package:neom_eeg/data/implementations/eeg_watch_controller.dart';
import 'package:neom_eeg/domain/models/eeg_session_capture.dart';
import 'package:neom_generator/ui/neom_generator_controller.dart';
import 'package:sint/sint.dart';

/// Ties the Cámara Neom to the EEG session capture.
///
/// Whenever the chamber plays (`isPlaying`), the EEG hub's live buffer is
/// cut into a capture filed under the chamber's own practice id
/// (`practice_<micros>`), annotated with what the chamber was playing
/// (base/binaural/effective frequency, volume, neuro state, preset) and what
/// the microphone detected. The generator is only *observed* — none of its
/// code changes — and neom_eeg never learns who the host is.
///
/// It also wakes the calibration and watch controllers, which are lazy
/// bindings: without this they would only start when the EEG dashboard is
/// opened, and a chamber session with the panel closed would get no
/// alerts, no automatic markers and no baseline loaded.
class CyberneomEegPracticeBridge extends SintController {
  EegPracticeLink? _link;

  @override
  void onInit() {
    super.onInit();
    final eeg = Sint.find<EegConnectionController>();
    final hub = eeg.hub;
    if (hub == null) return;

    final capture = Sint.isRegistered<EegSessionCaptureController>()
        ? Sint.find<EegSessionCaptureController>()
        : Sint.put(EegSessionCaptureController(hub: hub), permanent: true);
    if (Sint.isRegistered<EegCalibrationController>()) {
      Sint.find<EegCalibrationController>();
    }
    if (Sint.isRegistered<EegWatchController>()) Sint.find<EegWatchController>();

    if (!Sint.isRegistered<NeomGeneratorController>()) return;
    final chamber = Sint.find<NeomGeneratorController>();

    _link = EegPracticeLink(
      capture: capture,
      isPlaying: chamber.isPlaying,
      sessionStartedAt: () => chamber.sessionStartedAt,
      context: () => {
        EegContextKeys.baseHz: chamber.currentFreq.value,
        EegContextKeys.beatHz: chamber.currentBeat.value,
        EegContextKeys.effectiveHz: chamber.effectiveFrequency,
        EegContextKeys.volume: chamber.currentVol.value,
        EegContextKeys.neuroState: chamber.neuroState.value.name,
        EegContextKeys.isochronicHz: chamber.isochronicFreq.value,
        EegContextKeys.preset:
            chamber.activeIncienso?.getName(Sint.locale?.languageCode ?? 'es') ??
                chamber.chamberPreset.name,
      },
      annotateOn: [chamber.currentFreq, chamber.currentBeat, chamber.currentOctave],
      detectedVoiceHz: chamber.detectedFrequency,
      voiceCapturing: chamber.isRecording,
    )..attach();
  }

  @override
  void onClose() {
    _link?.detach();
    super.onClose();
  }
}
