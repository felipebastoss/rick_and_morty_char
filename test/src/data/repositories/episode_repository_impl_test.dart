import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_char/src/data/datasources/episode_local_data_source.dart';
import 'package:rick_and_morty_char/src/data/datasources/episode_remote_data_source.dart';
import 'package:rick_and_morty_char/src/data/models/character_response_dto.dart';
import 'package:rick_and_morty_char/src/data/models/episode_response_dto.dart';
import 'package:rick_and_morty_char/src/data/repositories/episode_repository_impl.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';

class MockEpisodeRemoteDataSource extends Mock implements EpisodeRemoteDataSource {}

class MockEpisodeLocalDataSource extends Mock implements EpisodeLocalDataSource {}

const transparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

void main() {
  setUpAll(() {
    registerFallbackValue(<int>[]);
    registerFallbackValue(<EpisodeCacheData>[]);
    registerFallbackValue(<CharacterCacheData>[]);
  });

  late MockEpisodeRemoteDataSource remote;
  late MockEpisodeLocalDataSource local;
  late EpisodeRepositoryImpl repository;

  setUp(() {
    remote = MockEpisodeRemoteDataSource();
    local = MockEpisodeLocalDataSource();
    repository = EpisodeRepositoryImpl(remote, local);
  });

  test('fetchEpisodesOverview computes cache status', () async {
    final episode = EpisodeResponseDto(
      id: 1,
      name: 'Pilot',
      airDate: 'December 2, 2013',
      episodeCode: 'S01E01',
      characterUrls: const [
        'https://rickandmortyapi.com/api/character/1',
        'https://rickandmortyapi.com/api/character/2',
      ],
    );

    when(() => remote.getAllEpisodes()).thenAnswer((_) async => [episode]);
    when(() => local.upsertEpisodes(any())).thenAnswer((_) async {});
    when(() => local.getCachedCharacterIds()).thenAnswer((_) async => {1});

    final result = await repository.fetchEpisodesOverview();

    expect(result.length, 1);
    expect(result.first.cacheStatus, EpisodeCacheStatus.partial);
    expect(result.first.cachedCount, 1);
  });

  test('getCachedEpisodesOverview returns empty when no cached episodes', () async {
    when(() => local.getEpisodes()).thenAnswer((_) async => <EpisodeCacheData>[]);

    final result = await repository.getCachedEpisodesOverview();

    expect(result, isEmpty);
    verifyNever(() => local.getCachedCharacterIds());
  });

  test('getCachedEpisodesOverview sorts and marks uncached episodes', () async {
    final cached = [
      EpisodeCacheData(
        episodeId: 2,
        episodeName: 'Two',
        episodeCode: 'S01E02',
        characterIds: const [3],
        cachedAt: DateTime(2026, 1, 1),
      ),
      EpisodeCacheData(
        episodeId: 1,
        episodeName: 'One',
        episodeCode: 'S01E01',
        characterIds: const [1, 2],
        cachedAt: DateTime(2026, 1, 1),
      ),
    ];

    when(() => local.getEpisodes()).thenAnswer((_) async => cached);
    when(() => local.getCachedCharacterIds()).thenAnswer((_) async => <int>{});

    final result = await repository.getCachedEpisodesOverview();

    expect(result.length, 2);
    expect(result.first.episode.id, 1);
    expect(result.first.cacheStatus, EpisodeCacheStatus.uncached);
  });

  test('getCachedEpisodeCharacters returns null when cache empty', () async {
    final episode = EpisodeSummary(
      id: 1,
      name: 'Pilot',
      episodeCode: 'S01E01',
      characterIds: const [1],
    );

    when(() => local.getCharactersByIds(any())).thenAnswer((_) async => <CharacterCacheData>[]);

    final result = await repository.getCachedEpisodeCharacters(episode);

    expect(result, isNull);
  });

  test('getCachedEpisodeCharacters sanitizes invalid bytes', () async {
    final episode = EpisodeSummary(
      id: 1,
      name: 'Pilot',
      episodeCode: 'S01E01',
      characterIds: const [1],
    );

    when(() => local.getCharactersByIds(any())).thenAnswer(
      (_) async => [
        CharacterCacheData(
          id: 1,
          name: 'Alpha',
          imageBytes: Uint8List.fromList([0, 1, 2]),
          cachedAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    final result = await repository.getCachedEpisodeCharacters(episode);

    expect(result, isNotNull);
    expect(result!.characters.first.imageBytes, isEmpty);
  });

  test('fetchEpisodeCharacters uses unique ids and skips invalid images', () async {
    final episode = EpisodeSummary(
      id: 1,
      name: 'Pilot',
      episodeCode: 'S01E01',
      characterIds: const [1, 1, 2],
    );

    when(() => local.getCharactersByIds(any())).thenAnswer((_) async => <CharacterCacheData>[]);
    when(() => remote.getCharactersByIds(any())).thenAnswer(
      (_) async => [
        CharacterResponseDto(id: 1, name: 'Alpha', image: 'url-1'),
        CharacterResponseDto(id: 2, name: 'Beta', image: 'url-2'),
      ],
    );
    when(() => remote.getImageBytes('url-1')).thenThrow(Exception('bad image'));
    when(() => remote.getImageBytes('url-2')).thenAnswer((_) async => Uint8List.fromList([0, 1]));

    final emissions = await repository.fetchEpisodeCharacters(episode).toList();

    expect(emissions.length, 1);
    final captured = verify(() => remote.getCharactersByIds(captureAny())).captured.single as List<int>;
    expect(captured.toSet().length, 2);
  });

  test('fetchEpisodeCharacters skips empty image urls', () async {
    final episode = EpisodeSummary(
      id: 1,
      name: 'Pilot',
      episodeCode: 'S01E01',
      characterIds: const [1],
    );

    when(() => local.getCharactersByIds(any())).thenAnswer((_) async => <CharacterCacheData>[]);
    when(() => remote.getCharactersByIds(any())).thenAnswer(
      (_) async => [
        CharacterResponseDto(id: 1, name: 'Alpha', image: ''),
      ],
    );

    final emissions = await repository.fetchEpisodeCharacters(episode).toList();

    expect(emissions.length, 1);
    verifyNever(() => remote.getImageBytes(any()));
  });

  test('fetchEpisodeCharacters streams incremental updates', () async {
    final episode = EpisodeSummary(id: 1, name: 'Pilot', episodeCode: 'S01E01', characterIds: const [1, 2]);

    when(() => local.getCharactersByIds(any())).thenAnswer(
      (_) async => [
        CharacterCacheData(
          id: 1,
          name: 'Alpha',
          imageBytes: Uint8List.fromList(transparentImage),
          cachedAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    when(() => remote.getCharactersByIds(any())).thenAnswer(
      (_) async => [
        CharacterResponseDto(id: 1, name: 'Alpha', image: 'url-1'),
        CharacterResponseDto(id: 2, name: 'Beta', image: 'url-2'),
      ],
    );

    when(() => remote.getImageBytes('url-2')).thenAnswer((_) async => Uint8List.fromList(transparentImage));
    when(() => local.upsertCharacters(any())).thenAnswer((_) async {});

    final emissions = await repository.fetchEpisodeCharacters(episode).toList();

    expect(emissions.length, 2);

    final firstById = {for (final character in emissions.first.characters) character.id: character};
    expect(firstById[1]!.imageBytes.isNotEmpty, true);
    expect(firstById[2]!.imageBytes.isEmpty, true);

    final lastById = {for (final character in emissions.last.characters) character.id: character};
    expect(lastById[2]!.imageBytes.isNotEmpty, true);
  });
}
