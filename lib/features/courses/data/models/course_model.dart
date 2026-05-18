import '../../domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.language,
    required super.level,
    required super.thumbnailUrl,
    required super.lessonCount,
    required super.totalDurationMin,
    required super.rating,
    required super.enrolledCount,
    required super.isFree,
    required super.tags,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      language: json['language'] as String,
      level: json['level'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      lessonCount: (json['lessonCount'] as num).toInt(),
      totalDurationMin: (json['totalDurationMin'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      enrolledCount: (json['enrolledCount'] as num).toInt(),
      isFree: json['isFree'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'language': language,
      'level': level,
      'thumbnailUrl': thumbnailUrl,
      'lessonCount': lessonCount,
      'totalDurationMin': totalDurationMin,
      'rating': rating,
      'enrolledCount': enrolledCount,
      'isFree': isFree,
      'tags': tags,
    };
  }
}
