import 'package:rick_and_morty_char/src/domain/entities/episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/domain/repositories/episode_repository.dart';

class GetCachedEpisodeCharacters {
  GetCachedEpisodeCharacters(this._repository);

  final EpisodeRepository _repository;

  Future<EpisodeCharacters?> call(EpisodeSummary episode) {
    return _repository.getCachedEpisodeCharacters(episode);
  }
}
