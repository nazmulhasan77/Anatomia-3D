import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/organ_model.dart';

class Organ3DRenderer extends StatefulWidget {
  final OrganModel organ;
  final double height;
  final bool autoRotate;

  const Organ3DRenderer({
    super.key,
    required this.organ,
    this.height = 280,
    this.autoRotate = true,
  });

  @override
  State<Organ3DRenderer> createState() => _Organ3DRendererState();
}

class _Organ3DRendererState extends State<Organ3DRenderer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  double _rotationAngle = 0.0;
  Offset? _lastPanPos;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(() {
        if (widget.autoRotate) {
          setState(() {
            _rotationAngle = (_animController.value * 2 * math.pi);
          });
        }
      });

    if (widget.autoRotate) {
      _animController.repeat();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => _lastPanPos = d.localPosition,
      onPanUpdate: (d) {
        if (_lastPanPos != null) {
          final dx = d.localPosition.dx - _lastPanPos!.dx;
          setState(() {
            _rotationAngle += dx * 0.02;
          });
          _lastPanPos = d.localPosition;
        }
      },
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Sci-fi backdrop spotlight
            Container(
              width: widget.height * 0.8,
              height: widget.height * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondaryCyan.withOpacity(0.18),
                    AppColors.primaryBlue.withOpacity(0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Rotating 3D Organ Canvas
            CustomPaint(
              size: Size(widget.height * 0.9, widget.height * 0.85),
              painter: OrganPainter(
                organId: widget.organ.id,
                rotationAngle: _rotationAngle,
              ),
            ),

            // 360 Hint Pill
            Positioned(
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.threed_rotation, size: 14, color: AppColors.secondaryCyan),
                    SizedBox(width: 6),
                    Text(
                      'Drag to rotate 360°',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrganPainter extends CustomPainter {
  final String organId;
  final double rotationAngle;

  OrganPainter({
    required this.organId,
    required this.rotationAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final cosA = math.cos(rotationAngle);
    final sinA = math.sin(rotationAngle);

    canvas.save();
    canvas.translate(center.dx, center.dy);

    switch (organId.toLowerCase()) {
      case 'heart':
        _drawHeart3D(canvas, size, cosA, sinA);
        break;
      case 'lungs':
        _drawLungs3D(canvas, size, cosA, sinA);
        break;
      case 'brain':
        _drawBrain3D(canvas, size, cosA, sinA);
        break;
      case 'kidney':
        _drawKidney3D(canvas, size, cosA, sinA);
        break;
      case 'liver':
        _drawLiver3D(canvas, size, cosA, sinA);
        break;
      case 'stomach':
        _drawStomach3D(canvas, size, cosA, sinA);
        break;
      case 'bones':
        _drawBones3D(canvas, size, cosA, sinA);
        break;
      case 'muscles':
        _drawMuscles3D(canvas, size, cosA, sinA);
        break;
      case 'eyes':
        _drawEye3D(canvas, size, cosA, sinA);
        break;
      default:
        _drawHeart3D(canvas, size, cosA, sinA);
    }

    canvas.restore();
  }

  void _drawHeart3D(Canvas canvas, Size size, double cosA, double sinA) {
    final r = size.width * 0.36;

    // Aorta Arch (top conduit)
    final aortaPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        colors: [Color(0xFFE53935), Color(0xFFC62828)],
      ).createShader(Rect.fromLTWH(-30, -r * 1.3, 60, 50));

    final aortaPath = Path()
      ..moveTo(cosA * 10 - 20, -r * 0.5)
      ..cubicTo(cosA * 15 - 30, -r * 1.15, cosA * 5 + 30, -r * 1.15, cosA * 8 + 20, -r * 0.5)
      ..close();
    canvas.drawPath(aortaPath, aortaPaint);

    // Vena Cava (blue vessel)
    final venaCavaPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF1976D2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cosA * 8 + 28, -r * 0.7), width: 22, height: 45),
        const Radius.circular(8),
      ),
      venaCavaPaint,
    );

    // Main Heart Muscle (Ventricles & Atria)
    final heartGlow = Paint()
      ..color = const Color(0xFFFF1744).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final heartPath = Path();
    heartPath.moveTo(cosA * 5, r * 0.75); // Apex
    heartPath.cubicTo(
      -r * 1.05 + (cosA * 8),
      -r * 0.1,
      -r * 0.7 + (cosA * 6),
      -r * 0.75,
      cosA * 4 - 8,
      -r * 0.45,
    );
    heartPath.cubicTo(
      r * 0.7 + (cosA * 6),
      -r * 0.75,
      r * 1.05 + (cosA * 8),
      -r * 0.1,
      cosA * 5,
      r * 0.75,
    );
    heartPath.close();

    canvas.drawPath(heartPath, heartGlow);

    final heartPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment(sinA * 0.4 - 0.2, -0.2),
        radius: 0.9,
        colors: const [
          Color(0xFFFF5252),
          Color(0xFFD32F2F),
          Color(0xFF880E4F),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r));

    canvas.drawPath(heartPath, heartPaint);

    // Coronary sulcus and arteries across surface
    final arteryPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = const Color(0xFFFF8A80);

    final sulcus = Path()
      ..moveTo(cosA * 10 - 15, -r * 0.3)
      ..cubicTo(cosA * 15, -r * 0.1, cosA * 10 - 5, r * 0.2, cosA * 8 + 4, r * 0.65);
    canvas.drawPath(sulcus, arteryPaint);
  }

  void _drawLungs3D(Canvas canvas, Size size, double cosA, double sinA) {
    final r = size.width * 0.35;

    // Trachea & Bronchi
    final tracheaPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFCFD8DC);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cosA * 4, -r * 0.8), width: 20, height: 50),
        const Radius.circular(6),
      ),
      tracheaPaint,
    );

    // Left and Right Lungs
    final lungPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment(sinA * 0.3, -0.2),
        colors: const [
          Color(0xFFFF8A80),
          Color(0xFFE57373),
          Color(0xFFC62828),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r));

    // Left Lung
    final leftPath = Path()
      ..moveTo(-12 + (cosA * 6), -r * 0.5)
      ..cubicTo(-r * 0.9 + (cosA * 8), -r * 0.5, -r * 1.1 + (cosA * 10), r * 0.6, -15 + (cosA * 6), r * 0.7)
      ..close();
    canvas.drawPath(leftPath, lungPaint);

    // Right Lung (with cardiac notch)
    final rightPath = Path()
      ..moveTo(12 + (cosA * 6), -r * 0.5)
      ..cubicTo(r * 0.9 + (cosA * 8), -r * 0.5, r * 1.1 + (cosA * 10), r * 0.6, 15 + (cosA * 6), r * 0.7)
      ..close();
    canvas.drawPath(rightPath, lungPaint);

    // Bronchial tree branches
    final treePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = Colors.white.withOpacity(0.35);

    canvas.drawLine(Offset(-12 + (cosA * 6), -r * 0.4), Offset(-r * 0.5, 0), treePaint);
    canvas.drawLine(Offset(12 + (cosA * 6), -r * 0.4), Offset(r * 0.5, 0), treePaint);
  }

  void _drawBrain3D(Canvas canvas, Size size, double cosA, double sinA) {
    final r = size.width * 0.36;

    final brainGlow = Paint()
      ..color = const Color(0xFFF48FB1).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cosA * 8, -10), width: r * 1.9, height: r * 1.4),
      brainGlow,
    );

    final brainPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment(sinA * 0.4, -0.3),
        colors: const [
          Color(0xFFF8BBD0),
          Color(0xFFEC407A),
          Color(0xFFAD1457),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r));

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cosA * 8, -10), width: r * 1.8, height: r * 1.3),
      brainPaint,
    );

    // Convolutions (Gyri & Sulci folds)
    final foldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..color = const Color(0xFF880E4F).withOpacity(0.6);

    for (int i = -3; i <= 3; i++) {
      final path = Path()
        ..moveTo(-r * 0.7 + (i * 12) + (cosA * 6), -r * 0.2 + (i * 10))
        ..cubicTo(
          -r * 0.2 + (cosA * 8),
          -r * 0.5 + (i * 12),
          r * 0.2 + (cosA * 8),
          r * 0.1 + (i * 8),
          r * 0.7 + (cosA * 6),
          -r * 0.1 + (i * 6),
        );
      canvas.drawPath(path, foldPaint);
    }

    // Cerebellum at bottom right/left
    final cerebellumPaint = Paint()..color = const Color(0xFFD81B60);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(-r * 0.4 + (cosA * 6), r * 0.45), width: r * 0.7, height: r * 0.4),
      cerebellumPaint,
    );
  }

  void _drawKidney3D(Canvas canvas, Size size, double cosA, double sinA) {
    final r = size.width * 0.35;

    final kidneyPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment(sinA * 0.4, -0.2),
        colors: const [
          Color(0xFFAB47BC),
          Color(0xFF7B1FA2),
          Color(0xFF4A148C),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r));

    // Bean shape
    final path = Path()
      ..moveTo(cosA * 6, -r * 0.8)
      ..cubicTo(r * 1.1 + (cosA * 8), -r * 0.6, r * 1.1 + (cosA * 8), r * 0.6, cosA * 6, r * 0.8)
      ..cubicTo(-r * 0.1 + (cosA * 4), r * 0.4, -r * 0.1 + (cosA * 4), -r * 0.4, cosA * 6, -r * 0.8)
      ..close();

    canvas.drawPath(path, kidneyPaint);

    // Renal Artery & Vein at hilum
    final artery = Paint()..color = const Color(0xFFFF1744);
    final vein = Paint()..color = const Color(0xFF2979FF);
    canvas.drawCircle(Offset(-r * 0.1 + (cosA * 5), -8), 8, artery);
    canvas.drawCircle(Offset(-r * 0.1 + (cosA * 5), 10), 8, vein);
  }

  void _drawLiver3D(Canvas canvas, Size size, double cosA, double sinA) {
    final r = size.width * 0.36;
    final liverPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment(sinA * 0.4, -0.2),
        colors: const [
          Color(0xFFA1887F),
          Color(0xFF6D4C41),
          Color(0xFF3E2723),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r));

    final path = Path()
      ..moveTo(-r * 0.9 + (cosA * 8), 0)
      ..quadraticBezierTo(-r * 0.5, -r * 0.7, r * 0.9 + (cosA * 8), -r * 0.3)
      ..quadraticBezierTo(r * 0.6, r * 0.6, -r * 0.4, r * 0.5)
      ..close();
    canvas.drawPath(path, liverPaint);
  }

  void _drawStomach3D(Canvas canvas, Size size, double cosA, double sinA) {
    final r = size.width * 0.34;
    final stomachPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment(sinA * 0.3, -0.2),
        colors: const [
          Color(0xFFFFCCBC),
          Color(0xFFFF8A65),
          Color(0xFFD84315),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r));

    // J-shaped stomach
    final path = Path()
      ..moveTo(0, -r * 0.8)
      ..cubicTo(-r * 0.9 + (cosA * 8), -r * 0.4, -r * 0.8 + (cosA * 8), r * 0.7, 0, r * 0.7)
      ..cubicTo(r * 0.6 + (cosA * 6), r * 0.6, r * 0.3, r * 0.1, r * 0.6, 0)
      ..cubicTo(r * 0.1, -r * 0.4, 0, -r * 0.6, 0, -r * 0.8)
      ..close();
    canvas.drawPath(path, stomachPaint);
  }

  void _drawBones3D(Canvas canvas, Size size, double cosA, double sinA) {
    final r = size.width * 0.35;
    final bonePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFF9C4);

    // Realistic femur bone
    final path = Path()
      ..addOval(Rect.fromCenter(center: Offset(-18, -r * 0.7), width: 28, height: 28))
      ..addOval(Rect.fromCenter(center: Offset(18, -r * 0.7), width: 28, height: 28))
      ..addRect(Rect.fromCenter(center: Offset(cosA * 4, 0), width: 24, height: r * 1.3))
      ..addOval(Rect.fromCenter(center: Offset(-20, r * 0.7), width: 30, height: 30))
      ..addOval(Rect.fromCenter(center: Offset(20, r * 0.7), width: 30, height: 30));
    canvas.drawPath(path, bonePaint);
  }

  void _drawMuscles3D(Canvas canvas, Size size, double cosA, double sinA) {
    final r = size.width * 0.35;
    final musclePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment(sinA * 0.3, -0.2),
        colors: const [
          Color(0xFFE53935),
          Color(0xFFC62828),
          Color(0xFFB71C1C),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cosA * 6, 0), width: r * 1.5, height: r * 1.4),
        const Radius.circular(24),
      ),
      musclePaint,
    );
  }

  void _drawEye3D(Canvas canvas, Size size, double cosA, double sinA) {
    final r = size.width * 0.36;

    // Eyeball Sclera
    canvas.drawCircle(Offset.zero, r, Paint()..color = const Color(0xFFECEFF1));

    // Iris (following rotation)
    final irisCenter = Offset(sinA * r * 0.4, 0);
    canvas.drawCircle(
      irisCenter,
      r * 0.45,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF00E5FF), Color(0xFF0091EA), Color(0xFF0D47A1)],
        ).createShader(Rect.fromCircle(center: irisCenter, radius: r * 0.45)),
    );

    // Pupil
    canvas.drawCircle(irisCenter, r * 0.2, Paint()..color = Colors.black);

    // Lens glare reflection
    canvas.drawCircle(
      irisCenter + const Offset(-8, -8),
      6,
      Paint()..color = Colors.white.withOpacity(0.8),
    );
  }

  @override
  bool shouldRepaint(covariant OrganPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.organId != organId;
  }
}
