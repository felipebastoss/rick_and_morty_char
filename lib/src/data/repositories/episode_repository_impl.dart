import 'dart:async';
import 'dart:typed_data';

import 'package:rick_and_morty_char/src/data/datasources/episode_local_data_source.dart';
import 'package:rick_and_morty_char/src/data/datasources/episode_remote_data_source.dart';
import 'package:rick_and_morty_char/src/data/models/episode_response_dto.dart';
import 'package:rick_and_morty_char/src/domain/entities/character.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/domain/repositories/episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  EpisodeRepositoryImpl(this._remote, this._local);

  final EpisodeRemoteDataSource _remote;
  final EpisodeLocalDataSource _local;

  @override
  Future<List<EpisodeOverview>> getCachedEpisodesOverview() async {
    final cachedEpisodes = await _local.getEpisodes();
    if (cachedEpisodes.isEmpty) {
      return <EpisodeOverview>[];
    }

    final cachedCharacterIds = await _local.getCachedCharacterIds();
    final summaries = cachedEpisodes
        .map(
          (episode) => EpisodeSummary(
            id: episode.episodeId,
            name: episode.episodeName,
            episodeCode: episode.episodeCode,
            characterIds: episode.characterIds,
          ),
        )
        .toList();

    summaries.sort((a, b) => a.id.compareTo(b.id));

    return summaries.map((episode) => _buildOverview(episode, cachedCharacterIds)).toList();
  }

  @override
  Future<List<EpisodeOverview>> fetchEpisodesOverview() async {
    final episodes = await _remote.getAllEpisodes();
    final summaries = episodes.map(_toSummary).toList();

    await _local.upsertEpisodes(
      summaries
          .map(
            (episode) => EpisodeCacheData(
              episodeId: episode.id,
              episodeName: episode.name,
              episodeCode: episode.episodeCode,
              characterIds: episode.characterIds,
              cachedAt: DateTime.now(),
            ),
          )
          .toList(),
    );

    final cachedCharacterIds = await _local.getCachedCharacterIds();
    summaries.sort((a, b) => a.id.compareTo(b.id));

    return summaries.map((episode) => _buildOverview(episode, cachedCharacterIds)).toList();
  }

  @override
  Future<EpisodeCharacters?> getCachedEpisodeCharacters(EpisodeSummary episode) async {
    final cached = await _local.getCharactersByIds(episode.characterIds);
    if (cached.isEmpty) {
      return null;
    }

    final characters = cached
        .map(
          (character) =>
              Character(id: character.id, name: character.name, imageBytes: _sanitizeImageBytes(character.imageBytes)),
        )
        .toList();

    _sortCharacters(characters);

    return EpisodeCharacters(episode: episode, characters: characters);
  }

  @override
  Stream<EpisodeCharacters> fetchEpisodeCharacters(EpisodeSummary episode) async* {
    final ids = _uniqueIds(episode.characterIds);
    final cachedCharacters = await _local.getCharactersByIds(ids);
    final cachedById = {for (final character in cachedCharacters) character.id: character};

    final charactersDto = await _remote.getCharactersByIds(ids);
    final characters = charactersDto
        .map(
          (character) => Character(
            id: character.id,
            name: character.name,
            imageBytes: _sanitizeImageBytes(cachedById[character.id]?.imageBytes ?? Uint8List(0)),
          ),
        )
        .toList();

    _sortCharacters(characters);

    yield EpisodeCharacters(episode: episode, characters: List<Character>.unmodifiable(characters));

    final indexById = <int, int>{for (var i = 0; i < characters.length; i++) characters[i].id: i};

    final pending = charactersDto.where(
      (character) => (cachedById[character.id]?.imageBytes.isNotEmpty ?? false) == false,
    );

    final updates = Stream.fromFutures(
      pending.map(
        (character) async => _CharacterImageUpdate(
          id: character.id,
          name: character.name,
          bytes: await _fetchImageBytesSafe(character.image),
        ),
      ),
    );

    await for (final update in updates) {
      if (update.bytes.isEmpty) {
        continue;
      }

      final index = indexById[update.id];
      if (index == null) {
        continue;
      }

      characters[index] = Character(id: update.id, name: characters[index].name, imageBytes: update.bytes);

      await _local.upsertCharacters([
        CharacterCacheData(id: update.id, name: update.name, imageBytes: update.bytes, cachedAt: DateTime.now()),
      ]);

      yield EpisodeCharacters(
        episode: episode,
        characters: List<Character>.unmodifiable(List<Character>.from(characters)),
      );
    }
  }

  EpisodeSummary _toSummary(EpisodeResponseDto dto) {
    return EpisodeSummary(
      id: dto.id,
      name: dto.name,
      episodeCode: dto.episodeCode,
      characterIds: _extractCharacterIds(dto.characterUrls),
    );
  }

  EpisodeOverview _buildOverview(EpisodeSummary episode, Set<int> cachedIds) {
    final totalCount = episode.characterIds.length;
    final cachedCount = episode.characterIds.where(cachedIds.contains).length;

    final status = cachedCount == 0
        ? EpisodeCacheStatus.uncached
        : cachedCount == totalCount
        ? EpisodeCacheStatus.full
        : EpisodeCacheStatus.partial;

    return EpisodeOverview(episode: episode, cacheStatus: status, cachedCount: cachedCount, totalCount: totalCount);
  }

  List<int> _extractCharacterIds(List<String> urls) {
    return urls.map((url) => int.tryParse(url.split('/').last)).whereType<int>().toSet().toList();
  }

  List<int> _uniqueIds(List<int> ids) {
    return ids.toSet().toList();
  }

  void _sortCharacters(List<Character> characters) {
    characters.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<Uint8List> _fetchImageBytesSafe(String url) async {
    if (url.isEmpty) {
      return Uint8List(0);
    }

    try {
      final bytes = await _remote.getImageBytes(url);
      return _sanitizeImageBytes(bytes);
    } catch (_) {
      return Uint8List(0);
    }
  }

  Uint8List _sanitizeImageBytes(Uint8List bytes) {
    if (_isJpeg(bytes) || _isPng(bytes)) {
      return bytes;
    }

    return Uint8List(0);
  }

  bool _isJpeg(Uint8List bytes) {
    return bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xD8;
  }

  bool _isPng(Uint8List bytes) {
    return bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
  }
}

class _CharacterImageUpdate {
  _CharacterImageUpdate({required this.id, required this.name, required this.bytes});

  final int id;
  final String name;
  final Uint8List bytes;
}
