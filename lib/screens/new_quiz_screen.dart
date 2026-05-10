import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../store/quiz_store.dart'; // need access to quiz store
import '../models/quiz.dart';

class NewQuizScreen extends StatefulWidget {
  const NewQuizScreen({super.key});

  @override
  State<NewQuizScreen> createState() => _NewQuizScreenState();
}

class _NewQuizScreenState extends State<NewQuizScreen> {
  final _formKey = GlobalKey<FormState>(); // manage state
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<_QuestionFormData> _questions = []; // init empty list

  // always initialize state with at least 1 add question (no blank quizzes)
  @override
  void initState() {
    super.initState();
    _addQuestion();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final q in _questions) q.dispose();
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
  // also holds controllers for one question's form
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

// contained within quiz screen state
class _QuestionFormWidget extends StatelessWidget {
  final int number;
  final _QuestionFormData data; // see above
  final bool canRemove; // flag for removal check
  final VoidCallback onRemove;

  const _QuestionFormWidget({
    super.key,
    required this.number,
    required this.data,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Question $number',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (canRemove)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remove',
                  onPressed: onRemove,
                ),
            ],
          ),
          TextFormField(
            controller: data.prompt,
            decoration: const InputDecoration(labelText: 'Prompt'),
            // need validator
          ),
          TextFormField(
            controller: data.correct,
            decoration: const InputDecoration(labelText: 'Correct'),
          ),
          ...data.incorrect.asMap().entries.map((entry) {
            final i = entry.key;
            return TextFormField(
              controller: entry.value,
              decoration: InputDecoration(
                labelText: 'Incorrect Answer ${i + 1}',
              ),
              // need validator
            );
          }),
        ],
      ),
    );
  }
}