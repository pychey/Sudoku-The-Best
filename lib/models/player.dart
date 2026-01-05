import 'package:sudoku_the_best/models/player_profile.dart';

class Player {
  final String playerId;
  final String username;
  final List<String> friendIds;
  final PlayerProfile profile;

  Player({
    required this.playerId,
    required this.username,
    required this.friendIds,
    required this.profile,
  });
}