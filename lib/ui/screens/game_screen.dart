import 'package:flutter/material.dart';
import 'package:sudoku_the_best/ui/utils/sudoku_color.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int mistakes = 2;
  int selectedRow = -1;
  int selectedCol = -1;
  int? selectedNumber;
  bool isNoteMode = false;
  String elapsedTime = "12:01";

  List<List<int>> board = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9],
  ];

  Color _getBackgroundColor(int row, int col) {
    int blockRow = row ~/ 3;
    int blockCol = col ~/ 3;
    bool isAlternateBlock = (blockRow + blockCol) % 2 == 0;

    if (selectedRow == row && selectedCol == col) {
      return SudokuColors.boardFocusBackground;
    }

    return isAlternateBlock
        ? SudokuColors.boardBackground
        : SudokuColors.boardSecondBackground;
  }

  Color _getTextColor(int row, int col) {
    if (selectedRow == row && selectedCol == col) {
      return SudokuColors.focusTextColor;
    }
    return SudokuColors.textColor;
  }

  Border _getCellBorder(int row, int col) {
    return Border(
      top: BorderSide(
        color: row % 3 == 0
            ? SudokuColors.mainBorder
            : SudokuColors.lightBorder,
        width: row % 3 == 0 ? 2.0 : 0.5,
      ),
      left: BorderSide(
        color: col % 3 == 0
            ? SudokuColors.mainBorder
            : SudokuColors.lightBorder,
        width: col % 3 == 0 ? 2.0 : 0.5,
      ),
      right: BorderSide(
        color: col == 8
            ? SudokuColors.mainBorder
            : Colors.transparent,
        width: col == 8 ? 2.0 : 0,
      ),
      bottom: BorderSide(
        color: row == 8
            ? SudokuColors.mainBorder
            : Colors.transparent,
        width: row == 8 ? 2.0 : 0,
      ),
    );
  }

  Border _getNumberCellBorder(int index) {
    const sideBorder = BorderSide(color: SudokuColors.lightBorder, width: 1.5);
    return Border(
      left: index == 0 ? sideBorder : BorderSide.none,
      right: sideBorder,
      top: sideBorder,
      bottom: sideBorder
    );
  }

  void _onCellTap(int row, int col) {
    final isSameCell = selectedRow == row && selectedCol == col;
    setState(() {
      if (isSameCell) {
        _clearSelection();
      } else if (selectedNumber != null) {
        _tryPlaceNumber(row, col, selectedNumber!);
        selectedNumber = null;
      } else {
        _selectCell(row, col);
      }
    });
  }

  void _onNumberSelect(int number) {
    final isCellSelected = selectedRow != -1 && selectedCol != -1;
    setState(() {
      if (selectedNumber == number) {
        selectedNumber = null;
      } else if (isCellSelected) {
        _tryPlaceNumber(selectedRow, selectedCol, number);
        if (board[selectedRow][selectedCol] != 0) selectedNumber = number;
        _clearSelection();
      } else {
        selectedNumber = number;
      }
    });
  }

  void _tryPlaceNumber(int row, int col, int number) {
    if (board[row][col] == 0) {
      board[row][col] = number;
    } else {
      _selectCell(row, col);
    }
  }

  void _toggleNoteMode() {
    setState(() {
      isNoteMode = !isNoteMode;
    });
  }

  void _selectCell(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void _clearSelection() {
    setState(() {
      selectedRow = -1;
      selectedCol = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: SudokuColors.textColor,
                      size: 24,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: SudokuColors.containerBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: SudokuColors.textColor,
                              size: 24,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              elapsedTime,
                              style: const TextStyle(
                                color: SudokuColors.textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Mistakes container
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: SudokuColors.containerBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: List.generate(3, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SudokuColors.mistakeBackground
                                ),
                                child: index < mistakes
                                    ? const Icon(
                                        Icons.close,
                                        color: SudokuColors.textColor,
                                        size: 18,
                                        fontWeight: FontWeight.w600,
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                    childAspectRatio: 1,
                  ),
                  itemCount: 81,
                  itemBuilder: (context, index) {
                    int row = index ~/ 9;
                    int col = index % 9;
                    int value = board[row][col];
                    
                    return GestureDetector(
                      onTap: () => _onCellTap(row, col),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getBackgroundColor(row, col),
                          border: _getCellBorder(row, col),
                        ),
                        child: Center(
                          child: value != 0
                              ? Text(
                                  value.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: _getTextColor(row, col),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: SudokuColors.containerBackground,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: SudokuColors.textColor,
                        size: 24,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleNoteMode,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isNoteMode
                            ? SudokuColors.boardFocusBackground
                            : SudokuColors.containerBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: isNoteMode
                            ? SudokuColors.focusTextColor
                            : SudokuColors.textColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
      
              // Number selection grid
              AspectRatio(
                aspectRatio: 9,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                    childAspectRatio: 1,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    int number = index + 1;
                    bool isSelected = selectedNumber == number;
      
                    return GestureDetector(
                      onTap: () => _onNumberSelect(number),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? SudokuColors.boardFocusBackground
                              : SudokuColors.boardBackground,
                          border: _getNumberCellBorder(index),
                        ),
                        child: Center(
                          child: Text(
                            number.toString(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? SudokuColors.focusTextColor
                                  : SudokuColors.numberSelectColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}