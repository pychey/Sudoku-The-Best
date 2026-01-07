import 'package:flutter/material.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';
import 'package:sudoku_the_best/models/game_state.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/models/sudoku_board.dart';
import 'package:sudoku_the_best/ui/screens/game_screen/online_game_screen.dart';
import 'package:sudoku_the_best/utils/socket_service.dart';
import 'package:sudoku_the_best/utils/sudoku_color.dart';

class MatchMakingScreen extends StatefulWidget {
  final Player currentPlayer;
  final Difficulty difficulty;
  const MatchMakingScreen({super.key, required this.difficulty, required this.currentPlayer});

  @override
  State<MatchMakingScreen> createState() => _MatchMakingScreenState();
}

class _MatchMakingScreenState extends State<MatchMakingScreen> {
  final SocketService socket = SocketService();
  String matchmakingMessage = '';
  Difficulty get difficulty => widget.difficulty;
  Player get currentPlayer => widget.currentPlayer;

  @override
  void initState() {
    super.initState();
    final sudokuGenerator = SudokuGenerator(emptySquares: difficulty.emptySquares, uniqueSolution: true);
    final sudokuBoard = SudokuBoard(
      board: sudokuGenerator.newSudoku,
      solvedBoard: sudokuGenerator.newSudokuSolved,
    );
    
    setupSocketListeners();
    joinMatchmaking(sudokuBoard);
  }

  @override
  void dispose() {
    socket.removeAllListeners();
    super.dispose();
  }

  void setupSocketListeners() {
    socket.onMatchmakingJoined((data) {
      setState(() {
        matchmakingMessage = data['message'];
      });
    });

    socket.onMatchFound((data) {
      final List<List<int>> board = (data['board'] as List).map((row) => (row as List).map((e) => e as int).toList()).toList();
      final List<List<int>> solvedBoard = (data['solvedBoard'] as List).map((row) => (row as List).map((e) => e as int).toList()).toList();
      final opponentUsername = (data['opponent'] as Map<String, dynamic>?)?[socket.socket?.id] ?? 'Opponent';
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OnlineGameScreen(
            difficulty: difficulty,
            currentPlayer: currentPlayer,
            board: board,
            solvedBoard: solvedBoard,
            opponentUsername: opponentUsername,
          ),
        ),
      );
    });
  }

  void joinMatchmaking(SudokuBoard sudokuBoard) {
    socket.joinMatchmaking(difficulty.keyName, currentPlayer.username, sudokuBoard.board, sudokuBoard.solvedBoard);
  }

  void _leaveMatchmaking() {
    socket.leaveMatchmaking(difficulty.keyName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  matchmakingMessage,
                  style: const TextStyle(
                    fontSize: 18,
                    color: SudokuColors.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Difficulty: ${widget.difficulty.name}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: SudokuColors.textColor,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _leaveMatchmaking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
}