import 'package:equatable/equatable.dart';

class CourseProgressData extends Equatable {
  final String courseId;
  final String title;
  final String language;
  final int totalLessons;
  final int completedLessons;
  final double percent;

  const CourseProgressData({
    required this.courseId,
    required this.title,
    required this.language,
    required this.totalLessons,
    required this.completedLessons,
    required this.percent,
  });

  @override
  List<Object?> get props => [courseId, title, language, totalLessons, completedLessons, percent];
}

sealed class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final List<CourseProgressData> progressList;
  final int totalCompletedLessons;
  final double overallPercent;

  const ProgressLoaded({
    required this.progressList,
    required this.totalCompletedLessons,
    required this.overallPercent,
  });

  @override
  List<Object?> get props => [progressList, totalCompletedLessons, overallPercent];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
