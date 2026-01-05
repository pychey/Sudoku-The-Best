import 'package:sudoku_the_best/models/game_state.dart';

enum GameResult { quit, completed, failed }

class GameResultData {
  final GameResult result; 
  final int totalScore;
  final int elapsedSeconds;
  final List<List<int>>? board;     
  final List<List<Set<int>>>? notes; 
  final Difficulty difficulty;

  GameResultData({
    required this.result,
    required this.totalScore,
    required this.elapsedSeconds,
    this.board,
    this.notes,
    required this.difficulty,
  });
}
