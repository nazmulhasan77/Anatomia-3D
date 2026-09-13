import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../services/anatomy_data_service.dart';
import '../../widgets/glass_card.dart';

class DiseaseComparisonScreen extends StatelessWidget {
  final String organId;

  const DiseaseComparisonScreen({super.key, required this.organId});

  @override
  Widget build(BuildContext context) {
    final disease = AnatomyDataService.getDiseaseByOrganId(organId) ??
        AnatomyDataService.diseaseComparisons.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text('${disease.organName} Pathologies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Dual Visual Comparison Cards (Healthy vs Diseased)
            Row(
              children: [
                // Healthy Card
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    borderColor: const Color(0xFF4CAF50).withOpacity(0.5),
                    child: Column(
                      children: [
                        Container(
                          height: 110,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const RadialGradient(
                              colors: [Color(0xFF81C784), Color(0xFF2E7D32)],
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.favorite_rounded, color: Colors.white, size: 54),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Healthy Tissue',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Diseased Card (Pneumonia / Infarction)
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    borderColor: const Color(0xFFE53935).withOpacity(0.5),
                    child: Column(
                      children: [
                        Container(
                          height: 110,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const RadialGradient(
                              colors: [Color(0xFFE57373), Color(0xFFB71C1C)],
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.coronavirus_rounded, color: Colors.white, size: 54),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          disease.diseaseName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE53935),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Overview Banner
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease.subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    disease.overview,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Clinical Comparison Table
            Text(
              'Comparative Diagnostics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.grey.shade100,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Metric',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Healthy',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Pathological',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFFE53935),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white12),

                  // Table Rows
                  ...disease.comparisons.map((row) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? Colors.white12 : Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              row.metric,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              row.healthyValue,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : Colors.black87,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              row.diseasedValue,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEF5350),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Clinical Symptoms
            Text(
              'Symptoms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 10),
            ...disease.symptoms.map((s) => GlassCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Color(0xFFFF5252)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(s, style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                )),
            const SizedBox(height: 20),

            // 5. Causes & Prevention Guides
            Text(
              'Prevention & Care',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 10),
            ...disease.prevention.map((p) => GlassCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 18, color: AppColors.secondaryCyan),
                      const SizedBox(width: 12),
                      Expanded(child: Text(p, style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
