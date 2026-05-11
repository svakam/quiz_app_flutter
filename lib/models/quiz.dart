// each question = prompt + correct ans + list of incorrect ans
class Question {
  final String prompt; // class variables
  final String correctAnswer;
  final List<String> incorrectAnswers;

  const Question({ // constructor
    required this.prompt,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  List<String> get allAnswers => [correctAnswer, ...incorrectAnswers];
}

// each quiz holds time, id, title, description of quiz, and question list
class Quiz {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final List<Question> questions;
  final int? timeLimitSeconds; // null = no limit

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.questions,
    this.timeLimitSeconds,
  });
}