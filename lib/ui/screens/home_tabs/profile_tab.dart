import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/game_state.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/ui/widgets/player_avatar.dart';
import 'package:sudoku_the_best/ui/widgets/statistic_card.dart';
import 'package:sudoku_the_best/ui/widgets/statistic_row.dart';
import 'package:sudoku_the_best/utils/sudoku_color.dart';

class ProfileTab extends StatelessWidget {
  final Player player;

  const ProfileTab({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: 
    
    Padding(
      padding: const EdgeInsets.all(24),
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
                  StatisticCard(
                    contentWidget: IconStat(
                      icon: Icons.grid_on_rounded, 
                      value: player.profile.totalGamesPlayed,
                    ),
                    label: 'Total Games Played',
                  ),
                  const SizedBox(width: 16),
                  StatisticCard(
                    contentWidget: CircularProgress(ratio: player.profile.winRatio),
                    label: 'Total Win Ratio',
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
        Container(
          height: 50,
          padding: const EdgeInsets.all(2), 
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: SudokuColors.mainBorder),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment(selectedTab == 0 ? -1 : (selectedTab == 1 ? 0 : 1), 0),
                child: FractionallySizedBox(
                  widthFactor: 1 / 3, 
                  child: Container(
                    decoration: BoxDecoration(
                      color: SudokuColors.buttonColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: List.generate(tabLabels.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => selectedTab = index),
                      child: Center(
                        child: Text(
                          tabLabels[index],
                          style: TextStyle(
                            color: selectedTab == index ? Colors.white : Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              StatisticsRow(
                icon: Icons.grid_on, 
                label: 'Games Played', 
                value: played.toString()
              ),
              StatisticsRow(
                icon: Icons.emoji_events, 
                label: 'Games Won', 
                value: won.toString()
              ),
              StatisticsRow(
                icon: Icons.bar_chart, 
                label: 'Win Ratio', 
                value: '${winRate.toStringAsFixed(1)}%'
              ),
              StatisticsRow(
                icon: Icons.timer,
                label: 'Best Time', 
                value: bestTimeFormatted,
                hasDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CircularProgress extends StatelessWidget {
  const CircularProgress({
    super.key,
    required this.ratio,
  });

  final double ratio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double diameter = constraints.maxWidth * 0.6;
    
        return SizedBox(
          height: diameter,
          width: diameter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: diameter * 0.1, 
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: ratio / 100,
                  strokeWidth: diameter * 0.1, 
                  strokeCap: StrokeCap.round,
                  color: SudokuColors.buttonColor,
                ),
              ),
              Text(
                '${ratio.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: diameter * 0.25, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class IconStat extends StatelessWidget {
  final IconData icon;
  final int value;

  const IconStat({
    super.key,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;

        final iconSize = size * 0.55;
        final textSize = size * 0.25;
        final spacing = size * 0.06;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: SudokuColors.textColor
            ),
            SizedBox(height: spacing),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}