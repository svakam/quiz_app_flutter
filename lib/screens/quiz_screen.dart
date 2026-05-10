import 'dart:math';
import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz; // hold instance of quiz that user pulled up

  const QuizScreen({super.key, required this.quiz});

  // hold quiz state as user takes it
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

// state management for taking the quiz
class _QuizScreenState extends State<QuizScreen> {
  late final List<List<String>> _shuffledAnswers;
  final Map<int, String> _selected = {};
  bool _submitted = false; // track if user submitted
  int score = 0;

  @override
  void initState() {
    super.initState();

    // shuffle answers for each quiz question
    final rand = Random();
    _shuffledAnswers = widget.quiz.questions.map((q) {
      final answers = List<String>.from(q.allAnswers)..shuffle(rand);
      return answers;
    }).toList();
  }

  void _submit() {

  }

  @override
  Widget build(BuildContext context) {

  }

}

class _QuestionWidget extends StatelessWidget {
  final int number;
  final Question question;
  final List<String> shuffledAnswers;
  final String? selectedAnswer;
  final bool submitted;
  final ValueChanged<String> onSelect;

  const _QuestionWidget({
    required this.number,
    required this.question,
    required this.shuffledAnswers,
    required this.selectedAnswer,
    required this.submitted,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ${question.prompt}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...shuffledAnswers.map((answer) {

            // display to user if chosen answer correct or wrong
            Widget? trailing;
            if (submitted) {
              if (answer == question.correctAnswer) {
                trailing = const Icon(Icons.check, color: Colors.green);
              } else if (answer == selectedAnswer) {
                trailing = const Icon(Icons.close, color: Colors.red);
              }
            }


          })
        ]
      )
    );
  }
}