import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/ui/screens/home_screen/tabs/profile_tab.dart';
import 'package:sudoku_the_best/ui/widgets/play_mode_dialog.dart';

void showFriendProfile(BuildContext context, Player friend) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, 
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.95, 
        minChildSize: 0.5,
        initialChildSize: 0.7,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  ProfileTab(player: friend),
                  Padding(
                    padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
                      child: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => showPlayModeDialog(context), 
                        child: const Text(
                          'Challenge',
                        )
                      ),
                    ),
                  ),
                ],
              )
            ),
          );
        },
      );
    },
  );
}

