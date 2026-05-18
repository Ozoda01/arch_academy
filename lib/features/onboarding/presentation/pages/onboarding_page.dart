import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      title: "Bir joyda 4 ta til o'rganing",
      description: "Java, Kotlin, Dart va Flutter - professional dasturlash tillarini mutlaqo o'zbek tilida o'rganing!",
      icon: Icons.code_rounded,
      color: AppColors.primary,
    ),
    OnboardingSlideData(
      title: "Videodarslik yoki YouTube",
      description: "Siz tanlaysiz! Videodarslarni ilova ichida qulay ko'rish yoki YouTube orqali oson ochish imkoniyati.",
      icon: Icons.play_circle_fill_rounded,
      color: AppColors.kotlinColor,
    ),
    OnboardingSlideData(
      title: "O'zbek tilidagi testlar",
      description: "Bilimingizni qiziqarli quizlar va testlar orqali sinang, xatolaringizni o'rganing va sertifikat oling!",
      icon: Icons.emoji_events_rounded,
      color: AppColors.javaColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Top Skip Button
              Align(
                alignment: Alignment.topRight,
                child: _currentPage < 2
                    ? TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          "O'tkazib yuborish",
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColors.darkPrimary : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const SizedBox(height: 48),
              ),
              
              // Slide PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Slide visual container
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: slide.color.withOpacity(0.1),
                            border: Border.all(
                              color: slide.color.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            slide.icon,
                            size: 100,
                            color: slide.color,
                          ),
                        )
                            .animate(key: ValueKey(index))
                            .scale(duration: 400.ms, curve: Curves.backOut)
                            .fadeIn(),
                        const SizedBox(height: 48),
                        
                        // Slide Title
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.h2.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        )
                            .animate(key: ValueKey('title_$index'))
                            .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad)
                            .fadeIn(),
                        const SizedBox(height: 16),
                        
                        // Slide Description
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLarge.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            height: 1.5,
                          ),
                        )
                            .animate(key: ValueKey('desc_$index'))
                            .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOutQuad)
                            .fadeIn(),
                      ],
                    );
                  },
                ),
              ),

              // Bottom control elements
              Column(
                children: [
                  // Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                              : (isDark ? Colors.white24 : Colors.black12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Action Button
                  CustomButton(
                    text: _currentPage == 2 ? "Boshlash" : "Keyingi",
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Navigate to Home layout
                        context.go('/');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSlideData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingSlideData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
