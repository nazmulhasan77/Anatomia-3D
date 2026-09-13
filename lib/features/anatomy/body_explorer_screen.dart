import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../models/organ_model.dart';
import '../../providers/anatomy_provider.dart';
import '../../widgets/custom_3d_body_canvas.dart';
import '../../widgets/glass_card.dart';
import 'layer_control_sheet.dart';

class BodyExplorerScreen extends StatelessWidget {
  const BodyExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AnatomyProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Ambient Glow
          Positioned.fill(
            child: Container(
              color: isDark ? AppColors.darkBg : AppColors.lightBg,
            ),
          ),
          Positioned(
            top: 80,
            left: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(0.08),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.12),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          // 2. Interactive 3D Canvas
          Positioned.fill(
            child: Custom3DBodyCanvas(
              provider: provider,
              onOrganTapped: (organ) {
                // Handled in provider state
              },
            ),
          ),

          // 3. Top Header Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back or Reset
                  IconButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface.withOpacity(0.8)
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 20),
                    ),
                  ),

                  // Male / Female Toggle Pill
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface.withOpacity(0.85)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildGenderOption(
                          label: 'Male',
                          isSelected: provider.gender == BodyGender.male,
                          onTap: () => provider.setGender(BodyGender.male),
                        ),
                        _buildGenderOption(
                          label: 'Female',
                          isSelected: provider.gender == BodyGender.female,
                          onTap: () => provider.setGender(BodyGender.female),
                        ),
                      ],
                    ),
                  ),

                  // Actions: Reset camera & Layer sheet trigger
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => provider.resetCamera(),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface.withOpacity(0.8)
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: const Icon(Icons.restart_alt_rounded, size: 20),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const LayerControlSheet(),
                          );
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface.withOpacity(0.8)
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: const Icon(Icons.layers_rounded, size: 20, color: AppColors.secondaryCyan),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. Floating Layer Preset Sidebar (Left Side)
          Positioned(
            left: 16,
            top: 130,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCardBg.withOpacity(0.9)
                    : Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildLayerIconBtn(context, 'Skin', Icons.accessibility_rounded, provider),
                  const SizedBox(height: 8),
                  _buildLayerIconBtn(context, 'Muscles', Icons.fitness_center_rounded, provider),
                  const SizedBox(height: 8),
                  _buildLayerIconBtn(context, 'Bones', Icons.format_paint_rounded, provider),
                  const SizedBox(height: 8),
                  _buildLayerIconBtn(context, 'Organs', Icons.bubble_chart_rounded, provider),
                  const SizedBox(height: 8),
                  _buildLayerIconBtn(context, 'Vessels', Icons.water_drop_rounded, provider),
                  const SizedBox(height: 8),
                  _buildLayerIconBtn(context, 'Nerves', Icons.psychology_rounded, provider),
                ],
              ),
            ),
          ),

          // 5. Bottom View Angle Pills (Front, Back, Left, Right)
          Positioned(
            left: 20,
            right: 20,
            bottom: provider.selectedOrgan != null ? 140 : 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface.withOpacity(0.85)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildAngleOption('Front', BodyAngle.front, provider),
                      _buildAngleOption('Back', BodyAngle.back, provider),
                      _buildAngleOption('Left', BodyAngle.left, provider),
                      _buildAngleOption('Right', BodyAngle.right, provider),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 6. Selected Organ Bottom Sheet / Card
          if (provider.selectedOrgan != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildOrganInfoCard(context, provider.selectedOrgan!, isDark, provider),
            ),
        ],
      ),
    );
  }

  Widget _buildGenderOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildAngleOption(
    String label,
    BodyAngle angle,
    AnatomyProvider provider,
  ) {
    final isSelected = provider.angle == angle;
    return GestureDetector(
      onTap: () => provider.setAngle(angle),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryCyan : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildLayerIconBtn(
    BuildContext context,
    String preset,
    IconData icon,
    AnatomyProvider provider,
  ) {
    final isSelected = provider.activeLayerPreset == preset;
    return GestureDetector(
      onTap: () => provider.selectLayerPreset(preset),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryCyan : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.black : Colors.white70,
        ),
      ),
    );
  }

  Widget _buildOrganInfoCard(
    BuildContext context,
    OrganModel organ,
    bool isDark,
    AnatomyProvider provider,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.secondaryCyan),
            ),
            child: const Icon(Icons.favorite_rounded, color: AppColors.secondaryCyan, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  organ.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  organ.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryCyan,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  organ.location,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              context.push('/organ/${organ.id}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Explore', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            onPressed: () => provider.clearSelection(),
            icon: const Icon(Icons.close_rounded, size: 18, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
