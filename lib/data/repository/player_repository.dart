import 'dart:convert';
import 'package:flutter/services.dart';
import '../dtos/player_dto.dart';
import '../../models/player.dart';

class PlayerRepository {
  static const String path = 'assets/database/players.json';

  Future<List<PlayerDto>> _loadAllDtos() async {
    final jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString);
    final list = jsonData['players'] as List;
    return list.map((p) => PlayerDto.fromJson(p)).toList();
  }

  Future<Player?> loadPlayerById(String playerId) async {
    final dtos = await _loadAllDtos();
    final dtoMap = {for (var d in dtos) d.playerId: d};
    final dto = dtoMap[playerId];
    if (dto == null) return null;

    return _buildPlayer(dto, dtoMap);
  }

  Future<Player?> loadPlayerByUsername(String username) async {
    final dtos = await _loadAllDtos();
    final dtoMapById = {for (var d in dtos) d.playerId: d};

    PlayerDto? dto;
    try {
      dto = dtos.firstWhere((d) => d.username == username);
    } catch (e) {
      dto = null;
    }

    if (dto == null) return null;

    return _buildPlayer(dto, dtoMapById);
  }

  Player _buildPlayer(PlayerDto dto, Map<String, PlayerDto> dtoMap) {
    final friends = dto.friendIds
        .map((id) => dtoMap[id])
        .whereType<PlayerDto>()
        .map((friendDto) => Player(
              playerId: friendDto.playerId,
              username: friendDto.username,
              friends: const [], // direct friends only
              profile: friendDto.profile.toEntity(),
            ))
        .toList();

    return Player(
      playerId: dto.playerId,
      username: dto.username,
      friends: friends,
      profile: dto.profile.toEntity(),
    );
  }
}
