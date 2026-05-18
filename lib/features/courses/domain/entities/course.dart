import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String language; // "dart" | "flutter" | "java" | "kotlin"
  final String level;    // "Boshlang'ich" | "O'rta" | "Yuqori"
  final String thumbnailUrl;
  final int lessonCount;
  final int totalDurationMin;
  final double rating;
  final int enrolledCount;
  final bool isFree;
  final List<String> tags;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.level,
    required this.thumbnailUrl,
    required this.lessonCount,
    required this.totalDurationMin,
    required this.rating,
    required this.enrolledCount,
    required this.isFree,
    required this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        language,
        level,
        thumbnailUrl,
        lessonCount,
        totalDurationMin,
        rating,
        enrolledCount,
        isFree,
        tags,
      ];
}
