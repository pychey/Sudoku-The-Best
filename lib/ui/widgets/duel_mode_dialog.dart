import 'package:flutter/material.dart';

enum DuelMode { online, friend }

Future<DuelMode?> showDuelModeDialog(BuildContext context) {
  return showDialog<DuelMode>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Play Duel'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _duelButton(
            context,
            'Online',
            () => Navigator.pop(context, DuelMode.online),
          ),
          _duelButton(
            context,
            'Friend',
            () => Navigator.pop(context, DuelMode.friend),
          ),
        ],
      ),
    ),
  );
}

Widget _duelButton(
  BuildContext context,
  String label,
  VoidCallback onPressed,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    ),
  );
}
