class EpisodeResponseDto {
  EpisodeResponseDto({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episodeCode,
    required this.characterUrls,
  });

  final int id;
  final String name;
  final String airDate;
  final String episodeCode;
  final List<String> characterUrls;

  factory EpisodeResponseDto.fromJson(Map<String, dynamic> json) {
    final characters = json['characters'] as List<dynamic>? ?? <dynamic>[];
    return EpisodeResponseDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      airDate: json['air_date'] as String? ?? '',
      episodeCode: json['episode'] as String? ?? '',
      characterUrls: characters.map((entry) => entry.toString()).toList(),
    );
  }
}
