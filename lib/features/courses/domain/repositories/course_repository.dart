import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/course.dart';
import '../entities/lesson.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCourses();
  Future<Either<Failure, List<Lesson>>> getLessons(String courseId);
}
