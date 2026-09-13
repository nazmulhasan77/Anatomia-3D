import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    // Auto navigate to home after splash animation
    _navTimer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Futuristic background ambient glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 100,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryCyan.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryCyan.withOpacity(0.2),
                    blurRadius: 90,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),

          // Main animated content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const Spacer(flex: 1),

                      // App Logo Badge
                      const AppLogo(size: 76),
                      const SizedBox(height: 18),

                      // App Name
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, AppColors.secondaryCyan],
                        ).createShader(bounds),
                        child: const Text(
                          AppConstants.appName,
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        'Explore the Human Body Like Never Before',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondaryDark.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Glowing Human Silhouette 3D Illustration Canvas
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return CustomPaint(
                              size: Size.infinite,
                              painter: SplashSilhouettePainter(
                                pulse: _controller.value,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tagline at bottom
                      const Text(
                        AppConstants.appTagline,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryCyan,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tap to Enter Button
                      ElevatedButton(
                        onPressed: () => context.go('/home'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          shadowColor: AppColors.primaryBlue.withOpacity(0.5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashSilhouettePainter extends CustomPainter {
  final double pulse;

  SplashSilhouettePainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Glowing heart in silhouette chest
    final heartPulse = math.sin(pulse * math.pi * 3) * 0.2 + 1.0;
    final heartCenter = Offset(cx + 8, cy - 25);

    final heartGlow = Paint()
      ..color = const Color(0xFFFF1744).withOpacity(0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(heartCenter, 20 * heartPulse, heartGlow);
    canvas.drawCircle(heartCenter, 10 * heartPulse, Paint()..color = const Color(0xFFFF5252));

    // Futuristic glowing body wireframe lines
    final bodyPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.secondaryCyan,
          AppColors.primaryBlue,
          Color(0xFF002266),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Head
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 105), width: 50, height: 65), bodyPaint);

    // Glowing eyes
    final eyePaint = Paint()..color = AppColors.accentNeon;
    canvas.drawCircle(Offset(cx - 8, cy - 110), 3, eyePaint);
    canvas.drawCircle(Offset(cx + 8, cy - 110), 3, eyePaint);

    // Shoulders & Chest
    final chestPath = Path()
      ..moveTo(cx - 70, cy - 50)
      ..cubicTo(cx - 40, cy - 80, cx + 40, cy - 80, cx + 70, cy - 50)
      ..lineTo(cx + 45, cy + 30)
      ..lineTo(cx - 45, cy + 30)
      ..close();
    canvas.drawPath(chestPath, bodyPaint);

    // Radiating energy rings
    for (int i = 1; i <= 3; i++) {
      final ringRadius = (35.0 * i) + (pulse * 15);
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = AppColors.secondaryCyan.withOpacity((0.4 / i).clamp(0.0, 1.0));
      canvas.drawCircle(heartCenter, ringRadius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SplashSilhouettePainter oldDelegate) => true;
}
