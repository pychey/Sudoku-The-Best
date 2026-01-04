import 'package:flutter/material.dart';
import 'package:sudoku_the_best/ui/screens/game_screen.dart';

void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Game',
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}