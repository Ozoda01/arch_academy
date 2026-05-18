import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit() : super(ProgressInitial());

  Future<void> loadProgress() async {
    emit(ProgressLoading());
    try {
      final box = Hive.box('progress_box');

      // Flutter course (id: 1, total: 12)
      int flutterCompleted = 0;
      final flutterLessonIds = ["101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112"];
      // Pre-populate some lessons as completed for mock demonstration (e.g. 101, 104, 105, 106 to achieve ~34%)
      if (box.get('first_run_setup_done', defaultValue: false) == false) {
        box.put("101", true);
        box.put("104", true);
        box.put("105", true);
        box.put("106", true);
        
        box.put("201", true);
        box.put("202", true); // Dart
        
        box.put('first_run_setup_done', true);
      }

      for (var id in flutterLessonIds) {
        if (box.get(id, defaultValue: false) == true) {
          flutterCompleted++;
        }
      }

      // Dart course (id: 2, total: 8)
      int dartCompleted = 0;
      final dartLessonIds = ["201", "202", "203", "204", "205", "206", "207", "208"];
      for (var id in dartLessonIds) {
        if (box.get(id, defaultValue: false) == true) {
          dartCompleted++;
        }
      }

      // Kotlin course (id: 3, total: 10)
      int kotlinCompleted = 0;
      final kotlinLessonIds = ["301", "302", "303", "304", "305", "306", "307", "308", "309", "310"];
      for (var id in kotlinLessonIds) {
        if (box.get(id, defaultValue: false) == true) {
          kotlinCompleted++;
        }
      }

      // Java course (id: 4, total: 15)
      int javaCompleted = 0;
      final javaLessonIds = ["401", "402", "403", "404", "405", "406", "407", "408", "409", "410", "411", "412", "413", "414", "415"];
      for (var id in javaLessonIds) {
        if (box.get(id, defaultValue: false) == true) {
          javaCompleted++;
        }
      }

      final progressList = [
        CourseProgressData(
          courseId: "1",
          title: "Flutter bilan sifatli ilovalar",
          language: "flutter",
          totalLessons: 12,
          completedLessons: flutterCompleted,
          percent: flutterCompleted / 12,
        ),
        CourseProgressData(
          courseId: "2",
          title: "Dart Dasturlash Asoslari",
          language: "dart",
          totalLessons: 8,
          completedLessons: dartCompleted,
          percent: dartCompleted / 8,
        ),
        CourseProgressData(
          courseId: "3",
          title: "Kotlin orqali Android Dasturlash",
          language: "kotlin",
          totalLessons: 10,
          completedLessons: kotlinCompleted,
          percent: kotlinCompleted / 10,
        ),
        CourseProgressData(
          courseId: "4",
          title: "Java OOP va Ma'lumotlar Tuzilmasi",
          language: "java",
          totalLessons: 15,
          completedLessons: javaCompleted,
          percent: javaCompleted / 15,
        ),
      ];

      final totalCompleted = flutterCompleted + dartCompleted + kotlinCompleted + javaCompleted;
      final totalLessonsAll = 12 + 8 + 10 + 15;
      final overallPercent = totalCompleted / totalLessonsAll;

      emit(ProgressLoaded(
        progressList: progressList,
        totalCompletedLessons: totalCompleted,
        overallPercent: overallPercent,
      ));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
