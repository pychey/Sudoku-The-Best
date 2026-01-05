import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  final String difficulty;

  const GamePage({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sudoku - $difficulty')),
      body: const Center(
        child: Text(
          'Placeholder Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
