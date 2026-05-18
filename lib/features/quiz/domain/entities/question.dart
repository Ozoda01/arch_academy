import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props => [id, text, options, correctOptionIndex, explanation];
}
