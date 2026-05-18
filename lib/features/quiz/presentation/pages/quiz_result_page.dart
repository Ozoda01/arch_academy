import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';

// Theme & Widgets
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/question.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({super.key});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  bool _markedInHive = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Safely extract routing parameters passed via GoRouter extra
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final int score = extra?['score'] as int? ?? 0;
    final int total = extra?['total'] as int? ?? 3;
    final List<Question> questions = extra?['questions'] as List<Question>? ?? [];
    final List<int?> userAnswers = extra?['userAnswers'] as List<int?>? ?? [];

    final percent = score / total;
    final isPassed = percent >= 0.6; // 60% or more to pass

    // Mark quiz as completed in Hive progress box
    if (isPassed && !_markedInHive) {
      _markedInHive = true;
      final box = Hive.box('progress_box');
      box.put("103", true); // Mark the quiz lesson (id: 103) as completed!
      box.put('lang_1_103', true);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Natijalari"),
        leading: IconButton(
          icon: const Icon(Icons.home_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Confetti Lottie Animation (Celebration overlay if passed)
            if (isPassed)
              Positioned.fill(
                child: IgnorePointer(
                  child: Lottie.network(
                    "https://assets3.lottiefiles.com/packages/lf20_vu9a2aek.json",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // Congratulations / Feedback Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isPassed
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isPassed
                            ? AppColors.success.withOpacity(0.3)
                            : AppColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isPassed ? "Tabriklaymiz! 🥳" : "Afsus... 😔",
                          style: AppTypography.h2.copyWith(
                            color: isPassed ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isPassed
                              ? "Siz testdan muvaffaqiyatli o'tdingiz va Clean Architecture bilimingizni tasdiqladingiz!"
                              : "Muvaffaqiyatli o'tish uchun kamida 2 ta to'g'ri javob topishingiz kerak edi. Yana urinib ko'ring!",
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.backOut),
                  
                  const SizedBox(height: 28),

                  // Score Circular Percent Indicator
                  CircularPercentIndicator(
                    radius: 64.0,
                    lineWidth: 12.0,
                    percent: percent,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$score / $total",
                          style: AppTypography.h2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          "to'g'ri",
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    progressColor: isPassed ? AppColors.success : AppColors.error,
                    backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1000,
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 36),

                  // Answer Review Details Header
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Savollar tahlili:",
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Answer Review List
                  if (questions.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final userAnswerIndex = userAnswers.length > index ? userAnswers[index] : null;
                        final isCorrect = userAnswerIndex == question.correctOptionIndex;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isCorrect
                                  ? AppColors.success.withOpacity(0.2)
                                  : AppColors.error.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question Title & Indicator
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                    color: isCorrect ? AppColors.success : AppColors.error,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      question.text,
                                      style: AppTypography.bodyLarge.copyWith(
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Answer choices summary
                              Text(
                                userAnswerIndex == -1
                                    ? "Sizning javobingiz: Vaqt tugadi ⏰"
                                    : "Sizning javobingiz: ${userAnswerIndex != null ? question.options[userAnswerIndex] : 'Belgilanmagan'}",
                                style: AppTypography.bodySmall.copyWith(
                                  color: isCorrect ? AppColors.success : AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (!isCorrect)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "To'g'ri javob: ${question.options[question.correctOptionIndex]}",
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 12),

                              // Explanation text
                              Text(
                                "Tushuntirish: ${question.explanation}",
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ).animate().slideY(begin: 0.1, end: 0, delay: (index * 80).ms, duration: 300.ms).fadeIn();
                      },
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Go Home Action Button
                  CustomButton(
                    text: "Bosh sahifaga qaytish",
                    onPressed: () {
                      context.go('/');
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
