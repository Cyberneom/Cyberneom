import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:neom_core/domain/model/neom/neom_neuro_state.dart';
import 'package:neom_experiences/engine/neom_flocking_engine.dart';
import 'package:neom_experiences/engine/neomatics_engine.dart';
import 'package:neom_experiences/engine/neuromandala_engine.dart';
import 'package:neom_experiences/ui/painters/neom_flocking_painter.dart';
import 'package:neom_experiences/ui/painters/neomatics_painter.dart';
import 'package:neom_experiences/ui/painters/neuromandala_painter.dart';

/// Visual experience types available for state sessions.
enum StateVisualType { flocking, breathing, fractals, neomatics, neuroMandala }

/// Maps a binaural beat state to the most appropriate visual experience.
///
/// The mapping is by the *nature* of the state, not aesthetics:
/// - sleep → mandala (hypnotic, slow-growing sacred geometry)
/// - calm → breathing circles (parasympathetic sync)
/// - focus → Chladni/neomatics (structured, precise patterns)
/// - creativity → mandala (generative, constructive)
/// - neutral → flocking (organic, emergent, introductory)
/// - integration → neomatics (whole-brain, resonance patterns)
StateVisualType _visualForState(NeomNeuroState state) {
  return switch (state) {
    NeomNeuroState.sleep      => StateVisualType.neuroMandala,
    NeomNeuroState.calm       => StateVisualType.breathing,
    NeomNeuroState.focus      => StateVisualType.neomatics,
    NeomNeuroState.creativity => StateVisualType.neuroMandala,
    NeomNeuroState.neutral    => StateVisualType.flocking,
    NeomNeuroState.integration => StateVisualType.neomatics,
  };
}

