import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../../../../core/network/api_client.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses();
  Future<List<LessonModel>> getLessons(String courseId);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient apiClient;

  CourseRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      // Trying to fetch from raw CDN/mock endpoint first
      final response = await apiClient.get("courses.json");
      final list = response.data as List<dynamic>;
      return list.map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      // Failsafe local premium mock data fallback so it works instantly!
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate networking
      return _mockCourses;
    }
  }

  @override
  Future<List<LessonModel>> getLessons(String courseId) async {
    try {
      final response = await apiClient.get("lessons_$courseId.json");
      final list = response.data as List<dynamic>;
      return list.map((e) => LessonModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 600)); // Simulate networking
      return _mockLessons.where((l) => l.courseId == courseId).toList();
    }
  }

  // Failsafe Mock Datasets
  static final List<CourseModel> _mockCourses = [
    const CourseModel(
      id: "1",
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
      tags: ["Clean Architecture", "Bloc", "Cubit", "State Management"],
    ),
    const CourseModel(
      id: "2",
      title: "Dart Dasturlash Asoslari",
      description: "Dasturlash dunyosiga ilk qadam. Dart tili asoslari, OOP qoidalari va asinxron dasturlash.",
      language: "dart",
      level: "Boshlang'ich",
      thumbnailUrl: "https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=500&auto=format&fit=crop",
      lessonCount: 8,
      totalDurationMin: 120,
      rating: 4.9,
      enrolledCount: 1800,
      isFree: true,
      tags: ["Dart", "OOP", "Asinxron", "Boshlang'ich"],
    ),
    const CourseModel(
      id: "3",
      title: "Kotlin orqali Android Dasturlash",
      description: "Zamonaviy Android dasturlash sirlari. Coroutines, Jetpack Compose va material dizayn.",
      language: "kotlin",
      level: "O'rta",
      thumbnailUrl: "https://images.unsplash.com/photo-1607799279861-4dd421887fb3?w=500&auto=format&fit=crop",
      lessonCount: 10,
      totalDurationMin: 150,
      rating: 4.7,
      enrolledCount: 1200,
      isFree: true,
      tags: ["Kotlin", "Android Studio", "Jetpack Compose"],
    ),
    const CourseModel(
      id: "4",
      title: "Java OOP va Ma'lumotlar Tuzilmasi",
      description: "Java dasturlash tilida murakkab algoritmlar va OOP tamoyillarini chuqur o'rganing.",
      language: "java",
      level: "Yuqori",
      thumbnailUrl: "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=500&auto=format&fit=crop",
      lessonCount: 15,
      totalDurationMin: 240,
      rating: 4.9,
      enrolledCount: 1500,
      isFree: false,
      tags: ["Java", "OOP", "Algoritmlar", "Backend"],
    ),
  ];

  static final List<LessonModel> _mockLessons = [
    // Course 1 (Flutter) Lessons
    const LessonModel(
      id: "101",
      courseId: "1",
      title: "Clean Architecture Kirish",
      description: "Clean Architecture qatlamlari, Domain, Data va Presentation qatlamlarining vazifalari.",
      order: 1,
      durationMin: 15,
      type: LessonType.video,
      videoSource: VideoSource.youtube,
      youtubeUrl: "https://www.youtube.com/watch?v=k42Ksk37vEE",
      isPreview: true,
    ),
    const LessonModel(
      id: "102",
      courseId: "1",
      title: "Loyiha Setup va Strukturasi",
      description: "Flutter loyihasini Clean architecture asosida setup qilish va papkalar tuzilishini tayyorlash.",
      order: 2,
      durationMin: 20,
      type: LessonType.video,
      videoSource: VideoSource.youtube,
      youtubeUrl: "https://www.youtube.com/watch?v=hZUNgA56Qd0",
      isPreview: false,
    ),
    const LessonModel(
      id: "103",
      courseId: "1",
      title: "Clean Architecture yuzasidan test",
      description: "Clean architecture bo'yicha olgan bilimlaringizni sinab ko'ring.",
      order: 3,
      durationMin: 10,
      type: LessonType.quiz,
      videoSource: VideoSource.youtube,
      isPreview: false,
    ),
  ];
}
