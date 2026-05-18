import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  final String lessonId;

  const QuizPage({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
        child: Text('Quiz Page Placeholder for Lesson: $lessonId'),
      ),
    );
  }
}
