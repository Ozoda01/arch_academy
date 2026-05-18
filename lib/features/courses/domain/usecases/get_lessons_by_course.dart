import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lesson.dart';
import '../repositories/course_repository.dart';

class GetLessonsByCourse implements UseCase<List<Lesson>, String> {
  final CourseRepository repository;

  GetLessonsByCourse(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(String courseId) async {
    return await repository.getLessons(courseId);
  }
}
