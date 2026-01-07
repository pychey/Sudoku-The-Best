import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/game_state.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/models/sudoku_board.dart';
import 'package:sudoku_the_best/utils/socket_service.dart';
import 'package:sudoku_the_best/utils/sudoku_color.dart';
import 'package:sudoku_the_best/ui/widgets/custom_info_tile.dart';
import 'package:sudoku_the_best/ui/widgets/custom_circle_button.dart';

class OnlineGameScreen extends StatefulWidget {
  final Difficulty difficulty;
  final Player currentPlayer;
  final List<List<int>> board;
  final List<List<int>> solvedBoard;
  final String opponentUsername;

  const OnlineGameScreen({
    super.key,
    required this.difficulty,
    required this.currentPlayer,
    required this.board,
    required this.solvedBoard,
    required this.opponentUsername,
  });

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
  late GameState gameState;
  late SudokuBoard sudokuBoard;
  final SocketService socket = SocketService();
  int opponentScore = 0;
  int opponentMistakes = 0;
  late List<List<bool>> isOpponentCell;
  Player get currentPlayer => widget.currentPlayer;

  @override
  void initState() {
    super.initState();
    
    setupSocketListeners();

    gameState = GameState(difficulty: widget.difficulty);
    sudokuBoard = SudokuBoard(
      board: widget.board,
      solvedBoard: widget.solvedBoard,
    );
    
    isOpponentCell = List.generate(9, (_) => List.generate(9, (_) => false));
    
    sudokuBoard.markInitialCell();
    gameState.startTimer(() => setState(() {}));
  }

  @override
  void dispose() {
    gameState.stopTimer();
    socket.removeAllListeners();
    super.dispose();
  }

  void setupSocketListeners() {
    socket.onCellPlacedCorrect((data) {
      final playerId = data['playerId'];
      final row = data['row'];
      final col = data['col'];
      final number = data['number'];
      final isMyMove = playerId == socket.socket?.id;
      
      setState(() {
        sudokuBoard.placeNumber(row, col, number);
        sudokuBoard.cleanupNotesAndMistakes(row, col, number);
        
        if (isMyMove) {
          gameState.totalScore = data['newScore'];
        } else {
          isOpponentCell[row][col] = true;
          opponentScore = data['newScore'];
        }
      });

      if (sudokuBoard.isPuzzleComplete()) {
        final myScore = gameState.totalScore;
        final oppScore = opponentScore;
        final isWinner = myScore > oppScore;
        final winnerUsername = isWinner ? widget.currentPlayer.username : widget.opponentUsername;
        
        Future.delayed(const Duration(milliseconds: 300), () {
          showGameOverDialog(
            isWinner: isWinner,
            winnerUsername: winnerUsername,
            reason: isWinner ? 'You Have More Score Than Your Opponent' : 'Your Opponent Have More Score Than You',
          );
        });
      }
    });

    socket.onMistakeMade((data) {
      final playerId = data['playerId'];
      final isMyMove = playerId == socket.socket?.id;
      
      setState(() {
        if (isMyMove) {
          gameState.mistake = data['newMistakes'];
        } else {
          opponentMistakes = data['newMistakes'];
        }
      });

      if (gameState.mistake >= 3 || opponentMistakes >= 3) {
        final iLost = gameState.mistake >= 3;
        final winnerUsername = iLost ? widget.opponentUsername : currentPlayer.username;
        
        Future.delayed(const Duration(milliseconds: 300), () {
          showGameOverDialog(
            isWinner: !iLost,
            winnerUsername: winnerUsername,
            reason: iLost ? 'You Have Made 3 Mistakes' : 'Your Opponent Have Made 3 Mistakes',
          );
        });
      }
    });

    socket.onOpponentDisconnected((data) {
      gameState.stopTimer();
      showOpponentDisconnectedDialog(data['message']);
    });
    
    socket.onOpponentLeave((data) {
      Future.delayed(const Duration(milliseconds: 300), () {
        showGameOverDialog(
          isWinner: true,
          winnerUsername: currentPlayer.username,
          reason: 'Your Opponent Left The Match',
        );
      });
    });
  }

  void handleLeaveGame() {
    socket.leaveGame();
    Navigator.pop(context);
    Navigator.pop(context);
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
          int newScore = gameState.totalScore + earnedScore;
          
          socket.placeCorrect(row, col, number, newScore);
        } else {
          sudokuBoard.addMistake(row, col, number);
          int newMistakes = gameState.mistake + 1;
          
          socket.placeWrong(newMistakes);
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
    
    // Check if opponent's cell (red) or yours (blue)
    if (isOpponentCell[row][col]) {
      return Colors.red;
    }
    
    return SudokuColors.numberSelectColor; // Blue for your moves
  }

  Border getCellBorder(int row, int col) {
    return Border(
      top: BorderSide(
        color: row % 3 == 0 ? SudokuColors.mainBorder : SudokuColors.lightBorder,
        width: row % 3 == 0 ? 2.0 : 0.5,
      ),
      left: BorderSide(
        color: col % 3 == 0 ? SudokuColors.mainBorder : SudokuColors.lightBorder,
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
              const SizedBox(height: 16),
              buildPlayerStats(),
              const SizedBox(height: 16),
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

  Widget buildPlayerStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildPlayerCard(
          widget.currentPlayer.username,
          gameState.totalScore,
          gameState.mistake,
          isCurrentPlayer: true,
        ),
        _buildPlayerCard(
          widget.opponentUsername,
          opponentScore,
          opponentMistakes,
          isCurrentPlayer: false,
        ),
      ],
    );
  }

  Widget _buildPlayerCard(String name, int score, int mistakes, {required bool isCurrentPlayer}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentPlayer 
            ? SudokuColors.boardFocusBackground.withValues(alpha: 0.1)
            : SudokuColors.containerBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentPlayer 
              ? SudokuColors.boardFocusBackground
              : SudokuColors.lightBorder,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SudokuColors.textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.electric_bolt, size: 16, color: SudokuColors.numberSelectColor),
              const SizedBox(width: 4),
              Text(
                score.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: SudokuColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: SudokuColors.mistakeBackground,
                  ),
                  child: index < mistakes
                      ? const Icon(
                          Icons.close,
                          color: SudokuColors.textColor,
                          size: 14,
                        )
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: handleLeaveGame,
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: SudokuColors.textColor,
            size: 24,
          ),
        ),
        CustomInfoTile(
          icon: Icons.access_time,
          text: gameState.elapsedTime,
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

  void showGameOverDialog({
    required bool isWinner,
    required String winnerUsername,
    required String reason,
  }) {
    gameState.stopTimer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isWinner ? 'Victory!' : 'Defeat!',
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
                isWinner 
                    ? 'Congratulations! You Won!'
                    : '$winnerUsername Won the Game!',
                style: const TextStyle(fontSize: 16, color: SudokuColors.textColor),
                textAlign: TextAlign.center,
              ),
              Text(
                reason,
                style: const TextStyle(fontSize: 14, color: SudokuColors.textColor),
                textAlign: TextAlign.center,
              ),
              Text(
                'Duration: ${gameState.elapsedTime}',
                style: const TextStyle(fontSize: 14, color: SudokuColors.textColor),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Home'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Play Again'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showOpponentDisconnectedDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Opponent Disconnected',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: SudokuColors.textColor),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16, color: SudokuColors.textColor),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ),
          ],
        );
      },
    );
  }
}