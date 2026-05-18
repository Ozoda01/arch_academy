import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.description,
    required super.order,
    required super.durationMin,
    required super.type,
    required super.videoSource,
    super.youtubeUrl,
    super.videoUrl,
    super.articleContent,
    required super.isPreview,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: (json['order'] as num).toInt(),
      durationMin: (json['durationMin'] as num).toInt(),
      type: _parseLessonType(json['type'] as String),
      videoSource: _parseVideoSource(json['videoSource'] as String),
      youtubeUrl: json['youtubeUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      articleContent: json['articleContent'] as String?,
      isPreview: json['isPreview'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'order': order,
      'durationMin': durationMin,
      'type': type.name,
      'videoSource': videoSource.name,
      'youtubeUrl': youtubeUrl,
      'videoUrl': videoUrl,
      'articleContent': articleContent,
      'isPreview': isPreview,
    };
  }

  static LessonType _parseLessonType(String type) {
    switch (type) {
      case 'article':
        return LessonType.article;
      case 'quiz':
        return LessonType.quiz;
      case 'video':
      default:
        return LessonType.video;
    }
  }

  static VideoSource _parseVideoSource(String source) {
    switch (source) {
      case 'inApp':
        return VideoSource.inApp;
      case 'youtube':
      default:
        return VideoSource.youtube;
    }
  }
}
