import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Core
import 'core/network/api_client.dart';

// Features - Courses
import 'features/courses/data/datasources/course_remote_datasource.dart';
import 'features/courses/data/repositories/course_repository_impl.dart';
import 'features/courses/domain/repositories/course_repository.dart';
import 'features/courses/domain/usecases/get_courses.dart';
import 'features/courses/domain/usecases/get_lessons_by_course.dart';
import 'features/courses/presentation/cubit/courses_cubit.dart';
import 'features/courses/presentation/cubit/lessons_cubit.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Core Services
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(dio: getIt<Dio>()));

  // Features - Courses
  // Data Sources
  getIt.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(remoteDataSource: getIt<CourseRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<GetCourses>(
    () => GetCourses(getIt<CourseRepository>()),
  );
  getIt.registerLazySingleton<GetLessonsByCourse>(
    () => GetLessonsByCourse(getIt<CourseRepository>()),
  );

  // Cubits (State Management)
  getIt.registerFactory<CoursesCubit>(
    () => CoursesCubit(getCourses: getIt<GetCourses>()),
  );
  getIt.registerFactory<LessonsCubit>(
    () => LessonsCubit(getLessonsByCourse: getIt<GetLessonsByCourse>()),
  );
}
