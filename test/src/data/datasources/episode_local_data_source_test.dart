import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_char/src/data/datasources/episode_local_data_source.dart';
import 'package:rick_and_morty_char/src/data/local/app_database.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUpAll(() {
    registerFallbackValue(<int>[]);
    registerFallbackValue(<EpisodeRecordsCompanion>[]);
    registerFallbackValue(<CharacterRecordsCompanion>[]);
  });

  late MockAppDatabase database;
  late EpisodeLocalDataSource dataSource;

  setUp(() {
    database = MockAppDatabase();
    dataSource = EpisodeLocalDataSource(database);
  });

  test('getEpisodes decodes character ids', () async {
    final record = EpisodeRecord(
      id: 1,
      name: 'Pilot',
      episodeCode: 'S01E01',
      characterIdsJson: '[1,2,3]',
      cachedAt: DateTime(2026, 1, 1),
    );

    when(() => database.getEpisodes()).thenAnswer((_) async => [record]);

    final result = await dataSource.getEpisodes();

    expect(result.length, 1);
    expect(result.first.characterIds, [1, 2, 3]);
  });

  test('getCharactersByIds maps records', () async {
    final record = CharacterRecord(
      id: 1,
      name: 'Rick Sanchez',
      imageBytes: Uint8List.fromList([1, 2]),
      cachedAt: DateTime(2026, 1, 1),
    );

    when(() => database.getCharactersByIds(any())).thenAnswer((_) async => [record]);

    final result = await dataSource.getCharactersByIds([1]);

    expect(result.length, 1);
    expect(result.first.imageBytes, record.imageBytes);
    verify(() => database.getCharactersByIds([1])).called(1);
  });

  test('upsertEpisodes forwards mapped companions', () async {
    when(() => database.upsertEpisodes(any())).thenAnswer((_) async {});

    await dataSource.upsertEpisodes([
      EpisodeCacheData(
        episodeId: 1,
        episodeName: 'Pilot',
        episodeCode: 'S01E01',
        characterIds: const [1, 2],
        cachedAt: DateTime(2026, 1, 1),
      ),
    ]);

    final captured =
        verify(() => database.upsertEpisodes(captureAny())).captured.single as List<EpisodeRecordsCompanion>;
    expect(captured.length, 1);
    expect(captured.first.name.value, 'Pilot');
    expect(captured.first.characterIdsJson.value, '[1,2]');
  });

  test('upsertCharacters forwards mapped companions', () async {
    when(() => database.upsertCharacters(any())).thenAnswer((_) async {});

    await dataSource.upsertCharacters([
      CharacterCacheData(
        id: 1,
        name: 'Rick Sanchez',
        imageBytes: Uint8List.fromList([9, 9]),
        cachedAt: DateTime(2026, 1, 1),
      ),
    ]);

    final captured =
        verify(() => database.upsertCharacters(captureAny())).captured.single as List<CharacterRecordsCompanion>;
    expect(captured.length, 1);
    expect(captured.first.name.value, 'Rick Sanchez');
  });
}
