import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/anatomy_provider.dart';
import '../../widgets/glass_card.dart';

class LayerControlSheet extends StatelessWidget {
  const LayerControlSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<AnatomyProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSecondary : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Layer Control',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              TextButton(
                onPressed: () {
                  provider.selectLayerPreset('All');
                },
                child: const Text(
                  'Reset All',
                  style: TextStyle(
                    color: AppColors.secondaryCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Layer Switch Toggles
          _buildLayerToggle(
            context: context,
            title: 'Skin',
            subtitle: 'Epidermis & protective exterior barrier',
            color: AppColors.skinLayer,
            icon: Icons.accessibility_rounded,
            value: provider.skinVisible,
            onChanged: (val) => provider.toggleSkin(val),
          ),
          const SizedBox(height: 10),
          _buildLayerToggle(
            context: context,
            title: 'Muscles',
            subtitle: 'Skeletal musculature & tendons',
            color: AppColors.muscleLayer,
            icon: Icons.fitness_center_rounded,
            value: provider.musclesVisible,
            onChanged: (val) => provider.toggleMuscles(val),
          ),
          const SizedBox(height: 10),
          _buildLayerToggle(
            context: context,
            title: 'Bones',
            subtitle: '206 articulated skeletal bones & joints',
            color: const Color(0xFFFFF176),
            icon: Icons.format_paint_rounded,
            value: provider.bonesVisible,
            onChanged: (val) => provider.toggleBones(val),
          ),
          const SizedBox(height: 10),
          _buildLayerToggle(
            context: context,
            title: 'Organs',
            subtitle: 'Vital internal thoracic & abdominal organs',
            color: AppColors.organLayer,
            icon: Icons.bubble_chart_rounded,
            value: provider.organsVisible,
            onChanged: (val) => provider.toggleOrgans(val),
          ),
          const SizedBox(height: 10),
          _buildLayerToggle(
            context: context,
            title: 'Blood Vessels',
            subtitle: 'Aorta, vena cava & peripheral circulation',
            color: AppColors.vesselLayer,
            icon: Icons.water_drop_rounded,
            value: provider.bloodVesselsVisible,
            onChanged: (val) => provider.toggleBloodVessels(val),
          ),
          const SizedBox(height: 10),
          _buildLayerToggle(
            context: context,
            title: 'Nervous System',
            subtitle: 'Cranial brain, spinal cord & neural plexus',
            color: AppColors.nerveLayer,
            icon: Icons.psychology_rounded,
            value: provider.nervousSystemVisible,
            onChanged: (val) => provider.toggleNervousSystem(val),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLayerToggle({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.35)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.secondaryCyan,
            activeTrackColor: AppColors.primaryBlue.withOpacity(0.5),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
