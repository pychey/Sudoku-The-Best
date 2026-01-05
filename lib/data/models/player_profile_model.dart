import 'package:sudoku_the_best/domain/entities/player_profile.dart';
import 'package:sudoku_the_best/domain/enums/difficulty_enum.dart';

class PlayerProfileModel {
  final Map<String, int> gamesPlayed;
  final Map<String, int> gamesCompleted;
  final Map<String, int> perfectWins;
  final Map<String, int> bestTimes;

  PlayerProfileModel({
    required this.gamesPlayed,
    required this.gamesCompleted,
    required this.perfectWins,
    required this.bestTimes,
  });

  factory PlayerProfileModel.fromEntity(PlayerProfile profile) {
    return PlayerProfileModel(
      gamesPlayed: _encode(profile.gamesPlayed),
      gamesCompleted: _encode(profile.gamesCompleted),
      perfectWins: _encode(profile.perfectWins),
      bestTimes: _encode(profile.bestTimes),
    );
  }

  PlayerProfile toEntity() {
    return PlayerProfile(
      gamesPlayed: _decode(gamesPlayed),
      gamesCompleted: _decode(gamesCompleted),
      perfectWins: _decode(perfectWins),
      bestTimes: _decode(bestTimes),
    );
  }

  factory PlayerProfileModel.fromJson(Map<String, dynamic> json) {
    return PlayerProfileModel(
      gamesPlayed: Map<String, int>.from(json['gamesPlayed']),
      gamesCompleted: Map<String, int>.from(json['gamesCompleted']),
      perfectWins: Map<String, int>.from(json['perfectWins']),
      bestTimes: Map<String, int>.from(json['bestTimes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gamesPlayed': gamesPlayed,
      'gamesCompleted': gamesCompleted,
      'perfectWins': perfectWins,
      'bestTimes': bestTimes,
    };
  }

  static Map<String, int> _encode(Map<Difficulty, int> map) =>
      map.map((k, v) => MapEntry(k.name, v));

  static Map<Difficulty, int> _decode(Map<String, int> map) =>
      map.map((k, v) => MapEntry(Difficulty.values.byName(k), v));
}
