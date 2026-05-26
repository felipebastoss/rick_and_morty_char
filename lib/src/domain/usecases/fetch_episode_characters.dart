import 'package:rick_and_morty_char/src/domain/entities/episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/domain/repositories/episode_repository.dart';

class FetchEpisodeCharacters {
  FetchEpisodeCharacters(this._repository);

  final EpisodeRepository _repository;

  Stream<EpisodeCharacters> call(EpisodeSummary episode) {
    return _repository.fetchEpisodeCharacters(episode);
  }
}
