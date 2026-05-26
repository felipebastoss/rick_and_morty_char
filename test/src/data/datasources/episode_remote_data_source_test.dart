import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_char/src/core/client/app_http_client.dart';
import 'package:rick_and_morty_char/src/data/datasources/episode_remote_data_source.dart';

class MockAppHttpClient extends Mock implements AppHttpClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  late MockAppHttpClient client;
  late EpisodeRemoteDataSource dataSource;

  setUp(() {
    client = MockAppHttpClient();
    dataSource = EpisodeRemoteDataSource(client);
  });

  test('getAllEpisodes aggregates paginated responses', () async {
    final page1 = {
      'info': {'next': 'https://rickandmortyapi.com/api/episode?page=2'},
      'results': [
        {'id': 1, 'name': 'Pilot', 'air_date': 'December 2, 2013', 'episode': 'S01E01', 'characters': <String>[]},
      ],
    };
    final page2 = {
      'info': {'next': null},
      'results': [
        {
          'id': 2,
          'name': 'Lawnmower Dog',
          'air_date': 'December 9, 2013',
          'episode': 'S01E02',
          'characters': <String>[],
        },
      ],
    };

    when(() => client.getJsonMap(Uri.parse('https://rickandmortyapi.com/api/episode'))).thenAnswer((_) async => page1);
    when(
      () => client.getJsonMap(Uri.parse('https://rickandmortyapi.com/api/episode?page=2')),
    ).thenAnswer((_) async => page2);

    final result = await dataSource.getAllEpisodes();

    expect(result.length, 2);
    expect(result.first.name, 'Pilot');
    expect(result.last.episodeCode, 'S01E02');
  });

  test('getEpisode maps response', () async {
    final payload = {
      'id': 28,
      'name': 'The Ricklantis Mixup',
      'air_date': 'September 10, 2017',
      'episode': 'S03E07',
      'characters': <String>[],
    };

    when(
      () => client.getJsonMap(Uri.parse('https://rickandmortyapi.com/api/episode/28')),
    ).thenAnswer((_) async => payload);

    final result = await dataSource.getEpisode(28);

    expect(result.id, 28);
    expect(result.episodeCode, 'S03E07');
  });

  test('getCharactersByIds parses list response', () async {
    final payload = [
      {'id': 1, 'name': 'Rick Sanchez', 'image': 'img-1'},
      {'id': 2, 'name': 'Morty Smith', 'image': 'img-2'},
    ];

    when(
      () => client.getJson(Uri.parse('https://rickandmortyapi.com/api/character/1,2')),
    ).thenAnswer((_) async => payload);

    final result = await dataSource.getCharactersByIds([1, 2]);

    expect(result.length, 2);
    expect(result.first.name, 'Rick Sanchez');
  });

  test('getCharactersByIds parses single response', () async {
    final payload = {'id': 1, 'name': 'Rick Sanchez', 'image': 'img-1'};

    when(
      () => client.getJson(Uri.parse('https://rickandmortyapi.com/api/character/1')),
    ).thenAnswer((_) async => payload);

    final result = await dataSource.getCharactersByIds([1]);

    expect(result.length, 1);
    expect(result.first.id, 1);
  });

  test('getImageBytes delegates to client', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);
    when(
      () => client.getBytes(Uri.parse('https://rickandmortyapi.com/api/character/avatar/1.jpeg')),
    ).thenAnswer((_) async => bytes);

    final result = await dataSource.getImageBytes('https://rickandmortyapi.com/api/character/avatar/1.jpeg');

    expect(result, bytes);
  });
}
