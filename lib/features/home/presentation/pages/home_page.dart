import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Bloc & DI
import '../../../../injection_container.dart';
import '../../../courses/presentation/cubit/courses_cubit.dart';
import '../../../courses/presentation/cubit/courses_state.dart';

// Theme & Widgets
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../courses/presentation/widgets/course_card.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/error_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedLang = 'all';

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Hammasi', 'value': 'all', 'color': AppColors.primary},
    {'label': 'Dart', 'value': 'dart', 'color': AppColors.dartColor},
    {'label': 'Flutter', 'value': 'flutter', 'color': AppColors.flutterColor},
    {'label': 'Java', 'value': 'java', 'color': AppColors.javaColor},
    {'label': 'Kotlin', 'value': 'kotlin', 'color': AppColors.kotlinColor},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => getIt<CoursesCubit>()..load(language: _selectedLang),
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              // Trigger reload
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Qismi (Sardor 👋)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Assalomu alaykum, Sardor 👋",
                              style: AppTypography.titleLarge.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Bugun 2 dars o'qidingiz",
                              style: AppTypography.bodyMedium.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryLight,
                          child: Icon(
                            Icons.person,
                            color: isDark ? AppColors.darkPrimary : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Progress Ring Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: isDark ? AppColors.darkPrimaryGradient : AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? AppColors.darkPrimary : AppColors.primary).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          CircularPercentIndicator(
                            radius: 36.0,
                            lineWidth: 8.0,
                            percent: 0.34,
                            center: Text(
                              "34%",
                              style: AppTypography.titleMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            progressColor: Colors.white,
                            backgroundColor: Colors.white24,
                            circularStrokeCap: CircularStrokeCap.round,
                            animation: true,
                            animationDuration: 1000,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Flutter bilan sifatli ilovalar",
                                  style: AppTypography.titleMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Dars 3: Clean Architecture yuzasidan test",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () {
                                    context.push('/course-detail/1');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Davom ettirish",
                                        style: AppTypography.bodyMedium.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad).fadeIn(),
                    
                    const SizedBox(height: 24),

                    // Filter Panel (Tillar)
                    Text(
                      "Tillar bo'yicha filter:",
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Horizontal Filter List
                    Builder(
                      builder: (cubitContext) {
                        return SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filters.length,
                            itemBuilder: (context, index) {
                              final filter = _filters[index];
                              final isSelected = _selectedLang == filter['value'];
                              final activeColor = filter['color'] as Color;

                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedLang = filter['value'] as String;
                                    });
                                    // Trigger reload on cubit
                                    cubitContext.read<CoursesCubit>().load(language: _selectedLang);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? activeColor
                                          : (isDark ? AppColors.darkSurface : Colors.grey[200]),
                                      borderRadius: BorderRadius.circular(20),
                                      border: isSelected
                                          ? null
                                          : Border.all(
                                              color: isDark ? Colors.white10 : Colors.transparent,
                                              width: 1,
                                            ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        filter['label'] as String,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    ),

                    const SizedBox(height: 24),

                    // Kurslar Sarlavha
                    Text(
                      "Mashhur kurslar",
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // BlocBuilder orqali Kurslarni chiqarish
                    BlocBuilder<CoursesCubit, CoursesState>(
                      builder: (context, state) {
                        if (state is CoursesLoading) {
                          return Column(
                            children: List.generate(
                              2,
                              (_) => const Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: LoadingShimmer(width: double.infinity, height: 240, borderRadius: 20),
                              ),
                            ),
                          );
                        } else if (state is CoursesLoaded) {
                          if (state.courses.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40.0),
                                child: Text(
                                  "Hozircha ushbu til bo'yicha kurslar mavjud emas.",
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: state.courses
                                .map((course) => CourseCard(course: course))
                                .toList(),
                          );
                        } else if (state is CoursesError) {
                          return AppErrorWidget(
                            errorMessage: state.message,
                            onRetry: () {
                              context.read<CoursesCubit>().load(language: _selectedLang);
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
