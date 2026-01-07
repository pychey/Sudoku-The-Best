import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/game_result_data.dart'; 
import 'package:sudoku_the_best/models/game_state.dart';
import 'package:sudoku_the_best/models/sudoku_board.dart';
import 'package:sudoku_the_best/utils/sudoku_color.dart';
import 'package:sudoku_the_best/ui/widgets/custom_info_tile.dart';
import 'package:sudoku_the_best/ui/widgets/custom_circle_button.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';
import 'dart:async';

class SoloGameScreen extends StatefulWidget {
  final Difficulty difficulty;

  const SoloGameScreen({super.key, required this.difficulty});

  @override
  State<SoloGameScreen> createState() => _SoloGameScreenState();
}

class _SoloGameScreenState extends State<SoloGameScreen> {
  late GameState gameState;
  late SudokuBoard sudokuBoard;

  @override
  void initState() {
    super.initState();
    gameState = GameState(difficulty: widget.difficulty);
    generateNewPuzzle();
  }

  @override
  void dispose() {
    gameState.stopTimer();
    super.dispose();
  }

  void generateNewPuzzle() {
    final sudokuGenerator = SudokuGenerator(emptySquares: gameState.difficulty.emptySquares, uniqueSolution: true);

    setState(() {
      sudokuBoard = SudokuBoard(
        board: sudokuGenerator.newSudoku,
        solvedBoard: sudokuGenerator.newSudokuSolved,
      );

      sudokuBoard.markInitialCell();

      gameState.reset();
      gameState.startTimer(() => setState(() {}));
    });
  }

  Color getBackgroundColor(int row, int col) {
    int blockRow = row ~/ 3;
    int blockCol = col ~/ 3;
    bool isAlternateBlock = (blockRow + blockCol) % 2 == 0;

    if (gameState.isCellSelected(row, col)) {
      return SudokuColors.boardFocusBackground;
    }

    return isAlternateBlock
        ? SudokuColors.boardBackground
        : SudokuColors.boardSecondBackground;
  }

  Color getTextColor(int row, int col) {
    if (gameState.isCellSelected(row, col)) {
      return SudokuColors.focusTextColor;
    }

    if (sudokuBoard.isCellInitial(row, col)) {
      return SudokuColors.textColor;
    }
    return SudokuColors.numberSelectColor;
  }

