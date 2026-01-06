import 'package:flutter/material.dart';

class StatisticsRow extends StatelessWidget {
  final String label;
  final String value;

  const StatisticsRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }
}
