import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_lessons_by_course.dart';
import 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  final GetLessonsByCourse getLessonsByCourse;

  LessonsCubit({required this.getLessonsByCourse}) : super(LessonsInitial());

  Future<void> loadLessons(String courseId) async {
    emit(LessonsLoading());

    final result = await getLessonsByCourse(courseId);

    result.fold(
      (failure) => emit(LessonsError(failure.message)),
      (lessons) => emit(LessonsLoaded(lessons)),
    );
  }
}