  Border getCellBorder(int row, int col) {
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
        color: col == 8 ? SudokuColors.mainBorder : Colors.transparent,
        width: col == 8 ? 2.0 : 0,
      ),
      bottom: BorderSide(
        color: row == 8 ? SudokuColors.mainBorder : Colors.transparent,
        width: row == 8 ? 2.0 : 0,
      ),
    );
  }

  Border getNumberCellBorder(int index) {
    const sideBorder = BorderSide(color: SudokuColors.lightBorder, width: 1.5);
    return Border(
        left: index == 0 ? sideBorder : BorderSide.none,
        right: sideBorder,
        top: sideBorder,
        bottom: sideBorder);
  }

  void onCellTap(int row, int col) {
    final isSameCell = gameState.isCellSelected(row, col);
    setState(() {
      if (isSameCell) {
        gameState.clearSelection();
      } else if (gameState.selectedNumber != null) {
        tryPlaceNumber(row, col, gameState.selectedNumber!);
        gameState.selectedNumber = null;
      } else {
        gameState.selectCell(row, col);
      }
    });
  }

  void onNumberSelect(int number) {
    setState(() {
      if (gameState.selectedNumber == number) {
        gameState.selectedNumber = null;
      } else if (gameState.hasSelectedCell) {
        tryPlaceNumber(gameState.selectedRow, gameState.selectedCol, number);
        if (sudokuBoard.board[gameState.selectedRow][gameState.selectedCol] != 0) {
          gameState.selectedNumber = number;
        }
        gameState.clearSelection();
      } else {
        gameState.selectedNumber = number;
      }
    });
  }

  void tryPlaceNumber(int row, int col, int number) {
    if (sudokuBoard.isCellEmpty(row, col)) {
      if (gameState.isNoteMode) {
        setState(() {
          sudokuBoard.addNote(row, col, number);
        });
      } else {
        if (sudokuBoard.isCorrectNumber(row, col, number)) {
          int earnedScore = sudokuBoard.calculateCellScore(row, col);
          sudokuBoard.placeNumber(row, col, number);
          gameState.totalScore += earnedScore;
          sudokuBoard.cleanupNotesAndMistakes(row, col, number);
          if (sudokuBoard.isPuzzleComplete()) {
            gameState.isWin = true;
            Future.delayed(const Duration(milliseconds: 300), () {
              showGameOverDialog();
            });
          }
        } else {
          sudokuBoard.addMistake(row, col, number);
          gameState.mistake++;
          if (gameState.mistake >= 3) {
            Future.delayed(const Duration(milliseconds: 300), () {
              showGameOverDialog();
            });
          }
        }
      }
    } else {
      gameState.selectCell(row, col);
    }
  }

  void toggleNoteMode() {
    setState(() {
      gameState.isNoteMode = !gameState.isNoteMode;
    });
  }

  void toggleTheme() {
    setState(() {
      gameState.isDarkMode = !gameState.isDarkMode;
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
              buildTopBar(context),
              const SizedBox(height: 24),
              buildSudokuBoard(),
              const SizedBox(height: 24),
              buildSettingTool(),
              const SizedBox(height: 24),
              buildNumberSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNumberSelector() {
    return AspectRatio(
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
                  bool isSelected = gameState.selectedNumber == number;

                  return GestureDetector(
                    onTap: () => onNumberSelect(number),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? SudokuColors.boardFocusBackground
                            : SudokuColors.boardBackground,
                        border: getNumberCellBorder(index),
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
            );
  }

  Widget buildSettingTool() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomCircleButton(
                  icon: gameState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  isActive: false,
                  onTap: toggleTheme,
                ),
                CustomCircleButton(
                  icon: Icons.edit,
                  isActive: gameState.isNoteMode,
                  onTap: toggleNoteMode,
                ),
              ],
            );
  }

  Widget buildSudokuBoard() {
    return AspectRatio(
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
                  int value = sudokuBoard.board[row][col];

                  return GestureDetector(
                    onTap: () => onCellTap(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getBackgroundColor(row, col),
                        border: getCellBorder(row, col),
                      ),
                      child: buildCellContent(row, col, value),
                    ),
                  );
                },
              ),
            );
  }

  Widget buildTopBar(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, GameResultData(
                      result: GameResult.quit,
                      totalScore: gameState.totalScore,
                      elapsedSeconds: gameState.elapsedSeconds,
                      board: sudokuBoard.board,
                      notes: sudokuBoard.notes,
                      difficulty: gameState.difficulty,
                    ));
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: SudokuColors.textColor,
                    size: 24,
                  ),
                ),
                Row(
                  children: [
                    CustomInfoTile(
                      icon: Icons.access_time,
                      text: gameState.elapsedTime,
                    ),
                    const SizedBox(width: 12),
                    CustomInfoTile(
                      icon: Icons.electric_bolt,
                      text: gameState.totalScore.toString(),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: SudokuColors.containerBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: List.generate(3, (index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SudokuColors.mistakeBackground),
                              child: index < gameState.mistake
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
            );
  }

  Widget buildCellContent(int row, int col, int value) {
    final isCellSolved = value != 0;
    if (isCellSolved) {
      return Center(
        child: Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: getTextColor(row, col),
          ),
        ),
      );
    }

    Set<int> cellNotes = sudokuBoard.notes[row][col];
    Set<int> cellMistakes = sudokuBoard.mistakes[row][col];

    if (cellNotes.isEmpty && cellMistakes.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        int number = index + 1;
        bool isNoted = cellNotes.contains(number);
        bool isMistake = cellMistakes.contains(number);

        if (!isNoted && !isMistake) {
          return const SizedBox.shrink();
        }

        return Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isMistake
                  ? SudokuColors.numberSelectColor
                  : SudokuColors.textColor,
            ),
          ),
        );
      },
    );
  }

  void showGameOverDialog() {
    gameState.stopTimer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            gameState.isWin ? 'Congratulations!' : 'Game Over!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: SudokuColors.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(
                gameState.isWin
                    ? 'You Completed the Puzzle Successfully!'
                    : 'You Made 3 Mistakes. Try Again, Better Luck Next Time!',
                style: const TextStyle(
                  fontSize: 16,
                  color: SudokuColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Final Score : ${gameState.totalScore.toString()}',
                style: const TextStyle(
                  fontSize: 16,
                  color: SudokuColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Solving Duration : ${gameState.elapsedTime}',
                style: const TextStyle(
                  fontSize: 16,
                  color: SudokuColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(
                      context,
                      GameResultData(
                        result: gameState.isWin ? GameResult.completed : GameResult.failed,
                        difficulty: widget.difficulty,
                        totalScore: gameState.totalScore,
                        elapsedSeconds: gameState.elapsedSeconds,
                      ),
                    );
                  },
                  child: const Text('Back Home'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    generateNewPuzzle();
                  },
                  child: const Text('Play Again'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}