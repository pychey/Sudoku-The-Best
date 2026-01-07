import 'package:sudoku_the_best/models/game_state.dart';

class PlayerProfile {
  final Map<Difficulty, int> gamesPlayed;
  final Map<Difficulty, int> gamesCompleted;
  final Map<Difficulty, int> bestTimes;

  PlayerProfile({
    required this.gamesPlayed,
    required this.gamesCompleted,
    required this.bestTimes,
  });

  factory PlayerProfile.newProfile() {
    return PlayerProfile(
      gamesPlayed: {
        for (var diff in Difficulty.values) diff: 0,
      },
      gamesCompleted: {
        for (var diff in Difficulty.values) diff: 0,
      },
      bestTimes: {
        for (var diff in Difficulty.values) diff: 0,
      },
    );
  }

  void updateAfterGame({
    required Difficulty difficulty,
    required bool isWin,
    required int elapsedSeconds,
  }) {
    gamesPlayed[difficulty] = (gamesPlayed[difficulty] ?? 0) + 1;

    if (isWin) {
      gamesCompleted[difficulty] =
          (gamesCompleted[difficulty] ?? 0) + 1;

      final bestTime = bestTimes[difficulty];
      if (bestTime == null || elapsedSeconds < bestTime) {
        bestTimes[difficulty] = elapsedSeconds;
      }
    }
  }

  int get totalGamesPlayed =>
      gamesPlayed.values.fold(0, (sum, v) => sum + v);

  int get totalGamesWon =>
      gamesCompleted.values.fold(0, (sum, v) => sum + v);

  double get winRatio {
    if (totalGamesPlayed == 0) return 0;
    return (totalGamesWon / totalGamesPlayed) * 100;
  }
}