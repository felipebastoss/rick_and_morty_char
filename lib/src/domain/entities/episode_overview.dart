import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';

enum EpisodeCacheStatus { uncached, partial, full }

class EpisodeOverview {
  const EpisodeOverview({
    required this.episode,
    required this.cacheStatus,
    required this.cachedCount,
    required this.totalCount,
  });

  final EpisodeSummary episode;
  final EpisodeCacheStatus cacheStatus;
  final int cachedCount;
  final int totalCount;
}
