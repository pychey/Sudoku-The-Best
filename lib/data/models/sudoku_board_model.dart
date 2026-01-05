import 'package:sudoku_the_best/domain/entities/sudoku_board.dart';

class SudokuBoardModel {
  final List<List<int>> solutionGrid;
  final List<List<int>> puzzleGrid;
  final List<List<bool>> fixedCells;

  SudokuBoardModel({
    required this.solutionGrid,
    required this.puzzleGrid,
    required this.fixedCells,
  });

  factory SudokuBoardModel.fromEntity(SudokuBoard board) {
    return SudokuBoardModel(
      solutionGrid: board.solutionGrid,
      puzzleGrid: board.puzzleGrid,
      fixedCells: board.fixedCells,
    );
  }

  SudokuBoard toEntity() {
    return SudokuBoard(
      solutionGrid: solutionGrid,
      puzzleGrid: puzzleGrid,
      fixedCells: fixedCells,
    );
  }

  factory SudokuBoardModel.fromJson(Map<String, dynamic> json) {
    return SudokuBoardModel(
      solutionGrid: List<List<int>>.from(
        json['solutionGrid'].map((r) => List<int>.from(r)),
      ),
      puzzleGrid: List<List<int>>.from(
        json['puzzleGrid'].map((r) => List<int>.from(r)),
      ),
      fixedCells: List<List<bool>>.from(
        json['fixedCells'].map((r) => List<bool>.from(r)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'solutionGrid': solutionGrid,
      'puzzleGrid': puzzleGrid,
      'fixedCells': fixedCells,
    };
  }
}
