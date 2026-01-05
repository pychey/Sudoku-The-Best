import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sudoku_the_best/data/dtos/player_dto.dart';
import 'package:sudoku_the_best/models/player.dart';

String path = 'lib/data/database/players.json';

class PlayerRepository {
  Future<Player?> loadPlayerById(String playerId) async {
    final jsonString =
        await rootBundle.loadString(path);

    print(jsonString);
    final jsonData = json.decode(jsonString);
    final players = (jsonData['players'] as List?) ?? [];

    final playerJson = players.firstWhere(
      (p) => p['id'] == playerId,
      orElse: () => null,
    );

    if (playerJson == null) return null;
    
    return PlayerDto.fromJson(playerJson).toEntity();
  }

  Future<List<Player>> loadPlayersByIds(List<String> ids) async {
    final List<Player> friends = [];

    for (String id in ids) {
      final player = await loadPlayerById(id);
      if (player != null) friends.add(player);
    }

    return friends;
  }
}
