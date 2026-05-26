import 'package:rick_and_morty_char/src/data/models/episode_response_dto.dart';

class EpisodesPageResponseDto {
  EpisodesPageResponseDto({
    required this.next,
    required this.results,
  });

  final String? next;
  final List<EpisodeResponseDto> results;

  factory EpisodesPageResponseDto.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List<dynamic>? ?? <dynamic>[];
    return EpisodesPageResponseDto(
      next: (json['info'] as Map<String, dynamic>?)?['next'] as String?,
      results: resultsJson
          .map((entry) => EpisodeResponseDto.fromJson(entry as Map<String, dynamic>))
          .toList(),
    );
  }
}
