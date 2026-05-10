import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store/quiz_store.dart';
import 'screens/quiz_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizStore(),
      child: MaterialApp(
        title: 'QuizCraft',
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.black12),
        ),
        debugShowCheckedModeBanner: false,
        home: const QuizListScreen(),
      )
    );
  }
}

