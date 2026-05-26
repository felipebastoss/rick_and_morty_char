import 'dart:typed_data';

import 'package:rick_and_morty_char/src/core/client/app_http_client.dart';
import 'package:rick_and_morty_char/src/data/models/character_response_dto.dart';
import 'package:rick_and_morty_char/src/data/models/episode_response_dto.dart';
import 'package:rick_and_morty_char/src/data/models/episodes_page_response_dto.dart';

class EpisodeRemoteDataSource {
  EpisodeRemoteDataSource(this._client, {this.baseUrl = 'https://rickandmortyapi.com/api'});

  final AppHttpClient _client;
  final String baseUrl;

  Future<List<EpisodeResponseDto>> getAllEpisodes() async {
    final episodes = <EpisodeResponseDto>[];
    String? nextUrl = '$baseUrl/episode';

    while (nextUrl != null) {
      final payload = await _client.getJsonMap(Uri.parse(nextUrl));
      final page = EpisodesPageResponseDto.fromJson(payload);
      episodes.addAll(page.results);
      nextUrl = page.next;
    }

    return episodes;
  }

  Future<EpisodeResponseDto> getEpisode(int episodeId) async {
    final uri = Uri.parse('$baseUrl/episode/$episodeId');
    final payload = await _client.getJsonMap(uri);
    return EpisodeResponseDto.fromJson(payload);
  }

  Future<List<CharacterResponseDto>> getCharactersByIds(List<int> ids) async {
    if (ids.isEmpty) {
      return <CharacterResponseDto>[];
    }

    const chunkSize = 20;
    final chunks = <List<int>>[];

    for (var i = 0; i < ids.length; i += chunkSize) {
      final end = (i + chunkSize < ids.length) ? i + chunkSize : ids.length;
      chunks.add(ids.sublist(i, end));
    }

    final results = await Future.wait(chunks.map(_fetchCharacterChunk));

    return results.expand((chunk) => chunk).toList();
  }

  Future<List<CharacterResponseDto>> _fetchCharacterChunk(List<int> ids) async {
    final uri = Uri.parse('$baseUrl/character/${ids.join(',')}');
    final payload = await _client.getJson(uri);

    if (payload is List) {
      return payload.map((entry) => CharacterResponseDto.fromJson(entry as Map<String, dynamic>)).toList();
    }

    if (payload is Map<String, dynamic>) {
      return <CharacterResponseDto>[CharacterResponseDto.fromJson(payload)];
    }

    throw const FormatException('Unexpected character response.');
  }

  Future<Uint8List> getImageBytes(String url) {
    if (url.isEmpty) {
      return Future.value(Uint8List(0));
    }

    return _client.getBytes(Uri.parse(url));
  }
}
