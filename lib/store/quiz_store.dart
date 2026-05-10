import 'package:flutter/foundation.dart';
import '../models/quiz.dart';

class QuizStore extends ChangeNotifier {
  final List<Quiz> _quizzes = []; // initialize stored quiz list

  List<Quiz> get quizzes {
    final sorted = List<Quiz>.from(_quizzes);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  void addQuiz(Quiz quiz) {
    _quizzes.add(quiz);
    notifyListeners(); // call registered listeners
  }
}