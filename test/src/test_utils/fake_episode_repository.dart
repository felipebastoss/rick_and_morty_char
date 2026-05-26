import 'package:rick_and_morty_char/src/domain/entities/episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/domain/repositories/episode_repository.dart';

class FakeEpisodeRepository implements EpisodeRepository {
  FakeEpisodeRepository({
    this.cachedEpisodes = const <EpisodeOverview>[],
    this.freshEpisodes = const <EpisodeOverview>[],
    this.cachedCharacters,
    Stream<EpisodeCharacters>? characterStream,
  }) : _characterStream = characterStream ?? const Stream<EpisodeCharacters>.empty();

  final List<EpisodeOverview> cachedEpisodes;
  final List<EpisodeOverview> freshEpisodes;
  final EpisodeCharacters? cachedCharacters;
  final Stream<EpisodeCharacters> _characterStream;

  @override
  Future<List<EpisodeOverview>> getCachedEpisodesOverview() async {
    return cachedEpisodes;
  }

  @override
  Future<List<EpisodeOverview>> fetchEpisodesOverview() async {
    return freshEpisodes;
  }

  @override
  Future<EpisodeCharacters?> getCachedEpisodeCharacters(EpisodeSummary episode) async {
    return cachedCharacters;
  }

  @override
  Stream<EpisodeCharacters> fetchEpisodeCharacters(EpisodeSummary episode) {
    return _characterStream;
  }
}
