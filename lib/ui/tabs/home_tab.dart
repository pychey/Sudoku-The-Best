import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/entities/player.dart';
import 'package:sudoku_the_best/ui/widgets/play_mode_dialog.dart';
import 'package:sudoku_the_best/ui/widgets/duel_mode_dialog.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onGoToFriends;
  final Player player;

  const HomeTab({
    super.key,
    required this.onGoToFriends,
    required this.player 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 44),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(3), 
                decoration: const BoxDecoration(
                  color: Color(0XFF5A7ACD), 
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor:  const Color(0XFFAFC0F0), 
                  child: Text(
                    player.username[0],
                    style: const TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(player.username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Placeholder', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight, 
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            flex: 1, 
            child: Center(
              child: Card(
                // elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: 180,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: SizedBox()
                ),
              ),
            )
          ),
          const SizedBox(height: 20),
          PlayButton(
            title: 'Play Solo',
            subtitle: 'Classic Sudoku',
            onPressed: () => showPlayModeDialog(context),
          ),
          const SizedBox(height: 16),
          PlayButton(
            title: 'Play Duel',
            subtitle: 'Play With Friends',
            onPressed: () => showDuelModeDialog(
              context,
              onFriendSelected: onGoToFriends,
            ),
          ),
        ],
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const PlayButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.play_circle_outline_rounded,
              size: 56,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
