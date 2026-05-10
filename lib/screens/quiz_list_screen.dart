import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../store/quiz_store.dart';
import 'new_quiz_screen.dart';
import 'quiz_screen.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // provider class to watch quiz list for store
    final quizzes = context.watch<QuizStore>().quizzes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quizzes!'),
        actions: [
          IconButton( // add button
            icon: const Icon(Icons.add),
            tooltip: 'New Quiz',
            onPressed: () => Navigator.push( // use Nav context to push q screen
              context,
              MaterialPageRoute(builder: (_) => const NewQuizScreen()),
            ),
          ),
        ],
      ),
      // body to handle quiz list rendering
        // if no quizzes in store, state that to user and prompt creation
        // else retrieve quizzes via anon fn in itemBuilder
      body: quizzes.isEmpty
        ? const Center(child: Text('No quizzes yet! Tap + to create one.'))
        : ListView.separated(
          itemCount: quizzes.length,
          // only show/render quizzes in view
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final quiz = quizzes[index]; // get quiz at this index
            return _QuizListItem( // use quiz ctor to load properties
              quiz: quiz,
              // navigate to quiz (i.e. taking the quiz) if tapped on
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => QuizScreen(quiz: quiz),
                ),
              ),
            );
          },
        ),
    );
  }
}

class _QuizListItem extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;

  const _QuizListItem({required this.quiz, required this.onTap});

  // for this quiz, show # of questions, title, and other info
  @override
  Widget build(BuildContext context) {
    final count = quiz.questions.length; // store # questions in this quiz
    return ListTile(
      title: Text(quiz.title),
      subtitle: Text( // update 'question' grammar by # questions available
        '${quiz.description}\n$count question${count == 1 ? '' : 's'}',
      ),
      isThreeLine: true,
      onTap: onTap,
    );
  }
}