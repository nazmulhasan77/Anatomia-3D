import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/glass_card.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quiz = context.watch<QuizProvider>();
    final q = quiz.currentQuestion;

    if (quiz.isQuizCompleted || q == null) {
      return _buildCompletionScreen(context, quiz, isDark);
    }

    final progressRatio = (quiz.currentIndex + 1) / quiz.totalQuestions;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: const Text('Anatomy Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => quiz.restartQuiz(),
            tooltip: 'Restart Quiz',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Progress Bar & Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level 1 • Anatomy Basics',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${quiz.currentIndex + 1}/${quiz.totalQuestions}',
                    style: const TextStyle(
                      color: AppColors.secondaryCyan,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressRatio,
                  minHeight: 7,
                  backgroundColor: isDark ? AppColors.darkSurface : Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryCyan),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Question Title Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        q.difficulty,
                        style: const TextStyle(
                          color: AppColors.secondaryCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      q.question,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Answer Options (A, B, C, D)
              Expanded(
                child: ListView.separated(
                  itemCount: q.options.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final optionText = q.options[index];
                    final optionLabel = String.fromCharCode(65 + index); // A, B, C, D
                    return _buildOptionButton(context, quiz, index, optionLabel, optionText, isDark);
                  },
                ),
              ),

              // 4. Explanation Card when answer is submitted
              if (quiz.isAnswerSubmitted) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: quiz.isCurrentAnswerCorrect
                        ? const Color(0xFF00E676).withOpacity(0.12)
                        : const Color(0xFFFF5252).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: quiz.isCurrentAnswerCorrect
                          ? const Color(0xFF00E676).withOpacity(0.4)
                          : const Color(0xFFFF5252).withOpacity(0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            quiz.isCurrentAnswerCorrect
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: quiz.isCurrentAnswerCorrect
                                ? const Color(0xFF00E676)
                                : const Color(0xFFFF5252),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            quiz.isCurrentAnswerCorrect ? 'Correct!' : 'Incorrect!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: quiz.isCurrentAnswerCorrect
                                  ? const Color(0xFF00E676)
                                  : const Color(0xFFFF5252),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        q.explanation,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // 5. Submit or Next Question Action Button
              if (!quiz.isAnswerSubmitted)
                ElevatedButton(
                  onPressed: quiz.selectedOptionIndex != null
                      ? () {
                          quiz.submitAnswer();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: AppColors.primaryBlue,
                    disabledBackgroundColor: Colors.grey.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Check Answer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    quiz.nextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    quiz.currentIndex < quiz.totalQuestions - 1 ? 'Next Question' : 'View Results',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    QuizProvider quiz,
    int index,
    String label,
    String text,
    bool isDark,
  ) {
    final isSelected = quiz.selectedOptionIndex == index;
    final isSubmitted = quiz.isAnswerSubmitted;
    final isCorrectOption = index == quiz.currentQuestion?.correctOptionIndex;

    Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    Color bgColor = isDark ? AppColors.darkSurface : Colors.white;
    Color textColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    Widget? trailingIcon;

    if (isSubmitted) {
      if (isCorrectOption) {
        borderColor = const Color(0xFF00E676);
        bgColor = const Color(0xFF00E676).withOpacity(0.15);
        textColor = const Color(0xFF00E676);
        trailingIcon = const Icon(Icons.check_circle_rounded, color: Color(0xFF00E676), size: 22);
      } else if (isSelected) {
        borderColor = const Color(0xFFFF5252);
        bgColor = const Color(0xFFFF5252).withOpacity(0.15);
        textColor = const Color(0xFFFF5252);
        trailingIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFFF5252), size: 22);
      }
    } else if (isSelected) {
      borderColor = AppColors.secondaryCyan;
      bgColor = AppColors.primaryBlue.withOpacity(0.2);
    }

    return GestureDetector(
      onTap: () => quiz.selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected || (isSubmitted && isCorrectOption) ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBlue
                    : (isDark ? Colors.white12 : Colors.grey.shade200),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            ?trailingIcon,
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionScreen(BuildContext context, QuizProvider quiz, bool isDark) {
    // Add quiz reward points to user profile
    final userProvider = context.read<UserProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.addPoints(quiz.pointsEarned);
    });

    final accuracy = ((quiz.score / quiz.totalQuestions) * 100).round();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.secondaryCyan],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryCyan.withOpacity(0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 24),
              Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Great job exploring human anatomy systems',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 30),

              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol('Score', '${quiz.score}/${quiz.totalQuestions}', isDark),
                    _buildStatCol('Accuracy', '$accuracy%', isDark),
                    _buildStatCol('XP Earned', '+${quiz.pointsEarned}', isDark, AppColors.secondaryCyan),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: () => quiz.restartQuiz(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Play Again', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/home'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppColors.secondaryCyan),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Back to Dashboard', style: TextStyle(color: AppColors.secondaryCyan, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String value, bool isDark, [Color? valueColor]) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: valueColor ?? (isDark ? Colors.white : AppColors.textPrimaryLight),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
