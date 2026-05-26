import 'package:rick_and_morty_char/src/domain/entities/episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';

abstract class EpisodeRepository {
  Future<List<EpisodeOverview>> getCachedEpisodesOverview();
  Future<List<EpisodeOverview>> fetchEpisodesOverview();
  Future<EpisodeCharacters?> getCachedEpisodeCharacters(EpisodeSummary episode);
  Stream<EpisodeCharacters> fetchEpisodeCharacters(EpisodeSummary episode);
}
