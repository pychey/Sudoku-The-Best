class SudokuBoard {
  List<List<int>> board;
  List<List<int>> solvedBoard;
  List<List<bool>> isInitialCell;
  List<List<Set<int>>> notes;
  List<List<Set<int>>> mistakes;

  SudokuBoard({
    required this.board,
    required this.solvedBoard,
    List<List<bool>>? isInitialCell,
    List<List<Set<int>>>? notes,
    List<List<Set<int>>>? mistakes,
  })  : isInitialCell = isInitialCell ?? List.generate(9, (_) => List.generate(9, (_) => false)),
        notes = notes ?? List.generate(9, (_) => List.generate(9, (_) => <int>{})),
        mistakes = mistakes ?? List.generate(9, (_) => List.generate(9, (_) => <int>{}));

  void markInitialCell() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        isInitialCell[i][j] = board[i][j] != 0;
      }
    }
  }

  bool isPuzzleComplete() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] != solvedBoard[i][j]) return false;
      }
    }
    return true;
  }

  int calculateCellScore(int row, int col) {
    int filledInRow = 0;
    for (int i = 0; i < 9; i++) {
      if (board[row][i] != 0) filledInRow++;
    }

    int filledInCol = 0;
    for (int i = 0; i < 9; i++) {
      if (board[i][col] != 0) filledInCol++;
    }

    int gridStartRow = (row ~/ 3) * 3;
    int gridStartCol = (col ~/ 3) * 3;
    int filledInGrid = 0;
    for (int i = gridStartRow; i < gridStartRow + 3; i++) {
      for (int j = gridStartCol; j < gridStartCol + 3; j++) {
        if (board[i][j] != 0) filledInGrid++;
      }
    }

    int rowDifficulty = 9 - filledInRow;
    int colDifficulty = 9 - filledInCol;
    int gridDifficulty = 9 - filledInGrid;

    double difficultyMultiplier = (rowDifficulty + colDifficulty + gridDifficulty) / 3;
    int score = 100 + (difficultyMultiplier * 25).round();

    return score;
  }

  void addNote(int row, int col, int number) {
    if (notes[row][col].contains(number)) {
      notes[row][col].remove(number);
    } else {
      notes[row][col].add(number);
    }
  }

  void addMistake(int row, int col, int number) {
    mistakes[row][col].add(number);
  }

  void placeNumber(int row, int col, int number) {
    board[row][col] = number;
    notes[row][col].clear();
    mistakes[row][col].clear();
  }

  void cleanupNotesAndMistakes(int row, int col, int number) {
    for (int i = 0; i < 9; i++) {
      notes[row][i].remove(number);
      mistakes[row][i].remove(number);
    }

    for (int i = 0; i < 9; i++) {
      notes[i][col].remove(number);
      mistakes[i][col].remove(number);
    }

    int gridStartRow = (row ~/ 3) * 3;
    int gridStartCol = (col ~/ 3) * 3;
    for (int i = gridStartRow; i < gridStartRow + 3; i++) {
      for (int j = gridStartCol; j < gridStartCol + 3; j++) {
        notes[i][j].remove(number);
        mistakes[i][j].remove(number);
      }
    }
  }

  bool isCorrectNumber(int row, int col, int number) {
    return solvedBoard[row][col] == number;
  }

  bool isCellEmpty(int row, int col) {
    return board[row][col] == 0;
  }

  bool isCellInitial(int row, int col) {
    return isInitialCell[row][col];
  }
}