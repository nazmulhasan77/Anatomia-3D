import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class PhysiologicalAnimationCanvas extends StatefulWidget {
  final String organId;
  final bool isPlaying;
  final double playbackProgress; // 0.0 to 1.0 (from scrubber)
  final double height;

  const PhysiologicalAnimationCanvas({
    super.key,
    required this.organId,
    this.isPlaying = true,
    this.playbackProgress = 0.5,
    this.height = 320,
  });

  @override
  State<PhysiologicalAnimationCanvas> createState() =>
      _PhysiologicalAnimationCanvasState();
}

class _PhysiologicalAnimationCanvasState
    extends State<PhysiologicalAnimationCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _cycleController;

  @override
  void initState() {
    super.initState();
    _cycleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant PhysiologicalAnimationCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_cycleController.isAnimating) {
      _cycleController.repeat();
    } else if (!widget.isPlaying && _cycleController.isAnimating) {
      _cycleController.stop();
    }
  }

  @override
  void dispose() {
    _cycleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cycleController,
      builder: (context, child) {
        final progress = widget.isPlaying
            ? _cycleController.value
            : widget.playbackProgress;

        return SizedBox(
          height: widget.height,
          width: double.infinity,
          child: CustomPaint(
            size: Size(double.infinity, widget.height),
            painter: PhysiologyPainter(
              organId: widget.organId,
              progress: progress,
            ),
          ),
        );
      },
    );
  }
}

class PhysiologyPainter extends CustomPainter {
  final String organId;
  final double progress; // 0.0 to 1.0

  PhysiologyPainter({
    required this.organId,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (organId.toLowerCase()) {
      case 'lungs':
        _paintLungsBreathing(canvas, size, center);
        break;
      case 'heart':
        _paintHeartPumping(canvas, size, center);
        break;
      case 'brain':
        _paintBrainNeuralTransmission(canvas, size, center);
        break;
      case 'kidney':
        _paintKidneyFiltration(canvas, size, center);
        break;
      default:
        _paintLungsBreathing(canvas, size, center);
    }
  }

  void _paintLungsBreathing(Canvas canvas, Size size, Offset center) {
    // Inhale / Exhale phase
    // 0.0 -> 0.5: Inhale (expansion), 0.5 -> 1.0: Exhale (deflation)
    final breathPhase = math.sin(progress * 2 * math.pi);
    final scale = 1.0 + (breathPhase * 0.12);
    final diaphragmY = center.dy + 75 + (breathPhase * 15);

    // Diaphragm muscle moving up and down
    final diaphragmPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = const Color(0xFFFF7043).withOpacity(0.85);

    final diaphragmPath = Path()
      ..moveTo(center.dx - 120, diaphragmY)
      ..quadraticBezierTo(center.dx, diaphragmY - 30, center.dx + 120, diaphragmY);
    canvas.drawPath(diaphragmPath, diaphragmPaint);

    // Trachea conduit
    final tracheaRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 70),
      width: 22,
      height: 60,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(tracheaRect, const Radius.circular(6)),
      Paint()..color = const Color(0xFF90A4AE),
    );

