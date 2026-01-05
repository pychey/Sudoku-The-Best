import 'package:flutter/material.dart';
import 'play_mode_dialog.dart';

void showDuelModeDialog(
  BuildContext context, {
  required VoidCallback onFriendSelected,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Play Duel'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _duelButton(
            context,
            'Online',
            () {
              Navigator.pop(context);
              showPlayModeDialog(context);
            },
          ),
          _duelButton(
            context,
            'Friend',
            () {
              Navigator.pop(context);
              onFriendSelected();
            },
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
