import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';

enum EpisodesStatus { initial, loading, loaded, error }

class EpisodesState {
  const EpisodesState({
    this.status = EpisodesStatus.initial,
    this.episodes = const <EpisodeOverview>[],
    this.message,
  });

  final EpisodesStatus status;
  final List<EpisodeOverview> episodes;
  final String? message;

  static const Object _unset = Object();

  EpisodesState copyWith({
    EpisodesStatus? status,
    List<EpisodeOverview>? episodes,
    Object? message = _unset,
  }) {
    return EpisodesState(
      status: status ?? this.status,
      episodes: episodes ?? this.episodes,
      message: message == _unset ? this.message : message as String?,
    );
  }
}
