import '../../domain/entities/player.dart';
import 'player_profile_model.dart';

class PlayerModel {
  final String playerId;
  final String username;
  final List<String> friendIds;
  final PlayerProfileModel profile;

  PlayerModel({
    required this.playerId,
    required this.username,
    required this.friendIds,
    required this.profile,
  });

  factory PlayerModel.fromEntity(Player player) {
    return PlayerModel(
      playerId: player.playerId,
      username: player.username,
      friendIds: player.friendIds,
      profile: PlayerProfileModel.fromEntity(player.profile),
    );
  }

  Player toEntity() {
    return Player(
      playerId: playerId,
      username: username,
      friendIds: friendIds,
      profile: profile.toEntity(),
    );
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      playerId: json['id'],
      username: json['username'],
      friendIds: List<String>.from(json['friendIds']),
      profile: PlayerProfileModel.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': playerId,
      'username': username,
      'friendIds': friendIds,
      'profile': profile.toJson(),
    };
  }
}
