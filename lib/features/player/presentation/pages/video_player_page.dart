import 'package:flutter/material.dart';
import '../../../courses/domain/entities/lesson.dart';

class VideoPlayerPage extends StatelessWidget {
  final Lesson lesson;

  const VideoPlayerPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: Center(
        child: Text('Video Player Page Placeholder for: ${lesson.title}'),
      ),
    );
  }
}