/// Bridge between neom_states and neom_experiences.
///
/// Dispatches to the appropriate visual engine based on the binaural beat.
/// This file lives in Cyberneom (app layer) because it imports both
/// neom_states and neom_experiences — modules never import each other.
Widget buildStateVisualLayer({
  required double binauralBeatHz,
  required double pulseFrequencyHz,
  required Color screenColor,
}) {
  final neuroState = NeomNeuroState.fromBinauralBeatHz(binauralBeatHz);
  final visualType = _visualForState(neuroState);

  return switch (visualType) {
    StateVisualType.flocking => _FlockingLayer(
      neuroState: neuroState,
      screenColor: screenColor,
    ),
    StateVisualType.breathing => _BreathingLayer(
      pulseFrequencyHz: pulseFrequencyHz,
      screenColor: screenColor,
    ),
    StateVisualType.neomatics => _NeomaticsLayer(
      neuroState: neuroState,
      screenColor: screenColor,
      binauralBeatHz: binauralBeatHz,
    ),
    StateVisualType.neuroMandala => _MandalaLayer(
      neuroState: neuroState,
      screenColor: screenColor,
      pulseFrequencyHz: pulseFrequencyHz,
    ),
    StateVisualType.fractals => _FractalLayer(
      screenColor: screenColor,
      pulseFrequencyHz: pulseFrequencyHz,
    ),
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// FLOCKING — organic emergent behavior (neutral, first-contact, energy)
// ─────────────────────────────────────────────────────────────────────────────

class _FlockingLayer extends StatefulWidget {
  final NeomNeuroState neuroState;
  final Color screenColor;
  const _FlockingLayer({required this.neuroState, required this.screenColor});

  @override
  State<_FlockingLayer> createState() => _FlockingLayerState();
}

class _FlockingLayerState extends State<_FlockingLayer>
    with SingleTickerProviderStateMixin {
  late final NeomFlockingEngine _engine;
  late final AnimationController _ticker;

  @override
  void initState() {
    super.initState();
    _engine = NeomFlockingEngine();
    _engine.setColorPalette(widget.neuroState.name);
    _ticker = AnimationController(vsync: this, duration: const Duration(hours: 1))
      ..repeat()
      ..addListener(() => _engine.update());
  }

  @override
  void didUpdateWidget(covariant _FlockingLayer old) {
    super.didUpdateWidget(old);
    if (old.neuroState != widget.neuroState) {
      _engine.setColorPalette(widget.neuroState.name);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ticker,
      builder: (_, _) => CustomPaint(
        painter: NeomFlockingPainter(engine: _engine),
        size: Size.infinite,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BREATHING — expanding/contracting concentric circles (calm, relief, heart)
// ─────────────────────────────────────────────────────────────────────────────

class _BreathingLayer extends StatefulWidget {
  final double pulseFrequencyHz;
  final Color screenColor;
  const _BreathingLayer({required this.pulseFrequencyHz, required this.screenColor});

  @override
  State<_BreathingLayer> createState() => _BreathingLayerState();
}

class _BreathingLayerState extends State<_BreathingLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    final seconds = widget.pulseFrequencyHz > 0
        ? (1.0 / widget.pulseFrequencyHz).clamp(0.5, 8.0)
        : 4.0;
    _anim = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (seconds * 1000).toInt()),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => CustomPaint(
        painter: _BreathingCirclesPainter(
          progress: _anim.value,
          color: widget.screenColor,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _BreathingCirclesPainter extends CustomPainter {
  final double progress;
  final Color color;
  _BreathingCirclesPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.shortestSide * 0.45;
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5;

    for (int i = 0; i < 7; i++) {
      final phase = (progress + i * 0.12) % 1.0;
      final radius = maxRadius * (0.15 + phase * 0.85);
      final opacity = (1.0 - phase).clamp(0.0, 0.4);
      paint.color = color.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, paint);
    }

    // Core circle — solid, gentle glow.
    final coreRadius = maxRadius * (0.08 + progress * 0.07);
    final corePaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, coreRadius, corePaint);
  }

  @override
  bool shouldRepaint(covariant _BreathingCirclesPainter old) =>
      old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// NEOMATICS (CHLADNI) — resonance plate patterns (focus, presence, solfeggio)
// ─────────────────────────────────────────────────────────────────────────────

class _NeomaticsLayer extends StatefulWidget {
  final NeomNeuroState neuroState;
  final Color screenColor;
  final double binauralBeatHz;
  const _NeomaticsLayer({
    required this.neuroState,
    required this.screenColor,
    required this.binauralBeatHz,
  });

  @override
  State<_NeomaticsLayer> createState() => _NeomaticsLayerState();
}

class _NeomaticsLayerState extends State<_NeomaticsLayer>
    with SingleTickerProviderStateMixin {
  late final NeomaticsEngine _engine;
  late final AnimationController _ticker;

  @override
  void initState() {
    super.initState();
    _engine = NeomaticsEngine();
    _engine.setNeuroState(widget.neuroState);
    _ticker = AnimationController(vsync: this, duration: const Duration(hours: 1))
      ..repeat()
      ..addListener(() => _engine.updateFromAudio(
        frequency: widget.binauralBeatHz * 10, // Scale beat to audible range for mode selection
        amplitude: 0.7,
        beat: widget.binauralBeatHz / 40.0, // Normalize to 0-1
      ));
  }

  @override
  void didUpdateWidget(covariant _NeomaticsLayer old) {
    super.didUpdateWidget(old);
    if (old.neuroState != widget.neuroState) {
      _engine.setNeuroState(widget.neuroState);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ticker,
      builder: (_, _) => CustomPaint(
        painter: NeomaticsPainter(engine: _engine),
        size: Size.infinite,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NEUROMANDALA — sacred geometry growth (sleep, creativity, meditate)
// ─────────────────────────────────────────────────────────────────────────────

class _MandalaLayer extends StatefulWidget {
  final NeomNeuroState neuroState;
  final Color screenColor;
  final double pulseFrequencyHz;
  const _MandalaLayer({
    required this.neuroState,
    required this.screenColor,
    required this.pulseFrequencyHz,
  });

  @override
  State<_MandalaLayer> createState() => _MandalaLayerState();
}

class _MandalaLayerState extends State<_MandalaLayer>
    with SingleTickerProviderStateMixin {
  late final NeuroMandalaEngine _engine;
  late final AnimationController _ticker;

  @override
  void initState() {
    super.initState();
    _engine = NeuroMandalaEngine();
    _engine.setNeuroState(widget.neuroState);
    final breathSec = widget.pulseFrequencyHz > 0
        ? (1.0 / widget.pulseFrequencyHz).clamp(1.0, 10.0)
        : 4.0;
    _ticker = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (breathSec * 1000).toInt()),
    )..repeat(reverse: true);
    _ticker.addListener(() {
      _engine.tick(1 / 60, breathPulse: _ticker.value);
    });
  }

  @override
  void didUpdateWidget(covariant _MandalaLayer old) {
    super.didUpdateWidget(old);
    if (old.neuroState != widget.neuroState) {
      _engine.setNeuroState(widget.neuroState);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ticker,
      builder: (_, _) => CustomPaint(
        painter: NeuroMandalaPainter(engine: _engine),
        size: Size.infinite,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FRACTALS — infinite Mandelbrot zoom (meditate, lucid)
// ─────────────────────────────────────────────────────────────────────────────

class _FractalLayer extends StatefulWidget {
  final Color screenColor;
  final double pulseFrequencyHz;
  const _FractalLayer({required this.screenColor, required this.pulseFrequencyHz});

  @override
  State<_FractalLayer> createState() => _FractalLayerState();
}

class _FractalLayerState extends State<_FractalLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    // Slow continuous animation — the fractal "breathes" with zoom.
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => CustomPaint(
        painter: _SimpleFractalPainter(
          time: _anim.value,
          color: widget.screenColor,
        ),
        size: Size.infinite,
      ),
    );
  }
}

/// Lightweight fractal painter — recursive branching tree that breathes.
/// Not a full Mandelbrot (too heavy for overlay), but visually contemplative.
class _SimpleFractalPainter extends CustomPainter {
  final double time;
  final Color color;
  _SimpleFractalPainter({required this.time, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final baseY = size.height * 0.85;
    final maxLen = size.height * 0.25;

    // Breathing angle offset.
    final breathAngle = math.sin(time * math.pi * 2) * 0.08;

    _drawBranch(
      canvas, paint, cx, baseY, maxLen,
      -math.pi / 2 + breathAngle, 9, 1.0,
    );
  }

  void _drawBranch(
    Canvas canvas, Paint paint,
    double x, double y, double len,
    double angle, int depth, double opacity,
  ) {
    if (depth <= 0 || len < 2) return;

    final endX = x + math.cos(angle) * len;
    final endY = y + math.sin(angle) * len;

    paint.color = color.withValues(alpha: (opacity * 0.5).clamp(0.02, 0.5));
    paint.strokeWidth = (depth * 0.4).clamp(0.5, 3.0);

    canvas.drawLine(Offset(x, y), Offset(endX, endY), paint);

    final spread = 0.45 + math.sin(time * math.pi * 4 + depth) * 0.1;
    final shrink = 0.68;

    _drawBranch(canvas, paint, endX, endY, len * shrink,
        angle - spread, depth - 1, opacity * 0.85);
    _drawBranch(canvas, paint, endX, endY, len * shrink,
        angle + spread, depth - 1, opacity * 0.85);
  }

  @override
  bool shouldRepaint(covariant _SimpleFractalPainter old) =>
      old.time != time;
}