    // Expanding Lungs
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);

    // Glow effect during max oxygen absorption
    if (breathPhase > 0) {
      final glowPaint = Paint()
        ..color = AppColors.secondaryCyan.withOpacity(breathPhase * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawCircle(const Offset(-45, 0), 65, glowPaint);
      canvas.drawCircle(const Offset(45, 0), 65, glowPaint);
    }

    final lungPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(const Color(0xFFEF5350), const Color(0xFF00E5FF), (breathPhase.clamp(0.0, 1.0)) * 0.5)!,
          const Color(0xFFC62828),
        ],
      ).createShader(const Rect.fromLTWH(-100, -70, 200, 140));

    // Left Lung
    final leftPath = Path()
      ..moveTo(-12, -40)
      ..cubicTo(-90, -40, -95, 60, -12, 60)
      ..close();
    canvas.drawPath(leftPath, lungPaint);

    // Right Lung
    final rightPath = Path()
      ..moveTo(12, -40)
      ..cubicTo(90, -40, 95, 60, 12, 60)
      ..close();
    canvas.drawPath(rightPath, lungPaint);

    canvas.restore();

    // Flowing Oxygen & Carbon Dioxide Particles
    final isInhaling = breathPhase > 0;
    final particleCount = 14;
    final particlePaint = Paint()
      ..color = isInhaling ? AppColors.secondaryCyan : const Color(0xFFFFB74D)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < particleCount; i++) {
      final particleOffset = (progress * 2 + (i / particleCount)) % 1.0;
      final py = (center.dy - 100) + (particleOffset * 140);
      final side = (i % 2 == 0) ? -1 : 1;
      final px = center.dx + (particleOffset * 50 * side * (particleOffset > 0.4 ? 1 : 0.2));

      canvas.drawCircle(Offset(px, py), 3.5, particlePaint);
    }
  }

  void _paintHeartPumping(Canvas canvas, Size size, Offset center) {
    // Cardiac cycle: rapid ventricular systole followed by diastole
    final beatTime = (progress * 2) % 1.0;
    final systolicPulse = math.sin(beatTime * math.pi);
    final scale = 1.0 + (systolicPulse > 0 ? systolicPulse * 0.15 : 0.0);

    // Heart chamber body
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);

    // Pulsing ventricular glow
    final pulseGlow = Paint()
      ..color = const Color(0xFFFF1744).withOpacity(systolicPulse * 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawCircle(Offset.zero, 75, pulseGlow);

    final heartMuscle = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFF5252), Color(0xFFB71C1C), Color(0xFF880E4F)],
      ).createShader(const Rect.fromLTWH(-70, -70, 140, 140));

    final path = Path()
      ..moveTo(0, 65)
      ..cubicTo(-80, 0, -60, -65, 0, -40)
      ..cubicTo(60, -65, 80, 0, 0, 65);
    canvas.drawPath(path, heartMuscle);

    canvas.restore();

    // Flowing Blood Stream Particles (Arterial Red out, Venous Blue in)
    for (int i = 0; i < 16; i++) {
      final t = (progress + (i / 16)) % 1.0;

      // Oxygenated blood exiting aorta at top
      final aortaY = center.dy - 40 - (t * 80);
      final aortaX = center.dx + math.sin(t * 4) * 20;
      canvas.drawCircle(
        Offset(aortaX, aortaY),
        4.0,
        Paint()..color = const Color(0xFFFF1744),
      );

      // Deoxygenated blood entering vena cava
      final venaY = center.dy - 110 + (t * 70);
      final venaX = center.dx + 40;
      canvas.drawCircle(
        Offset(venaX, venaY),
        3.5,
        Paint()..color = const Color(0xFF2979FF),
      );
    }
  }

  void _paintBrainNeuralTransmission(Canvas canvas, Size size, Offset center) {
    // Neural synaptic firing simulation
    final nodePaint = Paint()
      ..color = AppColors.secondaryCyan
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.primaryBlue.withOpacity(0.4)
      ..strokeWidth = 1.5;

    final nodes = [
      Offset(center.dx - 80, center.dy - 40),
      Offset(center.dx - 30, center.dy - 70),
      Offset(center.dx + 40, center.dy - 60),
      Offset(center.dx + 85, center.dy - 30),
      Offset(center.dx - 50, center.dy + 20),
      Offset(center.dx + 20, center.dy + 10),
      Offset(center.dx + 70, center.dy + 45),
      Offset(center.dx - 10, center.dy + 65),
    ];

    // Connect neural synapses
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        if ((nodes[i] - nodes[j]).distance < 90) {
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }

    // Draw nodes
    for (final node in nodes) {
      canvas.drawCircle(node, 6, nodePaint);
    }

    // Traveling Action Potential impulses
    final pulsePaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (int i = 0; i < nodes.length - 1; i++) {
      final start = nodes[i];
      final end = nodes[(i + 2) % nodes.length];
      final currentPos = Offset.lerp(start, end, (progress * 2 + (i * 0.2)) % 1.0)!;
      canvas.drawCircle(currentPos, 4.5, pulsePaint);
    }
  }

  void _paintKidneyFiltration(Canvas canvas, Size size, Offset center) {
    // Nephron filtration: Blood entering -> Filtration unit -> Purified blood & Urine
    final kidneyShape = Path()
      ..moveTo(center.dx, center.dy - 70)
      ..cubicTo(center.dx + 80, center.dy - 50, center.dx + 80, center.dy + 50, center.dx, center.dy + 70)
      ..cubicTo(center.dx - 20, center.dy + 30, center.dx - 20, center.dy - 30, center.dx, center.dy - 70);

    final kidneyPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFAB47BC), Color(0xFF4A148C)],
      ).createShader(Rect.fromCircle(center: center, radius: 80));
    canvas.drawPath(kidneyShape, kidneyPaint);

    // Filtration glow center
    final filterGlow = Paint()
      ..color = AppColors.secondaryCyan.withOpacity(0.5 + (math.sin(progress * 2 * math.pi) * 0.3))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(Offset(center.dx + 25, center.dy), 30, filterGlow);

    // Particles representing filtration of metabolic wastes
    for (int i = 0; i < 10; i++) {
      final t = (progress + (i / 10)) % 1.0;
      // Urine descending down ureter
      final uy = center.dy + 20 + (t * 70);
      final ux = center.dx - 10 + (t * 8);
      canvas.drawCircle(Offset(ux, uy), 3.0, Paint()..color = const Color(0xFFFFD54F));
    }
  }

  @override
  bool shouldRepaint(covariant PhysiologyPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.organId != organId;
  }
}
