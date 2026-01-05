import '../../models/entities/player.dart';
import 'player_profile_dto.dart';

class PlayerDto {
  final String playerId;
  final String username;
  final List<String> friendIds;
  final PlayerProfileDto profile;

  PlayerDto({
    required this.playerId,
    required this.username,
    required this.friendIds,
    required this.profile,
  });

  factory PlayerDto.fromEntity(Player player) {
    return PlayerDto(
      playerId: player.playerId,
      username: player.username,
      friendIds: player.friendIds,
      profile: PlayerProfileDto.fromEntity(player.profile),
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

  factory PlayerDto.fromJson(Map<String, dynamic> json) {
    return PlayerDto(
      playerId: json['id'],
      username: json['username'],
      friendIds: List<String>.from(json['friendIds']),
      profile: PlayerProfileDto.fromJson(json['profile']),
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
