import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/game_state.dart';
import 'package:sudoku_the_best/models/player_profile.dart'; 

class ProfileTab extends StatelessWidget {
  final PlayerProfile profile;

  const ProfileTab({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Player Stats',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...Difficulty.values.map((difficulty) {
            final played = profile.gamesPlayed[difficulty] ?? 0;
            final completed = profile.gamesCompleted[difficulty] ?? 0;
            final bestTime = profile.bestTimes[difficulty] ?? 0;

            double winRate = played == 0 ? 0 : (completed / played) * 100;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Games Played: $played'),
                  Text('Games Completed: $completed'),
                  Text('Best Time: $bestTime sec'),
                  Text('Win Rate: ${winRate.toStringAsFixed(1)}%'),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
