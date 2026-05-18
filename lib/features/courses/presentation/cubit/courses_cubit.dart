import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_courses.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final GetCourses getCourses;

  CoursesCubit({required this.getCourses}) : super(CoursesInitial());

  Future<void> load({String language = 'all'}) async {
    emit(CoursesLoading());

    final result = await getCourses(const NoParams());

    result.fold(
      (failure) => emit(CoursesError(failure.message)),
      (allCourses) {
        if (language == 'all') {
          emit(CoursesLoaded(courses: allCourses, selectedLanguage: language));
        } else {
          final filtered = allCourses.where(
            (c) => c.language.toLowerCase() == language.toLowerCase(),
          ).toList();
          emit(CoursesLoaded(courses: filtered, selectedLanguage: language));
        }
      },
    );
  }
}
