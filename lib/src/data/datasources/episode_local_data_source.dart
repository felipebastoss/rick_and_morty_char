import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:rick_and_morty_char/src/data/local/app_database.dart';

class EpisodeCacheData {
  EpisodeCacheData({
    required this.episodeId,
    required this.episodeName,
    required this.episodeCode,
    required this.characterIds,
    required this.cachedAt,
  });

  final int episodeId;
  final String episodeName;
  final String episodeCode;
  final List<int> characterIds;
  final DateTime cachedAt;
}

class CharacterCacheData {
  CharacterCacheData({required this.id, required this.name, required this.imageBytes, required this.cachedAt});

  final int id;
  final String name;
  final Uint8List imageBytes;
  final DateTime cachedAt;
}

class EpisodeLocalDataSource {
  EpisodeLocalDataSource(this._database);

  final AppDatabase _database;

  Future<List<EpisodeCacheData>> getEpisodes() async {
    final records = await _database.getEpisodes();
    return records
        .map(
          (record) => EpisodeCacheData(
            episodeId: record.id,
            episodeName: record.name,
            episodeCode: record.episodeCode,
            characterIds: _decodeIds(record.characterIdsJson),
            cachedAt: record.cachedAt,
          ),
        )
        .toList();
  }

  Future<void> upsertEpisodes(List<EpisodeCacheData> episodes) {
    final data = episodes
        .map(
          (episode) => EpisodeRecordsCompanion(
            id: Value(episode.episodeId),
            name: Value(episode.episodeName),
            episodeCode: Value(episode.episodeCode),
            characterIdsJson: Value(jsonEncode(episode.characterIds)),
            cachedAt: Value(episode.cachedAt),
          ),
        )
        .toList();

    return _database.upsertEpisodes(data);
  }

  Future<List<CharacterCacheData>> getCharactersByIds(List<int> ids) async {
    final records = await _database.getCharactersByIds(ids);
    return records
        .map(
          (record) => CharacterCacheData(
            id: record.id,
            name: record.name,
            imageBytes: record.imageBytes,
            cachedAt: record.cachedAt,
          ),
        )
        .toList();
  }

  Future<Set<int>> getCachedCharacterIds() {
    return _database.getAllCharacterIds();
  }

  Future<void> upsertCharacters(List<CharacterCacheData> characters) {
    final data = characters
        .map(
          (character) => CharacterRecordsCompanion(
            id: Value(character.id),
            name: Value(character.name),
            imageBytes: Value(character.imageBytes),
            cachedAt: Value(character.cachedAt),
          ),
        )
        .toList();

    return _database.upsertCharacters(data);
  }

  List<int> _decodeIds(String jsonValue) {
    final decoded = jsonDecode(jsonValue);
    if (decoded is! List) {
      return <int>[];
    }

    return decoded.map((entry) => int.tryParse(entry.toString())).whereType<int>().toList();
  }
}
