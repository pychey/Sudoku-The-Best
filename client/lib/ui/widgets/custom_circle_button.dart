import 'package:flutter/material.dart';
import 'package:sudoku_the_best/utils/sudoku_color.dart';

class CustomCircleButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const CustomCircleButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isActive
              ? SudokuColors.boardFocusBackground
              : SudokuColors.containerBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive
              ? SudokuColors.focusTextColor
              : SudokuColors.textColor,
          size: 24,
        ),
      ),
    );
  }
}