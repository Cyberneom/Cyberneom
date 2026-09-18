// Consumer-level harness: Flutter's Chrome runner needs a test inside the app.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neom_core/domain/use_cases/neom_audio_visual_signal.dart';
import 'package:neom_experiences/data/translations/experience_es_translations.dart';
import 'package:neom_experiences/ui/breathing/neom_breathing_fullscreen_page.dart';
import 'package:neom_experiences/ui/flocking/neom_flocking_fullscreen_page.dart';
import 'package:neom_experiences/ui/fractal/neom_fractal_fullscreen_page.dart';
import 'package:neom_experiences/ui/fractal/neom_fractal_controller.dart';
import 'package:neom_experiences/ui/neomatics/neomatics_fullscreen_page.dart';
import 'package:neom_experiences/ui/neuromandala/neuromandala_fullscreen_page.dart';
import 'package:neom_experiences/ui/shared/experience_audio_hud.dart';
import 'package:sint/sint.dart';

class _Translations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'es': ExperienceEsTranslations.values,
  };
}

class _Signal extends ChangeNotifier implements NeomAudioSessionSignal {
  @override
  NeomAudioSessionSnapshot get audioSession => const NeomAudioSessionSnapshot(
    isPlaying: true,
    multiFrequency: true,
    leftHz: 220,
    rightHz: 227,
    subHz: 55,
    subGain: 0.25,
    level: 0.2,
    playedFrames: 44100,
  );
  @override
  double get waveHeight => 0.2;
  @override
  double get waveStretch => 1;
  @override
  double get visualPhase => 0;
  @override
  double get binauralPhase => 0;
  @override
  double get breathPulse => 0;
  @override
  double get glowIntensity => 0;
  @override
  double get hemisphericCoherence => 0;
}

void main() {
  testWidgets('fractal pinch applies cumulative gesture scale only once', (
    tester,
  ) async {
    Sint.testMode = true;
    try {
      await tester.pumpWidget(
        SintMaterialApp(home: const NeomFractalFullscreenPage()),
      );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        final controller = Sint.find<NeomFractalController>();
      controller.animationClock.setVisible(false);
      final initialZoom = controller.fractalEngine.zoom;
      final gesture = tester.widget<GestureDetector>(
        find.byWidgetPredicate(
          (widget) => widget is GestureDetector && widget.onScaleUpdate != null,
        ),
      );
      gesture.onScaleStart!(ScaleStartDetails());
      gesture.onScaleUpdate!(ScaleUpdateDetails(scale: 1.2, pointerCount: 2));
      gesture.onScaleUpdate!(ScaleUpdateDetails(scale: 1.5, pointerCount: 2));
      gesture.onScaleUpdate!(ScaleUpdateDetails(scale: 1.5, pointerCount: 2));
      expect(
        controller.fractalEngine.zoom,
        closeTo(initialZoom * 1.5, 0.000001),
      );
      gesture.onScaleUpdate!(
          ScaleUpdateDetails(scale: 0, pointerCount: 2),
      );
      expect(
        controller.fractalEngine.zoom,
        closeTo(initialZoom * 1.5, 0.000001),
      );
      gesture.onScaleEnd!(ScaleEndDetails());
      gesture.onScaleStart!(ScaleStartDetails());
      gesture.onScaleUpdate!(ScaleUpdateDetails(scale: 2, pointerCount: 2));
      expect(controller.fractalEngine.zoom, closeTo(initialZoom * 3, 0.000001));
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      Sint.reset();
      Sint.testMode = false;
    }
  });

  final pages = <String, Widget Function()>{
    'flocking': () => const NeomFlockingFullscreenPage(),
    'breathing': () => const NeomBreathingFullscreenPage(),
    'fractal': () => const NeomFractalFullscreenPage(),
    'neomatics': () => const NeomaticsFullscreenPage(),
    'mandala': () => const NeuroMandalaFullscreenPage(),
  };
  for (final entry in pages.entries) {
    for (final size in [
      const Size(320, 568),
      const Size(568, 320),
      const Size(1440, 900),
    ]) {
      for (final textScale in [
        1.0,
        if ((entry.key == 'flocking' && size.height == 320) ||
            (entry.key == 'mandala' && size.width == 320))
          2.0,
      ]) {
        testWidgets(
          '${entry.key} with live frequency HUD at $size / text $textScale',
          (tester) async {
            Sint.testMode = true;
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);
            final source = _Signal();
            Sint.put<NeomAudioVisualSignal>(source, permanent: true);
            await tester.pumpWidget(
              SintMaterialApp(
                locale: const Locale('es'),
                translations: _Translations(),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(textScale)),
                  child: child!,
                ),
                home: entry.value(),
              ),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 50));
            expect(find.byType(ExperienceAudioHud), findsOneWidget);
            expect(tester.takeException(), isNull);
            await tester.tap(
              find.byKey(const ValueKey('experience-audio-toggle')),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 50));
            expect(tester.takeException(), isNull);
            await tester.pumpWidget(const SizedBox.shrink());
            Sint.reset();
            source.dispose();
            Sint.testMode = false;
          },
        );
      }
    }
  }
}
