import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
 const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODO',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
