import 'package:flutter/material.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/ui/widgets/friend_profile.dart';
import 'package:sudoku_the_best/ui/widgets/player_avatar.dart';
import '../../widgets/play_mode_dialog.dart';

class FriendTab extends StatelessWidget {
  final List<Player> friends;

  const FriendTab({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return const _EmptyFriendsState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Text(
                'FRIENDS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB5B9C2), 
                  foregroundColor: const Color(0xFF605D7C), 
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  '+ Add',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: friends.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final friend = friends[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  key: ValueKey(friend.playerId),
                  leading: PlayerAvatar(
                    username: friend.username,
                    radius: 22,
                    showOnline: true,
                  ),
                  title: Text(
                    friend.username,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => showPlayModeDialog(context),
                    child: const Text('Challenge'),
                  ),
                  
                  onTap: () => showFriendProfile(context, friend),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyFriendsState extends StatelessWidget {
  const _EmptyFriendsState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'No friends yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Add friends to play together',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

