import 'package:flutter/material.dart';
import 'package:sudoku_the_best/ui/screens/home_screen.dart';
import 'package:sudoku_the_best/utils/sudoku_color.dart';

void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: WidgetStatePropertyAll(2),
            backgroundColor: WidgetStatePropertyAll(SudokuColors.boardFocusBackground),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            textStyle: WidgetStatePropertyAll(
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          )
        )
      ),
      title: 'Sudoku The Best',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}