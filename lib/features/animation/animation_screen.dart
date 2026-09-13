import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../models/organ_model.dart';
import '../../services/anatomy_data_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/physiological_animation_canvas.dart';

class AnimationScreen extends StatefulWidget {
  final String organId;

  const AnimationScreen({super.key, required this.organId});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  bool _isPlaying = true;
  double _scrubProgress = 0.5;
  int _selectedTab = 0; // 0: Animation, 1: How it Works, 2: Facts, 3: Diseases

  @override
  Widget build(BuildContext context) {
    final organ = AnatomyDataService.getOrganById(widget.organId) ??
        AnatomyDataService.organs[1]; // default to Lungs
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(organ.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // 1. Segmented Navigation Pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabPill('Animation', 0),
                  const SizedBox(width: 8),
                  _buildTabPill('How it Works', 1),
                  const SizedBox(width: 8),
                  _buildTabPill('Facts', 2),
                  const SizedBox(width: 8),
                  _buildTabPill('Diseases', 3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 2. Main Visual Canvas or Tab Content
          Expanded(
            child: _selectedTab == 0
                ? _buildAnimationView(context, organ, isDark)
                : _buildTextContent(context, organ, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondaryCyan : Colors.white24,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationView(BuildContext context, OrganModel organ, bool isDark) {
    return Column(
      children: [
        // 3D Living Simulation Canvas
        Expanded(
          flex: 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PhysiologicalAnimationCanvas(
                organId: organ.id,
                isPlaying: _isPlaying,
                playbackProgress: _scrubProgress,
                height: 340,
              ),

              // Watermark tag
              Positioned(
                top: 10,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.slow_motion_video_rounded, size: 14, color: AppColors.secondaryCyan),
                      SizedBox(width: 4),
                      Text(
                        '60 FPS Real-time Simulation',
                        style: TextStyle(fontSize: 10, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrubber Timeline & Player Controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbColor: AppColors.secondaryCyan,
                  activeTrackColor: AppColors.secondaryCyan,
                  inactiveTrackColor: Colors.white24,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayColor: AppColors.secondaryCyan.withOpacity(0.2),
                ),
                child: Slider(
                  value: _scrubProgress,
                  onChanged: (val) {
                    setState(() {
                      _scrubProgress = val;
                      _isPlaying = false;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                      color: AppColors.secondaryCyan,
                      size: 40,
                    ),
                    onPressed: () => setState(() => _isPlaying = !_isPlaying),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_10_rounded, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _scrubProgress = (_scrubProgress - 0.1).clamp(0.0, 1.0);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.forward_10_rounded, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _scrubProgress = (_scrubProgress + 0.1).clamp(0.0, 1.0);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Educational Description Card
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    organ.animation,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getAnimationDescription(organ.id),
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.push('/disease/${organ.id}'),
                        icon: const Icon(Icons.compare_rounded, size: 16),
                        label: const Text('Compare in Disease Mode', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
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
    );
  }

  Widget _buildTextContent(BuildContext context, OrganModel organ, bool isDark) {
    if (_selectedTab == 1) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mechanism of Action', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Text(organ.function, style: const TextStyle(fontSize: 14, height: 1.6)),
            ),
          ],
        ),
      );
    } else if (_selectedTab == 2) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clinical Fun Facts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Text(organ.funFact, style: const TextStyle(fontSize: 14, height: 1.6)),
            ),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Related Pathologies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 12),
            ...organ.diseases.map((d) => GlassCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  child: Text(d, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                )),
          ],
        ),
      );
    }
  }

  String _getAnimationDescription(String id) {
    switch (id.toLowerCase()) {
      case 'lungs':
        return 'When you inhale, the diaphragm contracts downward, expanding the chest cavity. Atmospheric air travels down the trachea and bronchial branches, reaching the alveoli where oxygen diffuses into blood capillaries and carbon dioxide is exhaled.';
      case 'heart':
        return 'The cardiac cycle consists of alternating phases of systole and diastole. The right ventricle pumps deoxygenated blood to the pulmonary artery, while the left ventricle propels high-pressure oxygenated blood into the aorta.';
      case 'brain':
        return 'Neurons transmit information through electrical action potentials and chemical neurotransmitters across synaptic gaps, allowing the cerebral cortex to orchestrate sensory awareness, motor command, and memory.';
      case 'kidney':
        return 'Over a million nephrons continuously filter metabolic waste products, excess electrolytes, and urea from arterial blood plasma while reabsorbing water and vital glucose back into systemic circulation.';
      default:
        return 'Live interactive physiological simulation demonstrating cellular mechanics, fluid flow, and metabolic regulation.';
    }
  }
}
