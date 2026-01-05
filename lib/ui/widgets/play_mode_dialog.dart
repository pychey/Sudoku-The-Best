import 'package:flutter/material.dart';
import '../pages/game_page.dart';

void showPlayModeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Select Difficulty'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _modeButton(context, 'Easy'),
          _modeButton(context, 'Medium'),
          _modeButton(context, 'Hard'),
        ],
      ),
    ),
  );
}

Widget _modeButton(BuildContext context, String mode) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GamePage(difficulty: mode),
            ),
          );
        },
        child: Text(mode),
      ),
    ),
  );
}
