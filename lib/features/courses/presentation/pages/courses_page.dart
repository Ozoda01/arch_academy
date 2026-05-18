import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Bloc & DI
import '../../../../injection_container.dart';
import '../cubit/courses_cubit.dart';
import '../cubit/courses_state.dart';

// Theme & Widgets
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/course_card.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/error_widget.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String _selectedLang = 'all';
  String _selectedLevel = 'all';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _langs = [
    {'label': 'Hammasi', 'value': 'all'},
    {'label': 'Dart', 'value': 'dart'},
    {'label': 'Flutter', 'value': 'flutter'},
    {'label': 'Java', 'value': 'java'},
    {'label': 'Kotlin', 'value': 'kotlin'},
  ];

  final List<Map<String, dynamic>> _levels = [
    {'label': 'Barcha darajalar', 'value': 'all'},
    {'label': 'Boshlang\'ich', 'value': 'Boshlang\'ich'},
    {'label': 'O\'rta', 'value': 'O\'rta'},
    {'label': 'Yuqori', 'value': 'Yuqori'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => getIt<CoursesCubit>()..load(language: _selectedLang),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kurslar katalogi'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search & Quick Filter Section
              const SizedBox(height: 10),
              TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Kurslarni qidirish...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Controls
              Row(
                children: [
                  // Language Dropdown Selector
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Builder(
                        builder: (cubitContext) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedLang,
                              isExpanded: true,
                              dropdownColor: isDark ? AppColors.darkSurface : AppColors.surface,
                              items: _langs.map((lang) {
                                return DropdownMenuItem<String>(
                                  value: lang['value'] as String,
                                  child: Text(
                                    lang['label'] as String,
                                    style: AppTypography.bodyMedium,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedLang = val;
                                  });
                                  cubitContext.read<CoursesCubit>().load(language: _selectedLang);
                                }
                              },
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Level Dropdown Selector
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLevel,
                          isExpanded: true,
                          dropdownColor: isDark ? AppColors.darkSurface : AppColors.surface,
                          items: _levels.map((lvl) {
                            return DropdownMenuItem<String>(
                              value: lvl['value'] as String,
                              child: Text(
                                lvl['label'] as String,
                                style: AppTypography.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedLevel = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Courses List
              Expanded(
                child: Builder(
                  builder: (cubitContext) {
                    return BlocBuilder<CoursesCubit, CoursesState>(
                      builder: (context, state) {
                        if (state is CoursesLoading) {
                          return ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: LoadingShimmer(width: double.infinity, height: 220, borderRadius: 20),
                            ),
                          );
                        } else if (state is CoursesLoaded) {
                          // Perform client-side searches and Level filtering
                          var courses = state.courses;
                          
                          if (_selectedLevel != 'all') {
                            courses = courses.where((c) => c.level == _selectedLevel).toList();
                          }
                          if (_searchQuery.isNotEmpty) {
                            courses = courses.where((c) => c.title.toLowerCase().contains(_searchQuery)).toList();
                          }

                          if (courses.isEmpty) {
                            return Center(
                              child: Text(
                                "Kurslar topilmadi.",
                                style: AppTypography.bodyLarge.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              return CourseCard(course: courses[index])
                                  .animate()
                                  .slideY(begin: 0.1, end: 0, delay: (index * 50).ms, duration: 300.ms)
                                  .fadeIn();
                            },
                          );
                        } else if (state is CoursesError) {
                          return AppErrorWidget(
                            errorMessage: state.message,
                            onRetry: () {
                              cubitContext.read<CoursesCubit>().load(language: _selectedLang);
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
