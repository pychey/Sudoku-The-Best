import 'package:flutter/material.dart';

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
    final borderWidth = radius * 0.09;
    final statusSize = radius * 0.45;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(borderWidth),
          decoration: const BoxDecoration(
            color: Color(0XFF5A7ACD),
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: const Color(0XFFAFC0F0),
            child: Text(
              username.isNotEmpty ? username[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: radius * 0.85,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        if (showOnline)
          Positioned(
            bottom: borderWidth * 0.3,
            right: borderWidth * 0.3,
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
