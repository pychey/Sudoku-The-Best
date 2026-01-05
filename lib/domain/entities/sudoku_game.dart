import 'package:sudoku_the_best/domain/entities/sudoku_board.dart';
import 'package:sudoku_the_best/domain/enums/difficulty_enum.dart';
import 'package:sudoku_the_best/domain/enums/game_status_enum.dart';

class SudokuGame {
  final String gameId;
  final String playerId;
  final Difficulty difficulty;
  final GameStatus status;
  final SudokuBoard board;

  SudokuGame({
    required this.gameId,
    required this.playerId,
    required this.difficulty,
    required this.status,
    required this.board,
  });
}
