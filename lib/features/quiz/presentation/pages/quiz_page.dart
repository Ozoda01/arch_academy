import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Theme & Widgets
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/question.dart';

class QuizPage extends StatefulWidget {
  final String lessonId;

  const QuizPage({super.key, required this.lessonId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  int _score = 0;

  // Timer settings
  late Timer _timer;
  int _secondsLeft = 15;

  final List<Question> _questions = [
    const Question(
      id: "q1",
      text: "Clean Architecture arxitekturasida necha xil asosiy qatlam mavjud?",
      options: ["2 ta qatlam", "3 ta qatlam", "4 ta qatlam", "5 ta qatlam"],
      correctOptionIndex: 2,
      explanation: "Clean Architecture'da 4 ta asosiy qatlam bor: Domain, Data, Presentation va External/Frameworks.",
    ),
    const Question(
      id: "q2",
      text: "Domain qatlami boshqa qatlamlarga bog'liq bo'ladimi?",
      options: [
        "Ha, Data qatlamiga bog'liq bo'ladi",
        "Ha, Presentation qatlamiga bog'liq",
        "Yo'q, mutlaqo mustaqil va eng ichki qatlam",
        "Vaziyatga va API turiga qarab"
      ],
      correctOptionIndex: 2,
      explanation: "Domain qatlami eng ichki va eng markaziy qatlam bo'lib, hech qaysi tashqi qatlamga bog'liq bo'lmaydi.",
    ),
    const Question(
      id: "q3",
      text: "Presentation qatlamining asosiy vazifasi nimadan iborat?",
      options: [
        "Faqat ma'lumotlar bazasini boshqarish",
        "API so'rovlarini yuborish va keshlash",
        "Foydalanuvchi interfeysi (UI) va State Management (Cubit/Bloc)",
        "Dars modellarini yaratish va saqlash"
      ],
      correctOptionIndex: 2,
      explanation: "Presentation qatlami foydalanuvchiga interfeysni ko'rsatish hamda uning holatini (state) boshqarish uchun xizmat qiladi.",
    ),
  ];

  // Selected answers record to review on the results screen
  final List<int?> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    setState(() {
      _isAnswered = true;
      _selectedAnswerIndex = -1; // -1 represents timeout
      _userAnswers.add(null);
    });
    
    // Proceed to next question automatically after explanation display
    Future.delayed(const Duration(milliseconds: 2500), _nextQuestion);
  }

  void _selectAnswer(int index) {
    if (_isAnswered) return; // prevent multiple selection
    
    _timer.cancel();
    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      _userAnswers.add(index);
      
      if (index == _questions[_currentQuestionIndex].correctOptionIndex) {
        _score++;
      }
    });

    // Proceed to next question after giving user time to read explanation
    Future.delayed(const Duration(milliseconds: 2800), _nextQuestion);
  }

  void _nextQuestion() {
    if (!mounted) return;
    
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
      _startTimer();
    } else {
      // Finished all questions! Go to results screen
      context.pushReplacement(
        '/quiz-result',
        extra: {
          'score': _score,
          'total': _questions.length,
          'questions': _questions,
          'userAnswers': _userAnswers,
        },
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test topshirish"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Confirm quit
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Chiqish? ⚠️"),
                content: const Text("Haqiqatdan ham testni to'xtatib chiqib ketmoqchimisiz? Natijalar saqlanmaydi."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Qolish"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    child: const Text("Chiqish"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Progress Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Savol: ${_currentQuestionIndex + 1} / ${_questions.length}",
                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled_rounded, color: AppColors.warning, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "$_secondsLeft s",
                        style: AppTypography.bodyMedium.copyWith(
                          color: _secondsLeft <= 5 ? AppColors.error : AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              // Linear Progress Bar
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                percent: progress,
                lineHeight: 8.0,
                progressColor: AppColors.primary,
                backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                barRadius: const Radius.circular(4),
                animation: true,
                animateFromLastPercent: true,
              ),
              const SizedBox(height: 28),

              // Question Card
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question text
                      Text(
                        currentQuestion.text,
                        style: AppTypography.h3.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Options (Javoblar ro'yxati)
                      ...List.generate(currentQuestion.options.length, (index) {
                        final optionText = currentQuestion.options[index];
                        final isSelected = _selectedAnswerIndex == index;
                        final isCorrectAnswer = currentQuestion.correctOptionIndex == index;
                        
                        Color optionColor = isDark ? AppColors.darkSurface : AppColors.surface;
                        Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
                        Border? customBorder;

                        if (_isAnswered) {
                          if (isCorrectAnswer) {
                            optionColor = AppColors.success.withOpacity(0.15);
                            textColor = AppColors.success;
                            customBorder = Border.all(color: AppColors.success, width: 2);
                          } else if (isSelected) {
                            optionColor = AppColors.error.withOpacity(0.15);
                            textColor = AppColors.error;
                            customBorder = Border.all(color: AppColors.error, width: 2);
                          }
                        } else if (isSelected) {
                          optionColor = AppColors.primary.withOpacity(0.1);
                          customBorder = Border.all(color: AppColors.primary, width: 1.5);
                        }

                        Widget optionCard = Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: optionColor,
                            borderRadius: BorderRadius.circular(16),
                            border: customBorder ?? Border.all(
                              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                              width: 1,
                            ),
                            boxShadow: [
                              if (isSelected && !_isAnswered)
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.1),
                                  blurRadius: 10,
                                )
                            ],
                          ),
                          child: Text(
                            optionText,
                            style: AppTypography.bodyLarge.copyWith(
                              color: textColor,
                              fontWeight: isSelected || (_isAnswered && isCorrectAnswer) ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );

                        // Trigger animations on answered feedback
                        if (_isAnswered) {
                          if (isCorrectAnswer) {
                            // Green pulse for correct answer
                            optionCard = optionCard.animate().scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.03, 1.03),
                              duration: 200.ms,
                              curve: Curves.easeInOut,
                            ).then().scale(
                              begin: const Offset(1.03, 1.03),
                              end: const Offset(1, 1),
                              duration: 200.ms,
                            );
                          } else if (isSelected) {
                            // Red shake for wrong selection
                            optionCard = optionCard.animate().shake(
                              duration: 400.ms,
                              hz: 6,
                              curve: Curves.easeInOut,
                            );
                          }
                        }

                        return GestureDetector(
                          onTap: () => _selectAnswer(index),
                          child: optionCard,
                        );
                      }),
                      
                      const SizedBox(height: 20),

                      // Explanation block (Tushuntirish)
                      if (_isAnswered)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Tushuntirish:",
                                    style: AppTypography.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentQuestion.explanation,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
