import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/ui/widgets/duel_mode_dialog.dart';
import 'package:sudoku_the_best/ui/widgets/player_avatar.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onPlaySolo;
  final void Function(DuelMode mode) onPlayDuel;
  final Player player;

  const HomeTab({
    super.key,
    required this.onPlaySolo,
    required this.onPlayDuel,
    required this.player 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 44),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlayerAvatar(username: player.username, showOnline: true),
              const SizedBox(width: 12),
              Text(
                player.username, 
                style: const TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold
                )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight, 
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Expanded(
          //   flex: 1, 
          //   child: Center(
          //     child: Card(
          //       // elevation: 4,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(16),
          //       ),
          //       child: Container(
          //         width: 180,
          //         height: double.infinity,
          //         alignment: Alignment.center,
          //         child: SizedBox()
          //       ),
          //     ),
          //   )
          // ),
          const SizedBox(height: 20),
          Column(
            children: [
              PlayButton(
                icon: Icons.play_arrow_rounded,
                title: 'Play Solo',
                subtitle: 'Classic Sudoku',
                onPressed: () => onPlaySolo(),
              ),
              const SizedBox(height: 24),
              PlayButton(
                icon: Icons.people_alt_rounded,
                title: 'Play Duel',
                subtitle: 'Play With Friends',
                onPressed: () async {
                  final mode = await showDuelModeDialog(context);
                  if (mode != null){
                    onPlayDuel(mode);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  const PlayButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
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
            Icon(
              icon,
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
                const SizedBox(height: 6),
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
