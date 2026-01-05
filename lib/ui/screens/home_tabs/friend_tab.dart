import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/player.dart';
import '../../widgets/play_mode_dialog.dart';

class FriendTab extends StatelessWidget {
  final List<Player> friends;

  const FriendTab({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: friends.map((friend) {
        return ListTile(
          title: Text(friend.username),
          onTap: () {
            showPlayModeDialog(context);
          },
        );
      }).toList(),
    );
  }
}
