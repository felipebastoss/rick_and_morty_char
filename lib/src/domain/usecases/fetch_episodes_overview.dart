import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';
import 'package:rick_and_morty_char/src/domain/repositories/episode_repository.dart';

class FetchEpisodesOverview {
  FetchEpisodesOverview(this._repository);

  final EpisodeRepository _repository;

  Future<List<EpisodeOverview>> call() {
    return _repository.fetchEpisodesOverview();
  }
}
