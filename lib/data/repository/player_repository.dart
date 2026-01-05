import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sudoku_the_best/data/models/player_model.dart';
import 'package:sudoku_the_best/domain/entities/player.dart';

class PlayerRepository {
  Future<Player?> loadPlayerById(String playerId) async {
    final jsonString =
        await rootBundle.loadString('assets/database/players.json');

    // print(jsonString);
    final jsonData = json.decode(jsonString);
    final players = (jsonData['players'] as List?) ?? [];

    final playerJson = players.firstWhere(
      (p) => p['id'] == playerId,
      orElse: () => null,
    );

    if (playerJson == null) return null;
    
    return PlayerModel.fromJson(playerJson).toEntity();
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
