class SudokuBoard {
  final List<List<int>> solutionGrid;
  final List<List<int>> puzzleGrid;
  final List<List<bool>> fixedCells;

  SudokuBoard({
    required this.solutionGrid,
    required this.puzzleGrid,
    required this.fixedCells,
  });
}
