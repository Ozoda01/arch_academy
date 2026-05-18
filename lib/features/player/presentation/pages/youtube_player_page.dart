import 'package:flutter/material.dart';
import '../../../courses/domain/entities/lesson.dart';

class YoutubePlayerPage extends StatelessWidget {
  final Lesson lesson;

  const YoutubePlayerPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: Center(
        child: Text('YouTube Player Page Placeholder for: ${lesson.youtubeUrl}'),
      ),
    );
  }
}
