import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/organ_model.dart';
import '../providers/anatomy_provider.dart';

/// Clean abstraction interface to enable seamless swap to Unity 3D Engine in future phases
abstract class IAnatomy3DEngine {
  void rotateModel(double deltaAngle);
  void zoomModel(double scaleFactor);
  void toggleLayer(String layerName, bool isVisible);
  void selectOrgan(String organId);
  void setGender(BodyGender gender);
  void setCameraAngle(BodyAngle angle);
}

class Custom3DBodyCanvas extends StatefulWidget {
  final AnatomyProvider provider;
  final ValueChanged<OrganModel>? onOrganTapped;

  const Custom3DBodyCanvas({
    super.key,
    required this.provider,
    this.onOrganTapped,
  });

  @override
  State<Custom3DBodyCanvas> createState() => _Custom3DBodyCanvasState();
}

class _Custom3DBodyCanvasState extends State<Custom3DBodyCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Offset? _lastPanPos;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.provider, _pulseController]),
      builder: (context, child) {
        return GestureDetector(
          onScaleStart: (details) {
            _lastPanPos = details.localFocalPoint;
          },
          onScaleUpdate: (details) {
            if (_lastPanPos != null) {
              final dx = details.localFocalPoint.dx - _lastPanPos!.dx;
              if (dx.abs() > 0.5) {
                // Rotate based on horizontal drag
                widget.provider.updateRotation(dx * 0.015);
              }
              _lastPanPos = details.localFocalPoint;
            }
            if (details.scale != 1.0) {
              widget.provider.updateZoom(details.scale > 1.0 ? 1.02 : 0.98);
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // 3D Canvas
                  CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: AnatomyBodyPainter(
                      provider: widget.provider,
                      pulseValue: _pulseController.value,
                    ),
                  ),

                  // Hotspot pins layer for selectable organs
                  ..._buildHotspotPins(constraints.maxWidth, constraints.maxHeight),
                ],
              );
            },
          ),
        );
      },
    );
  }

  List<Widget> _buildHotspotPins(double width, double height) {
    if (!widget.provider.organsVisible) return [];

    // Base organ definitions with 3D relative positions
    final organPins = [
      {'id': 'brain', 'name': 'Brain', 'x': 0.0, 'y': -0.38, 'z': 0.0},
      {'id': 'lungs', 'name': 'Lungs', 'x': -0.06, 'y': -0.19, 'z': 0.05},
      {'id': 'heart', 'name': 'Heart', 'x': 0.04, 'y': -0.17, 'z': 0.08},
      {'id': 'liver', 'name': 'Liver', 'x': 0.08, 'y': -0.07, 'z': 0.05},
      {'id': 'stomach', 'name': 'Stomach', 'x': -0.06, 'y': -0.05, 'z': 0.04},
      {'id': 'kidney', 'name': 'Kidney', 'x': 0.06, 'y': 0.02, 'z': -0.06},
    ];

    final rotY = widget.provider.rotationY;
    final zoom = widget.provider.zoomScale;
    final centerX = width / 2;
    final centerY = height / 2;
    final modelHeight = height * 0.75 * zoom;

    final widgets = <Widget>[];

    for (final pin in organPins) {
      final origX = (pin['x'] as double) * modelHeight;
      final origY = (pin['y'] as double) * modelHeight;
      final origZ = (pin['z'] as double) * modelHeight;

      // 3D Rotation transformation around Y axis
      final cosA = math.cos(rotY);
      final sinA = math.sin(rotY);
      final rotatedX = origX * cosA + origZ * sinA;
      final rotatedZ = -origX * sinA + origZ * cosA;

      // Perspective projection
      final depth = (rotatedZ / 400.0) + 1.0;
      if (depth < 0.2) continue; // Behind viewpoint clipping

      final screenX = centerX + (rotatedX * depth);
      final screenY = centerY + (origY * depth);

      final isSelected = widget.provider.selectedOrgan?.id == pin['id'];

      // Only show if roughly facing camera (rotatedZ > -50)
      final opacity = (rotatedZ > -60 ? 1.0 : 0.3).clamp(0.0, 1.0);

      widgets.add(
        Positioned(
          left: screenX - 22,
          top: screenY - 22,
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: () {
                widget.provider.selectOrganById(pin['id'] as String);
                if (widget.onOrganTapped != null && widget.provider.selectedOrgan != null) {
                  widget.onOrganTapped!(widget.provider.selectedOrgan!);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isSelected ? 48 : 40,
                height: isSelected ? 48 : 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.secondaryCyan
                      : AppColors.primaryBlue.withOpacity(0.85),
                  border: Border.all(
                    color: Colors.white,
                    width: isSelected ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isSelected ? AppColors.secondaryCyan : AppColors.primaryBlue)
                          .withOpacity(0.6),
                      blurRadius: isSelected ? 16 : 8,
                      spreadRadius: isSelected ? 3 : 1,
                    ),
                  ],
                ),
                child: Center(
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.black)
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}

class AnatomyBodyPainter extends CustomPainter {
  final AnatomyProvider provider;
  final double pulseValue;

  AnatomyBodyPainter({
    required this.provider,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final zoom = provider.zoomScale;
    final rotY = provider.rotationY;

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.scale(zoom);

    // Coordinate rotation helpers
    final cosA = math.cos(rotY);
    final sinA = math.sin(rotY);

    // 1. Grid / Sci-Fi Radial Background Pedestal
    _drawMedicalPlatform(canvas, size, rotY);

    // 2. Render Layers according to toggles and depth
    if (provider.bonesVisible) {
      _drawSkeletalSystem(canvas, size, cosA, sinA);
    }

    if (provider.nervousSystemVisible) {
      _drawNervousSystem(canvas, size, cosA, sinA);
    }

    if (provider.bloodVesselsVisible) {
      _drawCardiovascularVessels(canvas, size, cosA, sinA);
    }

    if (provider.organsVisible) {
      _drawInternalOrgans(canvas, size, cosA, sinA);
    }

    if (provider.musclesVisible) {
      _drawMuscularSystem(canvas, size, cosA, sinA);
    }

    if (provider.skinVisible) {
      _drawSkinLayer(canvas, size, cosA, sinA);
    }

    canvas.restore();
  }

  void _drawMedicalPlatform(Canvas canvas, Size size, double rotY) {
    final radius = size.width * 0.38;
    final platformY = size.height * 0.42;

    final ovalRect = Rect.fromCenter(
      center: Offset(0, platformY),
      width: radius * 2,
      height: radius * 0.45,
    );

    // Outer glow ring
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = RadialGradient(
        colors: [
          AppColors.secondaryCyan.withOpacity(0.5),
          AppColors.primaryBlue.withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(ovalRect);

    canvas.drawOval(ovalRect, ringPaint);

    // Concentric grid lines
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.secondaryCyan.withOpacity(0.2);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, platformY),
        width: radius * 1.4,
        height: radius * 0.3,
      ),
      gridPaint,
    );

    // Degree tick marks
    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi / 6) + rotY;
      final tx = math.cos(angle) * (radius * 0.95);
      final ty = platformY + math.sin(angle) * (radius * 0.2);
      canvas.drawCircle(
        Offset(tx, ty),
        1.5,
        Paint()..color = AppColors.secondaryCyan.withOpacity(0.4),
      );
    }
  }

  void _drawSkinLayer(Canvas canvas, Size size, double cosA, double sinA) {
    final h = size.height * 0.7;
    final w = size.width * 0.38;

    final skinPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.skinLayer.withOpacity(0.35 + (cosA.abs() * 0.1)),
          AppColors.skinLayer.withOpacity(0.25),
        ],
      ).createShader(Rect.fromLTWH(-w / 2, -h / 2, w, h));

    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = AppColors.secondaryCyan.withOpacity(0.5);

    final path = _getBodySilhouettePath(w, h, cosA);
    canvas.drawPath(path, skinPaint);
    canvas.drawPath(path, outlinePaint);
  }

  void _drawMuscularSystem(Canvas canvas, Size size, double cosA, double sinA) {
    final h = size.height * 0.7;
    final w = size.width * 0.36;

    final musclePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFC62828).withOpacity(0.75),
          const Color(0xFF8E0000).withOpacity(0.85),
        ],
      ).createShader(Rect.fromLTWH(-w / 2, -h / 2, w, h));

    final striationPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withOpacity(0.25);

    // Torso pectorals & abdominals
    final chestPath = Path();
    chestPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cosA * 2, -h * 0.22), width: w * 0.65, height: h * 0.12),
      const Radius.circular(14),
    ));
    canvas.drawPath(chestPath, musclePaint);

    // Six pack abdominal segments
    for (int row = 0; row < 3; row++) {
      final y = -h * 0.13 + (row * (h * 0.045));
      // Left ab
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(-w * 0.12 + (cosA * 2), y), width: w * 0.18, height: h * 0.038),
          const Radius.circular(6),
        ),
        musclePaint,
      );
      // Right ab
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(w * 0.12 + (cosA * 2), y), width: w * 0.18, height: h * 0.038),
          const Radius.circular(6),
        ),
        musclePaint,
      );
    }

    // Muscle fiber lines
    for (int i = -3; i <= 3; i++) {
      canvas.drawLine(
        Offset(i * 12.0, -h * 0.24),
        Offset(i * 10.0, -h * 0.20),
        striationPaint,
      );
    }

    // Quadriceps & Thigh muscles
    final legPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFB71C1C).withOpacity(0.8);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(-w * 0.22, h * 0.16), width: w * 0.22, height: h * 0.26),
        const Radius.circular(12),
      ),
      legPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.22, h * 0.16), width: w * 0.22, height: h * 0.26),
        const Radius.circular(12),
      ),
      legPaint,
    );
  }

  void _drawSkeletalSystem(Canvas canvas, Size size, double cosA, double sinA) {
    final h = size.height * 0.7;
    final w = size.width * 0.35;

    final bonePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = const Color(0xFFFFF8E1).withOpacity(0.85);

    final skullPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = const Color(0xFFFFF8E1).withOpacity(0.9);

    // Cranium / Skull
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -h * 0.38), width: w * 0.35, height: h * 0.12),
      skullPaint,
    );

    // Vertebral column (Spine)
    final spinePath = Path();
    spinePath.moveTo(0, -h * 0.32);
    spinePath.lineTo(0, h * 0.04);
    canvas.drawPath(
      spinePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..color = const Color(0xFFFFF8E1).withOpacity(0.7),
    );

    // Ribcage arcs
    for (int i = 0; i < 6; i++) {
      final y = -h * 0.28 + (i * h * 0.032);
      final ribWidth = (w * 0.45) * (1.0 - (i * 0.08));

      // Left rib
      canvas.drawArc(
        Rect.fromCenter(center: Offset(-ribWidth * 0.45, y), width: ribWidth, height: 16),
        math.pi * 0.1,
        math.pi * 0.8,
        false,
        bonePaint,
      );

      // Right rib
      canvas.drawArc(
        Rect.fromCenter(center: Offset(ribWidth * 0.45, y), width: ribWidth, height: 16),
        math.pi * 0.1,
        math.pi * 0.8,
        false,
        bonePaint,
      );
    }

    // Pelvis girdle
    final pelvisPath = Path()
      ..moveTo(-w * 0.35, -h * 0.02)
      ..quadraticBezierTo(0, h * 0.06, w * 0.35, -h * 0.02)
      ..quadraticBezierTo(0, h * 0.02, -w * 0.35, -h * 0.02);
    canvas.drawPath(pelvisPath, bonePaint);

    // Femurs (Leg bones)
    canvas.drawLine(Offset(-w * 0.22, h * 0.04), Offset(-w * 0.20, h * 0.30), bonePaint);
    canvas.drawLine(Offset(w * 0.22, h * 0.04), Offset(w * 0.20, h * 0.30), bonePaint);

    // Clavicles (Collar bones)
    canvas.drawLine(Offset(-w * 0.4, -h * 0.29), Offset(0, -h * 0.30), bonePaint);
    canvas.drawLine(Offset(0, -h * 0.30), Offset(w * 0.4, -h * 0.29), bonePaint);
  }

  void _drawInternalOrgans(Canvas canvas, Size size, double cosA, double sinA) {
    final h = size.height * 0.7;
    final w = size.width * 0.35;

    // 1. Brain
    final brainGlow = Paint()
      ..color = const Color(0xFFFF80AB).withOpacity(0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -h * 0.38), width: w * 0.28, height: h * 0.09),
      brainGlow,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -h * 0.38), width: w * 0.24, height: h * 0.08),
      Paint()..color = const Color(0xFFF48FB1),
    );

    // 2. Lungs (Left & Right)
    final lungPaint = Paint()..color = const Color(0xFFE57373).withOpacity(0.85);
    final lungGlow = Paint()
      ..color = const Color(0xFFFF5252).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Left lung (anatomical right)
    final leftLungRect = Rect.fromCenter(center: Offset(-w * 0.18, -h * 0.20), width: w * 0.22, height: h * 0.16);
    canvas.drawRRect(RRect.fromRectAndRadius(leftLungRect, const Radius.circular(16)), lungGlow);
    canvas.drawRRect(RRect.fromRectAndRadius(leftLungRect, const Radius.circular(16)), lungPaint);

    // Right lung
    final rightLungRect = Rect.fromCenter(center: Offset(w * 0.18, -h * 0.20), width: w * 0.22, height: h * 0.16);
    canvas.drawRRect(RRect.fromRectAndRadius(rightLungRect, const Radius.circular(16)), lungGlow);
    canvas.drawRRect(RRect.fromRectAndRadius(rightLungRect, const Radius.circular(16)), lungPaint);

    // 3. Heart (Pulsing with heartbeat)
    final heartCenter = Offset(w * 0.04 + (cosA * 3), -h * 0.18);
    final heartScale = 1.0 + (pulseValue * 0.12);

    final heartGlow = Paint()
      ..color = const Color(0xFFFF1744).withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(heartCenter, (w * 0.12) * heartScale, heartGlow);

    final heartPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFF1744), Color(0xFFB71C1C)],
      ).createShader(Rect.fromCircle(center: heartCenter, radius: w * 0.1));
    canvas.drawCircle(heartCenter, (w * 0.09) * heartScale, heartPaint);

    // 4. Liver
    final liverRect = Rect.fromCenter(center: Offset(w * 0.15, -h * 0.07), width: w * 0.32, height: h * 0.09);
    canvas.drawRRect(
      RRect.fromRectAndRadius(liverRect, const Radius.circular(12)),
      Paint()..color = const Color(0xFF8D6E63),
    );

    // 5. Stomach
    final stomachRect = Rect.fromCenter(center: Offset(-w * 0.12, -h * 0.06), width: w * 0.22, height: h * 0.08);
    canvas.drawRRect(
      RRect.fromRectAndRadius(stomachRect, const Radius.circular(12)),
      Paint()..color = const Color(0xFFFFAB91),
    );

    // 6. Kidneys
    final kidneyPaint = Paint()..color = const Color(0xFF8E24AA);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(-w * 0.14, 0), width: w * 0.12, height: h * 0.06),
      kidneyPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.14, 0), width: w * 0.12, height: h * 0.06),
      kidneyPaint,
    );
  }

  void _drawCardiovascularVessels(Canvas canvas, Size size, double cosA, double sinA) {
    final h = size.height * 0.7;
    final w = size.width * 0.35;

    final arteryPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = const Color(0xFFFF1744).withOpacity(0.85);

    final veinPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = const Color(0xFF2979FF).withOpacity(0.85);

    // Main Aortic arch & Vena Cava
    final aorta = Path()
      ..moveTo(0, -h * 0.18)
      ..lineTo(-3, h * 0.05);
    canvas.drawPath(aorta, arteryPaint);

    final venaCava = Path()
      ..moveTo(5, -h * 0.18)
      ..lineTo(5, h * 0.05);
    canvas.drawPath(venaCava, veinPaint);

    // Peripheral vessels running through arms
    canvas.drawLine(Offset(0, -h * 0.26), Offset(-w * 0.7, -h * 0.05), arteryPaint);
    canvas.drawLine(Offset(3, -h * 0.26), Offset(-w * 0.68, -h * 0.04), veinPaint);

    canvas.drawLine(Offset(0, -h * 0.26), Offset(w * 0.7, -h * 0.05), arteryPaint);
    canvas.drawLine(Offset(-3, -h * 0.26), Offset(w * 0.68, -h * 0.04), veinPaint);

    // Femoral vessels down thighs
    canvas.drawLine(Offset(-w * 0.1, h * 0.05), Offset(-w * 0.2, h * 0.32), arteryPaint);
    canvas.drawLine(Offset(w * 0.1, h * 0.05), Offset(w * 0.2, h * 0.32), veinPaint);
  }

  void _drawNervousSystem(Canvas canvas, Size size, double cosA, double sinA) {
    final h = size.height * 0.7;
    final w = size.width * 0.35;

    final nervePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xFFFFEA00).withOpacity(0.85);

    // Spinal Cord
    canvas.drawLine(Offset(0, -h * 0.33), Offset(0, h * 0.04), nervePaint);

    // Branching intercostal and peripheral nerves
    for (int i = 0; i < 7; i++) {
      final y = -h * 0.25 + (i * h * 0.04);
      canvas.drawLine(Offset(0, y), Offset(-w * 0.35, y + 8), nervePaint);
      canvas.drawLine(Offset(0, y), Offset(w * 0.35, y + 8), nervePaint);
    }

    // Sciatic nerve branches
    canvas.drawLine(Offset(0, h * 0.02), Offset(-w * 0.18, h * 0.32), nervePaint);
    canvas.drawLine(Offset(0, h * 0.02), Offset(w * 0.18, h * 0.32), nervePaint);
  }

  Path _getBodySilhouettePath(double w, double h, double cosA) {
    final path = Path();
    // Head
    path.addOval(Rect.fromCenter(center: Offset(0, -h * 0.38), width: w * 0.42, height: h * 0.14));
    // Neck
    path.addRect(Rect.fromCenter(center: Offset(0, -h * 0.29), width: w * 0.2, height: h * 0.06));
    // Torso
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(0, -h * 0.12), width: w * 0.78, height: h * 0.30),
      const Radius.circular(22),
    ));
    // Lower body / Pelvis
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(0, h * 0.05), width: w * 0.70, height: h * 0.12),
      const Radius.circular(16),
    ));
    // Left Leg
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(-w * 0.22, h * 0.24), width: w * 0.24, height: h * 0.32),
      const Radius.circular(14),
    ));
    // Right Leg
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.22, h * 0.24), width: w * 0.24, height: h * 0.32),
      const Radius.circular(14),
    ));
    return path;
  }

  @override
  bool shouldRepaint(covariant AnatomyBodyPainter oldDelegate) {
    return oldDelegate.provider.rotationY != provider.rotationY ||
        oldDelegate.provider.zoomScale != provider.zoomScale ||
        oldDelegate.provider.skinVisible != provider.skinVisible ||
        oldDelegate.provider.musclesVisible != provider.musclesVisible ||
        oldDelegate.provider.bonesVisible != provider.bonesVisible ||
        oldDelegate.provider.organsVisible != provider.organsVisible ||
        oldDelegate.provider.bloodVesselsVisible != provider.bloodVesselsVisible ||
        oldDelegate.provider.nervousSystemVisible != provider.nervousSystemVisible ||
        oldDelegate.pulseValue != pulseValue;
  }
}
