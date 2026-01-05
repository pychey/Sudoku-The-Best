import 'package:sudoku_the_best/domain/enums/difficulty_enum.dart';

class PlayerProfile {
  final Map<Difficulty, int> gamesPlayed;
  final Map<Difficulty, int> gamesCompleted;
  final Map<Difficulty, int> perfectWins;
  final Map<Difficulty, int> bestTimes;

  PlayerProfile({
    required this.gamesPlayed,
    required this.gamesCompleted,
    required this.perfectWins,
    required this.bestTimes,
  });
}