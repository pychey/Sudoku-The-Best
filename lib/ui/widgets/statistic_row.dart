import 'package:flutter/material.dart';
import 'package:sudoku_the_best/utils/sudoku_color.dart';

class StatisticsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool hasDivider;

  const StatisticsRow({
    super.key, 
    required this.icon,
    required this.label, 
    required this.value,
    this.hasDivider = true
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 28,
                    color: SudokuColors.textColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    label, 
                    style: const TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 16,
                      color: SudokuColors.textColor
                    )
                  ),
                ],
              ),
              Text(
                value, 
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16,
                )
              ),
            ],
          ),
          if (hasDivider) const Divider(height: 16),
        ],
      ),
    );
  }
}
