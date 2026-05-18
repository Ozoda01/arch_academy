import 'package:equatable/equatable.dart';

enum LessonType { video, article, quiz }
enum VideoSource { youtube, inApp }

class Lesson extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order;
  final int durationMin;
  final LessonType type;
  final VideoSource videoSource;
  final String? youtubeUrl;
  final String? videoUrl;
  final String? articleContent;
  final bool isPreview;

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.order,
    required this.durationMin,
    required this.type,
    required this.videoSource,
    this.youtubeUrl,
    this.videoUrl,
    this.articleContent,
    required this.isPreview,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        title,
        description,
        order,
        durationMin,
        type,
        videoSource,
        youtubeUrl,
        videoUrl,
        articleContent,
        isPreview,
      ];
}
