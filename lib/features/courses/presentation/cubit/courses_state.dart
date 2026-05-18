import 'package:equatable/equatable.dart';
import '../../domain/entities/course.dart';

sealed class CoursesState extends Equatable {
  const CoursesState();

  @override
  List<Object?> get props => [];
}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final List<Course> courses;
  final String selectedLanguage; // 'all', 'dart', 'flutter', 'java', 'kotlin'

  const CoursesLoaded({
    required this.courses,
    this.selectedLanguage = 'all',
  });

  @override
  List<Object?> get props => [courses, selectedLanguage];
}

class CoursesError extends CoursesState {
  final String message;

  const CoursesError(this.message);

  @override
  List<Object?> get props => [message];
}
