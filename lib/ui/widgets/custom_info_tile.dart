import 'package:flutter/material.dart';
import 'package:sudoku_the_best/utils/sudoku_color.dart';

class CustomInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const CustomInfoTile({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: SudokuColors.containerBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: SudokuColors.textColor,
            size: 24,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: SudokuColors.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}