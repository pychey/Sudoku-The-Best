import 'package:flutter/material.dart';

Future<String?> showAddFriendDialog(BuildContext context) {
  final TextEditingController _nameController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Friend'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Enter friend name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                Navigator.of(context).pop(name); 
              }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
