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
}