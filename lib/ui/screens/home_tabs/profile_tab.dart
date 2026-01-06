import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/game_state.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/ui/widgets/player_avatar.dart';
import 'package:sudoku_the_best/ui/widgets/statistic_card.dart';
import 'package:sudoku_the_best/ui/widgets/statistic_row.dart';

class ProfileTab extends StatelessWidget {
  final Player player;

  const ProfileTab({super.key, required this.player});

  int getTotalGamePlayed() {
    int totalGamesPlayed = player.profile.gamesPlayed.values
                          .fold(0, (sum, value) => sum + value);
    return totalGamesPlayed;
  }

  double getTotalWinRatio() {
    int totalPlayed = getTotalGamePlayed();
    int totalWon = player.profile.gamesCompleted.values
                  .fold(0, (sum, value) => sum + value);

    double winRate = totalPlayed == 0 ? 0 : (totalWon / totalPlayed) * 100;
    return winRate;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Column(
        children: [
          PlayerAvatar(
            username: player.username,
            radius: 40,
            showOnline: true,
          ),
          const SizedBox(height: 8),
          Text(
            player.username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatisticCard(
                      value: getTotalGamePlayed().toString(),
                      label: 'Total Games Played',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatisticCard(
                      value: '${getTotalWinRatio().toStringAsFixed(0)}%',
                      label: 'Win Ratio',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ThreeTabsSection(
                gamesPlayed: player.profile.gamesPlayed,
                gamesCompleted: player.profile.gamesCompleted,
                bestTimes: player.profile.bestTimes,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ThreeTabsSection extends StatefulWidget {
  final Map<Difficulty, int> gamesPlayed;
  final Map<Difficulty, int> gamesCompleted;
  final Map<Difficulty, int> bestTimes; 

  const ThreeTabsSection({
    super.key,
    required this.gamesPlayed,
    required this.gamesCompleted,
    required this.bestTimes,
  });

  @override
  State<ThreeTabsSection> createState() => _ThreeTabsSectionState();
}

class _ThreeTabsSectionState extends State<ThreeTabsSection> {
  int selectedTab = 0;
  final tabLabels = ['Easy', 'Medium', 'Hard'];

  Difficulty getDifficultyForIndex(int index) {
    switch (index) {
      case 0:
        return Difficulty.easy;
      case 1:
        return Difficulty.medium;
      case 2:
      default:
        return Difficulty.hard;
    }
  }

  String formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final selectedDifficulty = getDifficultyForIndex(selectedTab);

    final played = widget.gamesPlayed[selectedDifficulty] ?? 0;
    final won = widget.gamesCompleted[selectedDifficulty] ?? 0;
    final winRate = played == 0 ? 0.0 : (won / played) * 100;
    final bestTimeSec = widget.bestTimes[selectedDifficulty] ?? 0;
    final bestTimeFormatted = bestTimeSec > 0 ? formatTime(bestTimeSec) : '-';

    return Column(
      children: [
        Row(
          children: List.generate(tabLabels.length, (index) {
            final isSelected = index == selectedTab;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedTab = index),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: EdgeInsets.symmetric(
                    vertical: isSelected ? 0 : 8,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tabLabels[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              StatisticsRow(label: 'Games Played', value: played.toString()),
              StatisticsRow(label: 'Games Won', value: won.toString()),
              StatisticsRow(label: 'Win Ratio', value: '${winRate.toStringAsFixed(1)}%'),
              StatisticsRow(label: 'Best Time', value: bestTimeFormatted),
            ],
          ),
        ),
      ],
    );
  }
}


