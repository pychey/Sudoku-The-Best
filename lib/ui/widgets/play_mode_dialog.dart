import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/game_state.dart'; 

Future<Difficulty?> showPlayModeDialog(BuildContext context) {
  return showDialog<Difficulty>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Select Difficulty'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _modeButton(context, Difficulty.easy),
          _modeButton(context, Difficulty.medium),
          _modeButton(context, Difficulty.hard),
        ],
      ),
    ),
  );
}


Widget _modeButton(BuildContext context, Difficulty difficulty) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, difficulty); 
        },
        child: Text(difficulty.name),
      ),
    ),
  );
}
