import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Pages
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/main_layout.dart';
import '../../features/courses/presentation/pages/courses_page.dart';
import '../../features/courses/presentation/pages/course_detail_page.dart';
import '../../features/player/presentation/pages/video_player_page.dart';
import '../../features/player/presentation/pages/youtube_player_page.dart';
import '../../features/quiz/presentation/pages/quiz_page.dart';
import '../../features/quiz/presentation/pages/quiz_result_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

// Entities
import '../../features/courses/domain/entities/lesson.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    routes: [
      // Onboarding Route
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Main Layout with Tabs (ShellRoute)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/courses',
            builder: (context, state) => const CoursesPage(),
          ),
          GoRoute(
            path: '/progress',
            builder: (context, state) => const ProgressPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Course Details Route
      GoRoute(
        path: '/course-detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final courseId = state.pathParameters['id'] ?? '';
          return CourseDetailPage(courseId: courseId);
        },
      ),

      // In-app Video Player Route
      GoRoute(
        path: '/video-player',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final lesson = state.extra as Lesson;
          return VideoPlayerPage(lesson: lesson);
        },
      ),

      // YouTube Player Route
      GoRoute(
        path: '/youtube-player',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final lesson = state.extra as Lesson;
          return YoutubePlayerPage(lesson: lesson);
        },
      ),

      // Quiz Route
      GoRoute(
        path: '/quiz/:lessonId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final lessonId = state.pathParameters['lessonId'] ?? '';
          return QuizPage(lessonId: lessonId);
        },
      ),

      // Quiz Result Route
      GoRoute(
        path: '/quiz-result',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const QuizResultPage(),
      ),
    ],
  );
}
