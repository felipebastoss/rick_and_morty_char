import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class EpisodeRecords extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get episodeCode => text()();
  TextColumn get characterIdsJson => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CharacterRecords extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  BlobColumn get imageBytes => blob()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [EpisodeRecords, CharacterRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'rick_and_morty'));
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) => m.createAll(),
      onUpgrade: (m, from, to) async {
        if (from < 3) {
          await m.drop(characterRecords);
          await m.drop(episodeRecords);
          await m.createAll();
        }
      },
    );
  }

  Future<List<EpisodeRecord>> getEpisodes() {
    return select(episodeRecords).get();
  }

  Future<void> upsertEpisodes(List<EpisodeRecordsCompanion> data) {
    if (data.isEmpty) {
      return Future.value();
    }

    return batch((batch) {
      batch.insertAllOnConflictUpdate(episodeRecords, data);
    });
  }

  Future<List<CharacterRecord>> getCharactersByIds(List<int> ids) {
    if (ids.isEmpty) {
      return Future.value(<CharacterRecord>[]);
    }

    return (select(characterRecords)..where((table) => table.id.isIn(ids)))
        .get();
  }

  Future<Set<int>> getAllCharacterIds() async {
    final records = await select(characterRecords).get();
    return records.map((record) => record.id).toSet();
  }

  Future<void> upsertCharacters(List<CharacterRecordsCompanion> data) {
    if (data.isEmpty) {
      return Future.value();
    }

    return batch((batch) {
      batch.insertAllOnConflictUpdate(characterRecords, data);
    });
  }
}
