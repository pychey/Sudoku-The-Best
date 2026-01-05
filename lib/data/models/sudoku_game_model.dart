import 'package:sudoku_the_best/domain/entities/sudoku_game.dart';
import 'package:sudoku_the_best/domain/enums/difficulty_enum.dart';
import 'package:sudoku_the_best/domain/enums/game_status_enum.dart';
import 'sudoku_board_model.dart';


class SudokuGameModel {
  final String gameId;
  final String playerId;
  final String difficulty;
  final String status;
  final SudokuBoardModel board;

  SudokuGameModel({
    required this.gameId,
    required this.playerId,
    required this.difficulty,
    required this.status,
    required this.board,
  });

  factory SudokuGameModel.fromEntity(SudokuGame game) {
    return SudokuGameModel(
      gameId: game.gameId,
      playerId: game.playerId,
      difficulty: game.difficulty.name,
      status: game.status.name,
      board: SudokuBoardModel.fromEntity(game.board),
    );
  }

  SudokuGame toEntity() {
    return SudokuGame(
      gameId: gameId,
      playerId: playerId,
      difficulty: Difficulty.values.byName(difficulty),
      status: GameStatus.values.byName(status),
      board: board.toEntity(),
    );
  }

  factory SudokuGameModel.fromJson(Map<String, dynamic> json) {
    return SudokuGameModel(
      gameId: json['gameId'],
      playerId: json['playerId'],
      difficulty: json['difficulty'],
      status: json['status'],
      board: SudokuBoardModel.fromJson(json['board']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'playerId': playerId,
      'difficulty': difficulty,
      'status': status,
      'board': board.toJson(),
    };
  }
}
