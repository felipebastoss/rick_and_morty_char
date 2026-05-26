import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_char/src/data/local/app_database.dart';

AppDatabase openTestDatabase() => AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('episodes', () {
    test('getEpisodes returns empty list when no records', () async {
      final result = await db.getEpisodes();
      expect(result, isEmpty);
    });

    test('upsertEpisodes with empty list completes without error', () async {
      await expectLater(db.upsertEpisodes([]), completes);
    });

    test('upsertEpisodes inserts records and getEpisodes returns them', () async {
      final companion = EpisodeRecordsCompanion.insert(
        id: const Value(1),
        name: 'Pilot',
        episodeCode: 'S01E01',
        characterIdsJson: '[1,2,3]',
        cachedAt: DateTime(2026, 1, 1),
      );

      await db.upsertEpisodes([companion]);

      final result = await db.getEpisodes();
      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.name, 'Pilot');
      expect(result.first.episodeCode, 'S01E01');
      expect(result.first.characterIdsJson, '[1,2,3]');
    });

    test('upsertEpisodes updates existing record on conflict', () async {
      final original = EpisodeRecordsCompanion.insert(
        id: const Value(1),
        name: 'Pilot',
        episodeCode: 'S01E01',
        characterIdsJson: '[1]',
        cachedAt: DateTime(2026, 1, 1),
      );
      final updated = EpisodeRecordsCompanion.insert(
        id: const Value(1),
        name: 'Pilot Updated',
        episodeCode: 'S01E01',
        characterIdsJson: '[1,2]',
        cachedAt: DateTime(2026, 2, 1),
      );

      await db.upsertEpisodes([original]);
      await db.upsertEpisodes([updated]);

      final result = await db.getEpisodes();
      expect(result.length, 1);
      expect(result.first.name, 'Pilot Updated');
      expect(result.first.characterIdsJson, '[1,2]');
    });
  });

  group('characters', () {
    test('getCharactersByIds returns empty list for empty ids', () async {
      final result = await db.getCharactersByIds([]);
      expect(result, isEmpty);
    });

    test('getAllCharacterIds returns empty set when no records', () async {
      final result = await db.getAllCharacterIds();
      expect(result, isEmpty);
    });

    test('upsertCharacters with empty list completes without error', () async {
      await expectLater(db.upsertCharacters([]), completes);
    });

    test('upsertCharacters inserts records and getAllCharacterIds returns their ids', () async {
      final companion = CharacterRecordsCompanion.insert(
        id: const Value(1),
        name: 'Rick Sanchez',
        imageBytes: Uint8List.fromList([1, 2, 3]),
        cachedAt: DateTime(2026, 1, 1),
      );

      await db.upsertCharacters([companion]);

      final ids = await db.getAllCharacterIds();
      expect(ids, {1});
    });

    test('getCharactersByIds returns only requested characters', () async {
      final rick = CharacterRecordsCompanion.insert(
        id: const Value(1),
        name: 'Rick Sanchez',
        imageBytes: Uint8List.fromList([1]),
        cachedAt: DateTime(2026, 1, 1),
      );
      final morty = CharacterRecordsCompanion.insert(
        id: const Value(2),
        name: 'Morty Smith',
        imageBytes: Uint8List.fromList([2]),
        cachedAt: DateTime(2026, 1, 1),
      );

      await db.upsertCharacters([rick, morty]);

      final result = await db.getCharactersByIds([1]);
      expect(result.length, 1);
      expect(result.first.name, 'Rick Sanchez');
    });

    test('upsertCharacters updates existing record on conflict', () async {
      final original = CharacterRecordsCompanion.insert(
        id: const Value(1),
        name: 'Rick',
        imageBytes: Uint8List(0),
        cachedAt: DateTime(2026, 1, 1),
      );
      final updated = CharacterRecordsCompanion.insert(
        id: const Value(1),
        name: 'Rick Sanchez',
        imageBytes: Uint8List.fromList([9]),
        cachedAt: DateTime(2026, 2, 1),
      );

      await db.upsertCharacters([original]);
      await db.upsertCharacters([updated]);

      final result = await db.getCharactersByIds([1]);
      expect(result.first.name, 'Rick Sanchez');
      expect(result.first.imageBytes, [9]);
    });
  });
}
