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

}