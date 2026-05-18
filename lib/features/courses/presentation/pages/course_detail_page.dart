import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Cubits & DI
import '../../../../injection_container.dart';
import '../cubit/courses_cubit.dart';
import '../cubit/courses_state.dart';
import '../cubit/lessons_cubit.dart';
import '../cubit/lessons_state.dart';

// Entities & Theme
import '../../domain/entities/course.dart';
import '../../domain/entities/lesson.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/widgets/error_widget.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;

  const CourseDetailPage({super.key, required this.courseId});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

    // Retrieve the course from CoursesCubit or fallback to a default mock to prevent any deep link crashes
    Course? course;
    final coursesCubit = getIt<CoursesCubit>();
    if (coursesCubit.state is CoursesLoaded) {
      final loadedState = coursesCubit.state as CoursesLoaded;
      course = loadedState.courses.firstWhere(
        (c) => c.id == widget.courseId,
        orElse: () => loadedState.courses.first,
      );
    } else {
      // Fallback
      course = Course(
        id: widget.courseId,
        title: "Flutter bilan sifatli ilovalar",
        description: "Clean Architecture, Bloc/Cubit va ilg'or state management metodlarini mukammal o'rganing.",
        language: "flutter",
        level: "Boshlang'ich",
        thumbnailUrl: "https://images.unsplash.com/photo-1617042375876-a13e36732a04?w=500&auto=format&fit=crop",
        lessonCount: 12,
        totalDurationMin: 180,
        rating: 4.8,
        enrolledCount: 2400,
        isFree: false,
        tags: const ["Clean Architecture", "Bloc"],
      );
    }

    final langColor = _getLanguageColor(course.language);

    return MultiBlocProvider(
      providers: [
        BlocProvider<LessonsCubit>(
          create: (context) => getIt<LessonsCubit>()..loadLessons(widget.courseId),
        ),
      ],
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 240.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: course!.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                      // Overlay gradient
                      Container(
                        color: Colors.black.withOpacity(0.4),
                      ),
                      // Premium Play Icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                            border: Border.all(color: Colors.white30, width: 2),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ).animate().scale(duration: 350.ms, curve: Curves.backOut),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Column(
            children: [
              // Course metadata header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title
                    Text(
                      course.title,
                      style: AppTypography.h3.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating & Enrolled Count
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          "${course.rating}  ·  ${course.enrolledCount} o'quvchi",
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // TabBar Controls
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: langColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  tabs: const [
                    Tab(text: "Kurs haqida"),
                    Tab(text: "Dastur"),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // TabBar Contents
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: About Course
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kurs tavsifi:",
                            style: AppTypography.titleMedium.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            course.description,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Nima o'rganasiz:",
                            style: AppTypography.titleMedium.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Custom checklist items
                          ...course.tags.map((tag) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: AppColors.success, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      tag,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ).animate().fadeIn(duration: 300.ms),
                    ),

                    // Tab 2: Curriculum / Lessons List
                    BlocBuilder<LessonsCubit, LessonsState>(
                      builder: (context, state) {
                        if (state is LessonsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is LessonsLoaded) {
                          final lessons = state.lessons;
                          if (lessons.isEmpty) {
                            return const Center(child: Text("Hozircha darslar yuklanmagan"));
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: lessons.length,
                            itemBuilder: (context, index) {
                              final lesson = lessons[index];
                              final isLocked = !lesson.isPreview && !course!.isFree;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    if (isLocked) {
                                      // Show Locked Dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Dars qulflangan 🔒"),
                                          content: const Text("Ushbu dars faqat to'liq obunachilar uchun ochiq. Davom etish uchun kursga a'zo bo'ling!"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text("Tushunarli"),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      // Open Video Player
                                      if (lesson.videoSource == VideoSource.youtube) {
                                        context.push('/youtube-player', extra: lesson);
                                      } else {
                                        context.push('/video-player', extra: lesson);
                                      }
                                    }
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: isLocked
                                        ? Colors.grey.withOpacity(0.1)
                                        : langColor.withOpacity(0.1),
                                    child: Text(
                                      "${lesson.order}",
                                      style: AppTypography.titleMedium.copyWith(
                                        color: isLocked ? Colors.grey : langColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    lesson.title,
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${lesson.durationMin} daqiqa",
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                    ),
                                  ),
                                  trailing: isLocked
                                      ? const Icon(Icons.lock_outline_rounded, color: Colors.grey)
                                      : (lesson.type == LessonType.quiz
                                          ? const Icon(Icons.quiz_outlined, color: AppColors.warning)
                                          : Icon(Icons.play_circle_outline_rounded, color: langColor)),
                                ),
                              );
                            },
                          );
                        } else if (state is LessonsError) {
                          return AppErrorWidget(
                            errorMessage: state.message,
                            onRetry: () {
                              context.read<LessonsCubit>().loadLessons(widget.courseId);
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ).animate().fadeIn(duration: 300.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
