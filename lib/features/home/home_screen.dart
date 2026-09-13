import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../models/organ_model.dart';
import '../../providers/anatomy_provider.dart';
import '../../services/anatomy_data_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/app_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header with App Logo, App Name, and Profile Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const AppLogo(size: 44),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Explore the Human Body',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go('/profile'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.secondaryCyan, width: 2),
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryBlue, Color(0xFF7928CA)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'AR',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Search Bar
              GestureDetector(
                onTap: () => context.push('/search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface.withOpacity(0.8)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search_rounded, color: AppColors.secondaryCyan, size: 22),
                      SizedBox(width: 12),
                      Text(
                        'Search organs, systems, diseases...',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // 3. Main Feature Cards (3D Body Explorer & AR Mode)
              Row(
                children: [
                  // 3D Body Card
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.go('/explore'),
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0052D4), Color(0xFF4364F7), Color(0xFF6FB1FC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4364F7).withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.view_in_ar_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '3D Body',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Explore in 3D',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // AR Mode Card
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Augmented Reality (AR) Camera Mode activating...'),
                            backgroundColor: AppColors.accentPurple,
                          ),
                        );
                      },
                      child: Container(
                        height: 140,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8E2DE2).withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AR Mode',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'See in your world',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // 4. Popular Organs Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Organs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/explore'),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.secondaryCyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Quick Organ Grid (Brain, Heart, Lungs, Kidney, Liver, Stomach, Bones, Muscles)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
                itemCount: AnatomyDataService.organs.length.clamp(0, 8),
                itemBuilder: (context, index) {
                  final organ = AnatomyDataService.organs[index];
                  return _buildOrganItem(context, organ, isDark);
                },
              ),
              const SizedBox(height: 26),

              // 5. Body Systems Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Body Systems',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/explore'),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.secondaryCyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Body Systems List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AnatomyDataService.bodySystems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final system = AnatomyDataService.bodySystems[index];
                  return GlassCard(
                    onTap: () {
                      context.read<AnatomyProvider>().selectLayerPreset(
                            system.name.contains('Nervous')
                                ? 'Nerves'
                                : system.name.contains('Cardio')
                                    ? 'Vessels'
                                    : system.name.contains('Skeletal')
                                        ? 'Bones'
                                        : system.name.contains('Muscular')
                                            ? 'Muscles'
                                            : 'Organs',
                          );
                      context.go('/explore');
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Color(system.primaryColorHex).withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Color(system.primaryColorHex).withOpacity(0.4),
                            ),
                          ),
                          child: Icon(
                            _getSystemIcon(system.id),
                            color: Color(system.primaryColorHex),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                system.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${system.organs.length} Key Organs • Interactive 3D',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.secondaryCyan,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrganItem(BuildContext context, OrganModel organ, bool isDark) {
    return GestureDetector(
      onTap: () {
        context.push('/organ/${organ.id}');
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface
                  : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: _getOrganIcon(organ.id),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            organ.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _getOrganIcon(String id) {
    switch (id.toLowerCase()) {
      case 'heart':
        return const Icon(Icons.favorite_rounded, color: Color(0xFFFF1744), size: 30);
      case 'lungs':
        return const Icon(Icons.air_rounded, color: Color(0xFF00E5FF), size: 30);
      case 'brain':
        return const Icon(Icons.psychology_rounded, color: Color(0xFFFF4081), size: 30);
      case 'kidney':
        return const Icon(Icons.water_drop_rounded, color: Color(0xFFAB47BC), size: 30);
      case 'liver':
        return const Icon(Icons.spa_rounded, color: Color(0xFF8D6E63), size: 30);
      case 'stomach':
        return const Icon(Icons.restaurant_rounded, color: Color(0xFFFF9100), size: 30);
      case 'bones':
        return const Icon(Icons.accessibility_rounded, color: Color(0xFFFFF176), size: 30);
      case 'muscles':
        return const Icon(Icons.fitness_center_rounded, color: Color(0xFFFF5252), size: 30);
      case 'eyes':
        return const Icon(Icons.visibility_rounded, color: Color(0xFF00B0FF), size: 30);
      default:
        return const Icon(Icons.bubble_chart_rounded, color: AppColors.secondaryCyan, size: 30);
    }
  }

  IconData _getSystemIcon(String id) {
    switch (id.toLowerCase()) {
      case 'nervous':
        return Icons.psychology_rounded;
      case 'cardiovascular':
        return Icons.favorite_rounded;
      case 'respiratory':
        return Icons.air_rounded;
      case 'digestive':
        return Icons.local_dining_rounded;
      case 'skeletal':
        return Icons.format_paint_rounded;
      case 'muscular':
        return Icons.fitness_center_rounded;
      case 'urinary':
        return Icons.opacity_rounded;
      default:
        return Icons.medical_services_rounded;
    }
  }
}
