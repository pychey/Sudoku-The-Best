import 'package:sudoku_the_best/models/game_state.dart';
import 'package:sudoku_the_best/models/player_profile.dart';

class PlayerProfileDto {
  final Map<String, int> gamesPlayed;
  final Map<String, int> gamesCompleted;
  final Map<String, int> bestTimes;

  PlayerProfileDto({
    required this.gamesPlayed,
    required this.gamesCompleted,
    required this.bestTimes,
  });

  factory PlayerProfileDto.fromEntity(PlayerProfile profile) {
    return PlayerProfileDto(
      gamesPlayed: _encode(profile.gamesPlayed),
      gamesCompleted: _encode(profile.gamesCompleted),
      bestTimes: _encode(profile.bestTimes),
    );
  }

  PlayerProfile toEntity() {
    return PlayerProfile(
      gamesPlayed: _decode(gamesPlayed),
      gamesCompleted: _decode(gamesCompleted),
      bestTimes: _decode(bestTimes),
    );
  }

  factory PlayerProfileDto.fromJson(Map<String, dynamic> json) {
    return PlayerProfileDto(
      gamesPlayed: Map<String, int>.from(json['gamesPlayed']),
      gamesCompleted: Map<String, int>.from(json['gamesCompleted']),
      bestTimes: Map<String, int>.from(json['bestTimes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gamesPlayed': gamesPlayed,
      'gamesCompleted': gamesCompleted,
      'bestTimes': bestTimes,
    };
  }

  static Map<String, int> _encode(Map<Difficulty, int> map) =>
      map.map((k, v) => MapEntry(k.name, v));

  static Map<Difficulty, int> _decode(Map<String, int> map) =>
      map.map((k, v) => MapEntry(Difficulty.values.byName(k), v));
}
