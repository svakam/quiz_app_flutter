import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../store/quiz_store.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // provider class to watch quiz list for store
    final quizzes = context.watch<QuizStore>().quizzes;

    return Scaffold(
      appBar: AppBar(

      ),
      // body to handle quiz list rendering
      body: null,

    );
  }
}