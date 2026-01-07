import 'package:sudoku_the_best/data/repository/player_repository.dart';
import 'package:sudoku_the_best/models/player_profile.dart';

class Player {
  final String playerId;
  final String username;
  final List<Player> friends;
  final PlayerProfile profile;

  Player({
    required this.playerId,
    required this.username,
    required this.friends,
    required this.profile,
  });

  Future<Player> addFriend(String friendUsername) async {
    final repo = PlayerRepository();
    final friend = await repo.loadPlayerByUsername(friendUsername);

    if (friend == null) {
      throw Exception('No player found with username $friendUsername');
    }
    
    if (friends.any((f) => f.playerId == friend.playerId)) {
      return this;
    }

    return Player(
      playerId: playerId,
      username: username,
      friends: [...friends, friend], 
      profile: profile,
    );
  }
}