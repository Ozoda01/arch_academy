import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Cubit & DI
import '../../../../injection_container.dart';
import 'cubit/progress_cubit.dart';
import 'cubit/progress_state.dart';

// Theme & Widgets
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_widget.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  Color _getLanguageColor(String lang) {
    switch (lang.toLowerCase()) {
      case 'dart':
        return AppColors.dartColor;
      case 'flutter':
        return AppColors.flutterColor;
      case 'java':
        return AppColors.javaColor;
      case 'kotlin':
        return AppColors.kotlinColor;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => getIt<ProgressCubit>()..loadProgress(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mening progressim"),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<ProgressCubit>().loadProgress();
                  },
                );
              }
            )
          ],
        ),
        body: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, state) {
            if (state is ProgressLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProgressLoaded) {
              final overallPercent = state.overallPercent;
              final progressList = state.progressList;

              // Extract values for Chart
              final dartPercent = progressList.firstWhere((p) => p.language == 'dart').percent;
              final flutterPercent = progressList.firstWhere((p) => p.language == 'flutter').percent;
              final kotlinPercent = progressList.firstWhere((p) => p.language == 'kotlin').percent;
              final javaPercent = progressList.firstWhere((p) => p.language == 'java').percent;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Card (Gradient Card)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: isDark ? AppColors.darkPrimaryGradient : AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? AppColors.darkPrimary : AppColors.primary).withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          CircularPercentIndicator(
                            radius: 46.0,
                            lineWidth: 10.0,
                            percent: overallPercent,
                            center: Text(
                              "${(overallPercent * 100).toInt()}%",
                              style: AppTypography.h3.copyWith(
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
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Umumiy o'zlashtirish",
                                  style: AppTypography.titleLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Siz platformadagi ${state.totalCompletedLessons} ta darsni to'liq yakunladingiz. O'qishda davom eting!",
                                  style: AppTypography.bodySmall.copyWith(
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad).fadeIn(),
                    
                    const SizedBox(height: 28),

                    // Chart Section Title
                    Text(
                      "Tillar kesimidagi ko'rsatkichlar",
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bar Chart using fl_chart
                    Container(
                      height: 200,
                      padding: const EdgeInsets.only(top: 16, right: 16, left: 0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                          width: 1,
                        ),
                      ),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  String text = '';
                                  switch (value.toInt()) {
                                    case 0:
                                      text = 'Dart';
                                      break;
                                    case 1:
                                      text = 'Flutter';
                                      break;
                                    case 2:
                                      text = 'Kotlin';
                                      break;
                                    case 3:
                                      text = 'Java';
                                      break;
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      text,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: dartPercent * 100,
                                  color: AppColors.dartColor,
                                  width: 22,
                                  borderRadius: BorderRadius.circular(6),
                                )
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: flutterPercent * 100,
                                  color: AppColors.flutterColor,
                                  width: 22,
                                  borderRadius: BorderRadius.circular(6),
                                )
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: kotlinPercent * 100,
                                  color: AppColors.kotlinColor,
                                  width: 22,
                                  borderRadius: BorderRadius.circular(6),
                                )
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(
                                  toY: javaPercent * 100,
                                  color: AppColors.javaColor,
                                  width: 22,
                                  borderRadius: BorderRadius.circular(6),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                    
                    const SizedBox(height: 28),

                    // Language Progress List Section
                    Text(
                      "Kurslar bo'yicha batafsil",
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: progressList.length,
                      itemBuilder: (context, index) {
                        final progress = progressList[index];
                        final color = _getLanguageColor(progress.language);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    progress.title,
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${progress.completedLessons}/${progress.totalLessons} dars",
                                    style: AppTypography.bodySmall.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                percent: progress.percent,
                                lineHeight: 8.0,
                                progressColor: color,
                                backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                                barRadius: const Radius.circular(4),
                                animation: true,
                                animationDuration: 800,
                              ),
                            ],
                          ),
                        ).animate().slideX(begin: 0.1, end: 0, delay: (index * 55).ms, duration: 300.ms).fadeIn();
                      },
                    ),
                  ],
                ),
              );
            } else if (state is ProgressError) {
              return AppErrorWidget(
                errorMessage: state.message,
                onRetry: () {
                  context.read<ProgressCubit>().loadProgress();
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
