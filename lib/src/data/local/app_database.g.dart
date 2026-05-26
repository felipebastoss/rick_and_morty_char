// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EpisodeRecordsTable extends EpisodeRecords
    with TableInfo<$EpisodeRecordsTable, EpisodeRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodeRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeCodeMeta = const VerificationMeta(
    'episodeCode',
  );
  @override
  late final GeneratedColumn<String> episodeCode = GeneratedColumn<String>(
    'episode_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _characterIdsJsonMeta = const VerificationMeta(
    'characterIdsJson',
  );
  @override
  late final GeneratedColumn<String> characterIdsJson = GeneratedColumn<String>(
    'character_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    episodeCode,
    characterIdsJson,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episode_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<EpisodeRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('episode_code')) {
      context.handle(
        _episodeCodeMeta,
        episodeCode.isAcceptableOrUnknown(
          data['episode_code']!,
          _episodeCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeCodeMeta);
    }
    if (data.containsKey('character_ids_json')) {
      context.handle(
        _characterIdsJsonMeta,
        characterIdsJson.isAcceptableOrUnknown(
          data['character_ids_json']!,
          _characterIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdsJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EpisodeRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EpisodeRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      episodeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_code'],
      )!,
      characterIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_ids_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $EpisodeRecordsTable createAlias(String alias) {
    return $EpisodeRecordsTable(attachedDatabase, alias);
  }
}

class EpisodeRecord extends DataClass implements Insertable<EpisodeRecord> {
  final int id;
  final String name;
  final String episodeCode;
  final String characterIdsJson;
  final DateTime cachedAt;
  const EpisodeRecord({
    required this.id,
    required this.name,
    required this.episodeCode,
    required this.characterIdsJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['episode_code'] = Variable<String>(episodeCode);
    map['character_ids_json'] = Variable<String>(characterIdsJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  EpisodeRecordsCompanion toCompanion(bool nullToAbsent) {
    return EpisodeRecordsCompanion(
      id: Value(id),
      name: Value(name),
      episodeCode: Value(episodeCode),
      characterIdsJson: Value(characterIdsJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory EpisodeRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EpisodeRecord(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      episodeCode: serializer.fromJson<String>(json['episodeCode']),
      characterIdsJson: serializer.fromJson<String>(json['characterIdsJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'episodeCode': serializer.toJson<String>(episodeCode),
      'characterIdsJson': serializer.toJson<String>(characterIdsJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  EpisodeRecord copyWith({
    int? id,
    String? name,
    String? episodeCode,
    String? characterIdsJson,
    DateTime? cachedAt,
  }) => EpisodeRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    episodeCode: episodeCode ?? this.episodeCode,
    characterIdsJson: characterIdsJson ?? this.characterIdsJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  EpisodeRecord copyWithCompanion(EpisodeRecordsCompanion data) {
    return EpisodeRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      episodeCode: data.episodeCode.present
          ? data.episodeCode.value
          : this.episodeCode,
      characterIdsJson: data.characterIdsJson.present
          ? data.characterIdsJson.value
          : this.characterIdsJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('episodeCode: $episodeCode, ')
          ..write('characterIdsJson: $characterIdsJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, episodeCode, characterIdsJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EpisodeRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.episodeCode == this.episodeCode &&
          other.characterIdsJson == this.characterIdsJson &&
          other.cachedAt == this.cachedAt);
}

class EpisodeRecordsCompanion extends UpdateCompanion<EpisodeRecord> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> episodeCode;
  final Value<String> characterIdsJson;
  final Value<DateTime> cachedAt;
  const EpisodeRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.episodeCode = const Value.absent(),
    this.characterIdsJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  EpisodeRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String episodeCode,
    required String characterIdsJson,
    required DateTime cachedAt,
  }) : name = Value(name),
       episodeCode = Value(episodeCode),
       characterIdsJson = Value(characterIdsJson),
       cachedAt = Value(cachedAt);
  static Insertable<EpisodeRecord> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? episodeCode,
    Expression<String>? characterIdsJson,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (episodeCode != null) 'episode_code': episodeCode,
      if (characterIdsJson != null) 'character_ids_json': characterIdsJson,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  EpisodeRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? episodeCode,
    Value<String>? characterIdsJson,
    Value<DateTime>? cachedAt,
  }) {
    return EpisodeRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      episodeCode: episodeCode ?? this.episodeCode,
      characterIdsJson: characterIdsJson ?? this.characterIdsJson,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (episodeCode.present) {
      map['episode_code'] = Variable<String>(episodeCode.value);
    }
    if (characterIdsJson.present) {
      map['character_ids_json'] = Variable<String>(characterIdsJson.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('episodeCode: $episodeCode, ')
          ..write('characterIdsJson: $characterIdsJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $CharacterRecordsTable extends CharacterRecords
    with TableInfo<$CharacterRecordsTable, CharacterRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageBytesMeta = const VerificationMeta(
    'imageBytes',
  );
  @override
  late final GeneratedColumn<Uint8List> imageBytes = GeneratedColumn<Uint8List>(
    'image_bytes',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, imageBytes, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_bytes')) {
      context.handle(
        _imageBytesMeta,
        imageBytes.isAcceptableOrUnknown(data['image_bytes']!, _imageBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_imageBytesMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imageBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}image_bytes'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CharacterRecordsTable createAlias(String alias) {
    return $CharacterRecordsTable(attachedDatabase, alias);
  }
}

class CharacterRecord extends DataClass implements Insertable<CharacterRecord> {
  final int id;
  final String name;
  final Uint8List imageBytes;
  final DateTime cachedAt;
  const CharacterRecord({
    required this.id,
    required this.name,
    required this.imageBytes,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['image_bytes'] = Variable<Uint8List>(imageBytes);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CharacterRecordsCompanion toCompanion(bool nullToAbsent) {
    return CharacterRecordsCompanion(
      id: Value(id),
      name: Value(name),
      imageBytes: Value(imageBytes),
      cachedAt: Value(cachedAt),
    );
  }

  factory CharacterRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterRecord(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageBytes: serializer.fromJson<Uint8List>(json['imageBytes']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imageBytes': serializer.toJson<Uint8List>(imageBytes),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CharacterRecord copyWith({
    int? id,
    String? name,
    Uint8List? imageBytes,
    DateTime? cachedAt,
  }) => CharacterRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    imageBytes: imageBytes ?? this.imageBytes,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CharacterRecord copyWithCompanion(CharacterRecordsCompanion data) {
    return CharacterRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imageBytes: data.imageBytes.present
          ? data.imageBytes.value
          : this.imageBytes,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, $driftBlobEquality.hash(imageBytes), cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterRecord &&
          other.id == this.id &&
          other.name == this.name &&
          $driftBlobEquality.equals(other.imageBytes, this.imageBytes) &&
          other.cachedAt == this.cachedAt);
}

class CharacterRecordsCompanion extends UpdateCompanion<CharacterRecord> {
  final Value<int> id;
  final Value<String> name;
  final Value<Uint8List> imageBytes;
  final Value<DateTime> cachedAt;
  const CharacterRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageBytes = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  CharacterRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required Uint8List imageBytes,
    required DateTime cachedAt,
  }) : name = Value(name),
       imageBytes = Value(imageBytes),
       cachedAt = Value(cachedAt);
  static Insertable<CharacterRecord> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<Uint8List>? imageBytes,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageBytes != null) 'image_bytes': imageBytes,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  CharacterRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<Uint8List>? imageBytes,
    Value<DateTime>? cachedAt,
  }) {
    return CharacterRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageBytes: imageBytes ?? this.imageBytes,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageBytes.present) {
      map['image_bytes'] = Variable<Uint8List>(imageBytes.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EpisodeRecordsTable episodeRecords = $EpisodeRecordsTable(this);
  late final $CharacterRecordsTable characterRecords = $CharacterRecordsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    episodeRecords,
    characterRecords,
  ];
}

typedef $$EpisodeRecordsTableCreateCompanionBuilder =
    EpisodeRecordsCompanion Function({
      Value<int> id,
      required String name,
      required String episodeCode,
      required String characterIdsJson,
      required DateTime cachedAt,
    });
typedef $$EpisodeRecordsTableUpdateCompanionBuilder =
    EpisodeRecordsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> episodeCode,
      Value<String> characterIdsJson,
      Value<DateTime> cachedAt,
    });

class $$EpisodeRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodeRecordsTable> {
  $$EpisodeRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeCode => $composableBuilder(
    column: $table.episodeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get characterIdsJson => $composableBuilder(
    column: $table.characterIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EpisodeRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodeRecordsTable> {
  $$EpisodeRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeCode => $composableBuilder(
    column: $table.episodeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get characterIdsJson => $composableBuilder(
    column: $table.characterIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EpisodeRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodeRecordsTable> {
  $$EpisodeRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get episodeCode => $composableBuilder(
    column: $table.episodeCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get characterIdsJson => $composableBuilder(
    column: $table.characterIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$EpisodeRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EpisodeRecordsTable,
          EpisodeRecord,
          $$EpisodeRecordsTableFilterComposer,
          $$EpisodeRecordsTableOrderingComposer,
          $$EpisodeRecordsTableAnnotationComposer,
          $$EpisodeRecordsTableCreateCompanionBuilder,
          $$EpisodeRecordsTableUpdateCompanionBuilder,
          (
            EpisodeRecord,
            BaseReferences<_$AppDatabase, $EpisodeRecordsTable, EpisodeRecord>,
          ),
          EpisodeRecord,
          PrefetchHooks Function()
        > {
  $$EpisodeRecordsTableTableManager(
    _$AppDatabase db,
    $EpisodeRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodeRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodeRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodeRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> episodeCode = const Value.absent(),
                Value<String> characterIdsJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => EpisodeRecordsCompanion(
                id: id,
                name: name,
                episodeCode: episodeCode,
                characterIdsJson: characterIdsJson,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String episodeCode,
                required String characterIdsJson,
                required DateTime cachedAt,
              }) => EpisodeRecordsCompanion.insert(
                id: id,
                name: name,
                episodeCode: episodeCode,
                characterIdsJson: characterIdsJson,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EpisodeRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EpisodeRecordsTable,
      EpisodeRecord,
      $$EpisodeRecordsTableFilterComposer,
      $$EpisodeRecordsTableOrderingComposer,
      $$EpisodeRecordsTableAnnotationComposer,
      $$EpisodeRecordsTableCreateCompanionBuilder,
      $$EpisodeRecordsTableUpdateCompanionBuilder,
      (
        EpisodeRecord,
        BaseReferences<_$AppDatabase, $EpisodeRecordsTable, EpisodeRecord>,
      ),
      EpisodeRecord,
      PrefetchHooks Function()
    >;
typedef $$CharacterRecordsTableCreateCompanionBuilder =
    CharacterRecordsCompanion Function({
      Value<int> id,
      required String name,
      required Uint8List imageBytes,
      required DateTime cachedAt,
    });
typedef $$CharacterRecordsTableUpdateCompanionBuilder =
    CharacterRecordsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<Uint8List> imageBytes,
      Value<DateTime> cachedAt,
    });

class $$CharacterRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterRecordsTable> {
  $$CharacterRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CharacterRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterRecordsTable> {
  $$CharacterRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CharacterRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterRecordsTable> {
  $$CharacterRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<Uint8List> get imageBytes => $composableBuilder(
    column: $table.imageBytes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CharacterRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterRecordsTable,
          CharacterRecord,
          $$CharacterRecordsTableFilterComposer,
          $$CharacterRecordsTableOrderingComposer,
          $$CharacterRecordsTableAnnotationComposer,
          $$CharacterRecordsTableCreateCompanionBuilder,
          $$CharacterRecordsTableUpdateCompanionBuilder,
          (
            CharacterRecord,
            BaseReferences<
              _$AppDatabase,
              $CharacterRecordsTable,
              CharacterRecord
            >,
          ),
          CharacterRecord,
          PrefetchHooks Function()
        > {
  $$CharacterRecordsTableTableManager(
    _$AppDatabase db,
    $CharacterRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<Uint8List> imageBytes = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => CharacterRecordsCompanion(
                id: id,
                name: name,
                imageBytes: imageBytes,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required Uint8List imageBytes,
                required DateTime cachedAt,
              }) => CharacterRecordsCompanion.insert(
                id: id,
                name: name,
                imageBytes: imageBytes,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CharacterRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterRecordsTable,
      CharacterRecord,
      $$CharacterRecordsTableFilterComposer,
      $$CharacterRecordsTableOrderingComposer,
      $$CharacterRecordsTableAnnotationComposer,
      $$CharacterRecordsTableCreateCompanionBuilder,
      $$CharacterRecordsTableUpdateCompanionBuilder,
      (
        CharacterRecord,
        BaseReferences<_$AppDatabase, $CharacterRecordsTable, CharacterRecord>,
      ),
      CharacterRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EpisodeRecordsTableTableManager get episodeRecords =>
      $$EpisodeRecordsTableTableManager(_db, _db.episodeRecords);
  $$CharacterRecordsTableTableManager get characterRecords =>
      $$CharacterRecordsTableTableManager(_db, _db.characterRecords);
}
