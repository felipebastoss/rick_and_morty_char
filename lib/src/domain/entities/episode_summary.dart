class EpisodeSummary {
  const EpisodeSummary({required this.id, required this.name, required this.episodeCode, required this.characterIds});

  final int id;
  final String name;
  final String episodeCode;
  final List<int> characterIds;
}
