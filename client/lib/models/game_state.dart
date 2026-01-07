import 'package:flutter/material.dart';
import 'dart:async';

enum Difficulty {
  easy(name: 'Easy', keyName: 'easy', emptySquares: 18),
  medium(name: 'Medium', keyName: 'medium', emptySquares: 36),
  hard(name: 'Hard', keyName: 'hard', emptySquares: 54);

  // easy(name: 'Easy', emptySquares: 27),
  // medium(name: 'Medium', emptySquares: 36),
  // hard(name: 'Hard', emptySquares: 54);

  final String name;
  final String keyName;
  final int emptySquares;

  const Difficulty({
    required this.name,
    required this.keyName,
    required this.emptySquares
  });
}

class GameState {
  int mistake;
  int selectedRow;
  int selectedCol;
  int? selectedNumber;
  bool isNoteMode;
  bool isWin;
  int totalScore;
  bool isDarkMode;
  Timer? timer;
  int elapsedSeconds;
  String elapsedTime;
  Difficulty difficulty;

  GameState({
    this.mistake = 0,
    this.selectedRow = -1,
    this.selectedCol = -1,
    this.selectedNumber,
    this.isNoteMode = false,
    this.isWin = false,
    this.totalScore = 0,
    this.isDarkMode = false,
    this.elapsedSeconds = 0,
    this.elapsedTime = '00:00',
    this.difficulty = Difficulty.easy
  });

  void reset() {
    mistake = 0;
    selectedRow = -1;
    selectedCol = -1;
    selectedNumber = null;
    isNoteMode = false;
    isWin = false;
    totalScore = 0;
    elapsedSeconds = 0;
    elapsedTime = '00:00';
  }

  void selectCell(int row, int col) {
    selectedRow = row;
    selectedCol = col;
  }

  void clearSelection() {
    selectedRow = -1;
    selectedCol = -1;
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void startTimer(VoidCallback onTick) {
    elapsedSeconds = 0;
    elapsedTime = '00:00';
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds++;
      elapsedTime = formatTime(elapsedSeconds);
      onTick();
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  bool isCellSelected(int row, int col) {
    return selectedRow == row && selectedCol == col;
  }

  bool get hasSelectedCell => selectedRow != -1 && selectedCol != -1;
}