import 'dart:async';
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
  int _score = 0;
  Timer? _timer;
  int? _secondsRemaining;

  @override
  void initState() {
    super.initState();

    // shuffle answers for each quiz question
    final rand = Random();
    _shuffledAnswers = widget.quiz.questions.map((q) {
      final answers = List<String>.from(q.allAnswers)..shuffle(rand);
      return answers;
    }).toList();

    // initialize timer upon starting quiz
    if (widget.quiz.timeLimitSeconds != null) {
      _secondsRemaining = widget.quiz.timeLimitSeconds;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_secondsRemaining == null) return;
        if (_secondsRemaining! <= 1) {
          _submit(autoSubmit: true);
        } else {
          setState(() => _secondsRemaining = _secondsRemaining! - 1);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // ensure timer stops wherever upon disposing state
    super.dispose();
  }

  // submit now accepts auto-submission option
  void _submit({bool autoSubmit = false}) {
    _timer?.cancel(); // if timer exists for this quiz, stop it

    if (!autoSubmit) {
      final total = widget.quiz.questions.length;
      // don't allow submission unless all questions answered
      if (_selected.length < total) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '${total - _selected.length} question${total - _selected.length == 1
                ? '' : 's'} not yet answered!',
          ),
        ));
        return;
      }
    }

    int score = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      if (_selected[i] == widget.quiz.questions[i].correctAnswer) score++;
    }

    setState(() {
      _submitted = true;
      _score = score;
      _secondsRemaining = 0;
    });
  }

  // helper function for formatting time into minutes
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final sec = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quiz;
    final questions = quiz.questions;
    final hasTimer = _secondsRemaining != null;

    return Scaffold(
      appBar: AppBar(
          title: Text(quiz.title),
          actions: [
            if (hasTimer)
              Text(
                _formatTime(_secondsRemaining!),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
          ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(quiz.description),
          const SizedBox(height: 4),
          Text( // length of questions check grammar
            '${questions.length} question${questions.length == 1 ? '' : 's'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Divider(height: 20),

          // question widget mapping: for each question, check
          ...questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return _QuestionWidget(
              number: index + 1,
              question: question,
              shuffledAnswers: _shuffledAnswers[index],
              selectedAnswer: _selected[index],
              submitted: _submitted,
              onSelect: (answer) {
                if (!_submitted) {
                  setState(() => _selected[index] = answer);
                }
              },
            );
          }),
          const SizedBox(height: 8),
          if (!_submitted)
            ElevatedButton(
              onPressed: _submit,
              child: Text(
                'Submit (${_selected.length}/${questions.length} answered)',
              ),
            )
          else
            _ResultsWidget(
              score: _score,
              total: questions.length,
              onBackToList: () => Navigator.pop(context),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
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

            final isSelected = answer == selectedAnswer;
            final isCorrect = answer == question.correctAnswer;

            // display to user if chosen answer correct or wrong
            Widget? trailing;
            if (submitted) {
              if (isCorrect) {
                trailing = const Icon(Icons.check, color: Colors.green);
              } else if (isSelected) {
                trailing = const Icon(Icons.close, color: Colors.red);
              }
            }

            return ListTile(
              title: Text(answer),
              trailing: trailing,
              leading: Icon(
                isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              ),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: submitted ? null : () => onSelect(answer),
            );
          }),
          const Divider(),
        ],
      ),
    );
  }
}

class _ResultsWidget extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onBackToList;

  const _ResultsWidget({
    required this.score,
    required this.total,
    required this.onBackToList,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (score / total * 100).round();
    return Column(
      children: [
        Text(
          'Results: $score / $total ($pct%)',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onBackToList,
          child: const Text('Back to Quiz List'),
        ),
      ],
    );
  }
}