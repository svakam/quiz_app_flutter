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
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
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
    // VALIDATION: if invalid state, return ctrl back to quiz screen user input
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // collect all input question info from user (list-ify lists too)
    final questions = _questions
        .map((q) => Question(
          prompt: q.prompt.text.trim(),
          correctAnswer: q.correct.text.trim(),
          incorrectAnswers:
            q.incorrect.map((c) => c.text.trim()).toList(),
          ))
        .toList();

    // get current in-memory list of quizzes, add newly created quiz
    context.read<QuizStore>().addQuiz(Quiz(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        questions: questions,
        createdAt: DateTime.now(),
    ));
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Quiz'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 2,
              validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            const Text(
              'Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ..._questions.asMap().entries.map((entry) {
              final index = entry.key;
              final q = entry.value;
              return _QuestionFormWidget(
                  key: ValueKey(q.id),
                  number: index + 1,
                  data: q,
                  // user can delete if # questions in this quiz > 1
                  canRemove: _questions.length > 1,
                  onRemove: () => _removeQuestion(index),
              );
            }),
            const SizedBox(height: 8),
            OutlinedButton.icon( // trigger for adding a new quiz question
                onPressed: _addQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Add Question'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save Quiz'),
            ),
          ],
        ),
      ),
    );
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
    for (final c in incorrect) {
      c.dispose();
    }
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Question $number',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (canRemove)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remove',
                  onPressed: onRemove,
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: data.prompt,
            decoration: const InputDecoration(labelText: 'Prompt'),
            maxLines: 2,
            minLines: 1,
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          TextFormField(
            controller: data.correct,
            decoration: const InputDecoration(labelText: 'Correct'),
          ),
          const SizedBox(height: 8),
          ...data.incorrect.asMap().entries.map((entry) {
            final i = entry.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: 'Incorrect Answer ${i + 1}',
                ),
                validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required': null,
              ),
            );
          }),
        ],
      ),
    ));
  }
}