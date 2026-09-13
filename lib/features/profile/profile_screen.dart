import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/anatomy_data_service.dart';
import '../../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final profile = userProvider.profile;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: const Text('My Progress'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettingsModal(context, themeProvider, isDark),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // 1. User Avatar & Name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondaryCyan, width: 3),
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlue, Color(0xFF7928CA), AppColors.secondaryCyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryCyan.withOpacity(0.35),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'AR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Learning makes you stronger!',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryCyan,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Metrics (Chapters, Points, Level)
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: '${profile.chaptersCompleted}',
                    subtitle: 'Chapters',
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: '${profile.quizPoints}',
                    subtitle: 'Points',
                    isDark: isDark,
                    titleColor: AppColors.secondaryCyan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: '${profile.level}',
                    subtitle: 'Level',
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 3. Badges Section
            _buildActionCard(
              context: context,
              icon: Icons.emoji_events_rounded,
              iconColor: const Color(0xFFFFB300),
              title: 'My Badges',
              trailingText: '${profile.badges.where((b) => b.isUnlocked).length} Unlocked',
              onTap: () => _showBadgesSheet(context, profile.badges, isDark),
            ),
            const SizedBox(height: 12),

            // 4. Quiz History Section
            _buildActionCard(
              context: context,
              icon: Icons.history_edu_rounded,
              iconColor: const Color(0xFF00E5FF),
              title: 'Quiz History',
              trailingText: '10 Completed',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Average Accuracy: 92% • Top Score: 320 XP')),
                );
              },
            ),
            const SizedBox(height: 12),

            // 5. Bookmarks Section
            _buildActionCard(
              context: context,
              icon: Icons.bookmarks_rounded,
              iconColor: const Color(0xFFFF4081),
              title: 'Bookmarks',
              trailingText: '${profile.bookmarkedOrganIds.length} Saved Organs',
              onTap: () => _showBookmarksSheet(context, profile.bookmarkedOrganIds, isDark),
            ),
            const SizedBox(height: 12),

            // 6. Settings / Theme Toggle Tile
            _buildActionCard(
              context: context,
              icon: Icons.settings_rounded,
              iconColor: AppColors.primaryBlue,
              title: 'Settings',
              trailingText: themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
              onTap: () => _showSettingsModal(context, themeProvider, isDark),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String subtitle,
    required bool isDark,
    Color? titleColor,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor ?? (isDark ? Colors.white : AppColors.textPrimaryLight),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String trailingText,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
          ),
          Text(
            trailingText,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.secondaryCyan,
          ),
        ],
      ),
    );
  }

  void _showBadgesSheet(BuildContext context, dynamic badges, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgSecondary : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Earned Badges',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...AnatomyDataService.defaultProfile.badges.map((b) {
                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: b.isUnlocked
                              ? const Color(0xFFFFD54F).withOpacity(0.2)
                              : Colors.white10,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.military_tech_rounded,
                          color: b.isUnlocked ? const Color(0xFFFFB300) : Colors.white38,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              b.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (b.isUnlocked)
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF00E676), size: 18),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showBookmarksSheet(BuildContext context, List<String> bookmarkedIds, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgSecondary : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bookmarked Organs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (bookmarkedIds.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No bookmarked organs yet.'),
                  ),
                )
              else
                ...bookmarkedIds.map((id) {
                  final organ = AnatomyDataService.getOrganById(id);
                  if (organ == null) return const SizedBox.shrink();
                  return GlassCard(
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/organ/${organ.id}');
                    },
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite_rounded, color: AppColors.secondaryCyan),
                        const SizedBox(width: 12),
                        Text(organ.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryCyan),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsModal(BuildContext context, ThemeProvider themeProvider, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgSecondary : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'App Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.dark_mode_rounded, color: AppColors.secondaryCyan),
                        SizedBox(width: 12),
                        Text('Dark Mode (Medical Sci-fi)', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Switch.adaptive(
                      value: themeProvider.isDarkMode,
                      activeColor: AppColors.secondaryCyan,
                      onChanged: (val) => themeProvider.toggleTheme(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.threed_rotation_rounded, color: AppColors.secondaryCyan),
                        SizedBox(width: 12),
                        Text('3D Rendering Quality', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Ultra 60FPS', style: TextStyle(fontSize: 12, color: AppColors.secondaryCyan)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
