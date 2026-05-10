import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../store/quiz_store.dart'; // need access to quiz store
import '../models/quiz.dart';

class NewQuizScreen extends StatefulWidget {
  const NewQuizScreen({super.key});

  @override
  State<NewQuizScreen> createState() => _NewQuizScreenState();
}

class _NewQuizScreenState() extends State<NewQuizScreen> {
  final _formKey = GlobalKey<FormState>(); // manage state
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<_QuestionFormData> _questions = [];

  // always initialize state with at least 1 add question (no blank quizzes)
  @override
  void initState() {
    super.initState();
    _addQuestion();
  }

  @override
  void dispose() {

  }

  void _addQuestion() {
    setState(() => _questions.add(_QuestionFormData()));
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions[index].dispose();
      _questions.removeAt(index);
    });
  }

  void _submit() {
    // needs validation functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: // text of "New Quiz",
        actions: [],
        body: null,
      ),
    ),
  }
}

class _QuestionFormData {
  // id, question prompt, correct ans, and spaces for 3 incorrect ans
  final String id = UniqueKey().toString();
  final TextEditingController prompt = TextEditingController();
  final TextEditingController correct = TextEditingController();
  final List<TextEditingController> incorrect = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  // remove all
  void dispose() {
    prompt.dispose();
    correct.dispose();
    for (final c in incorrect) c.dispose();
  }
}

class _QuestionFormWidget extends StatelessWidget {
  const _QuestionFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

  }
}