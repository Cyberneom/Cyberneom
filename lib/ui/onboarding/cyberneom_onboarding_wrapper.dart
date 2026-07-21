import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neom_generator/ui/neom_generator_controller.dart';
import 'package:neom_generator/utils/enums/neom_spatial_mode.dart';
import 'package:neom_home/ui/web/neom_onboarding_overlay.dart';
import 'package:neom_states/data/state_catalog.dart';
import 'package:sint/sint.dart';

/// Wraps [CyberneomOnboardingOverlay] with Hive persistence, state catalog,
/// and audio via [NeomGeneratorController] (registered in root_binding).
///
/// All audio goes through the controller so the mini player, INCIENSO tracker,
/// and Cámara Neom share the same state.
class CyberneomOnboardingWrapper extends StatefulWidget {
  const CyberneomOnboardingWrapper({super.key});

  @override
  State<CyberneomOnboardingWrapper> createState() => _CyberneomOnboardingWrapperState();
}

class _CyberneomOnboardingWrapperState extends State<CyberneomOnboardingWrapper> {
  bool _show = false;
  bool _isFirstVisit = true;

  @override
  void initState() {
    super.initState();
    _checkVisitHistory();
  }

  Future<void> _checkVisitHistory() async {
    try {
      final box = await Hive.openBox('settings');
      final hasVisited = box.get('cyberneom_has_visited', defaultValue: false) as bool;
      final lastShownMs = box.get('cyberneom_onboarding_last_shown', defaultValue: 0) as int;
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
    // Don't stop audio — keep frequency active for navigation via mini player
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

  void _playFrequency(double frequencyHz) async {
    final gen = _generator;
    if (gen == null) return;
    gen.setFrequency(frequencyHz);
    gen.setBinauralBeat(beat: 0);
    gen.setVolume(0.5);
    if (!gen.isPlaying.value) await gen.playStopPreview();
  }

  void _playBinaural(double frequencyHz, double beatHz) async {
    final gen = _generator;
    if (gen == null) return;
    gen.setFrequency(frequencyHz);
    gen.setBinauralBeat(beat: beatHz);
    gen.setVolume(0.5);
    if (!gen.isPlaying.value) await gen.playStopPreview();
  }

  void _playSpatial(double frequencyHz) async {
    final gen = _generator;
    if (gen == null) return;
    gen.setFrequency(frequencyHz);
    gen.setBinauralBeat(beat: 0);
    gen.setVolume(0.5);
    // Spatial orbit — set via engine since controller may not expose spatial mode directly
    gen.setSpatialMode(NeomSpatialMode.orbit);
    if (!gen.isPlaying.value) await gen.playStopPreview();
  }

  void _stopAudio() {
    try {
      final gen = _generator;
      if (gen != null && gen.isPlaying.value) {
        gen.playStopPreview(stop: true);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return const SizedBox.shrink();

    final freeStates = StateCatalog.free;
    final cards = freeStates.map((s) => OnboardingStateCard(
      id: s.id,
      name: s.names['es'] ?? s.names['en'] ?? s.id,
      description: s.descriptions['es'] ?? s.descriptions['en'] ?? '',
      icon: s.icon,
      accentColor: s.screenColor,
      binauralBeat: s.binauralBeat,
      duration: s.duration,
    )).toList();

    return NeomOnboardingOverlay(
      stateCards: cards,
      isFirstVisit: _isFirstVisit,
      onStateSelected: _onStateSelected,
      onDismiss: _dismiss,
      onPlayFrequency: _playFrequency,
      onPlayBinaural: _playBinaural,
      onPlaySpatial: _playSpatial,
      onStopAudio: _stopAudio,
    );
  }
}
