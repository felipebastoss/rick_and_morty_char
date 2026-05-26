import 'package:rick_and_morty_char/src/domain/entities/episode_characters.dart';

enum EpisodeDetailsStatus { initial, loading, loaded, error }

class EpisodeDetailsState {
  const EpisodeDetailsState({
    this.status = EpisodeDetailsStatus.initial,
    this.data,
    this.message,
    this.isFromCache = false,
  });

  final EpisodeDetailsStatus status;
  final EpisodeCharacters? data;
  final String? message;
  final bool isFromCache;

  static const Object _unset = Object();

  EpisodeDetailsState copyWith({
    EpisodeDetailsStatus? status,
    EpisodeCharacters? data,
    Object? message = _unset,
    bool? isFromCache,
  }) {
    return EpisodeDetailsState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message == _unset ? this.message : message as String?,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}
