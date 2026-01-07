import 'package:flutter/material.dart';
import 'package:sudoku_the_best/utils/sudoku_color.dart';

class PlayerAvatar extends StatelessWidget {
  final String username;
  final double radius;
  final bool showOnline;
  final Color onlineColor;

  const PlayerAvatar({
    super.key,
    required this.username,
    this.radius = 32,
    this.showOnline = false,
    this.onlineColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    final borderWidth = radius * 0.06;
    final statusSize = radius * 0.55;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: SudokuColors.avatarBackground,
          child: Text(
            username.isNotEmpty ? username[0].toUpperCase() : '?',
            style: TextStyle(
              color: Colors.white,
              fontSize: radius * 0.85,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        if (showOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: statusSize,
              height: statusSize,
              decoration: BoxDecoration(
                color: onlineColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: borderWidth,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
