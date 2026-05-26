import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/domain/usecases/fetch_episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/usecases/get_cached_episode_characters.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_state.dart';

class EpisodeDetailsCubit extends Cubit<EpisodeDetailsState> {
  EpisodeDetailsCubit(this._getCachedEpisodeCharacters, this._fetchEpisodeCharacters)
    : super(const EpisodeDetailsState());

  final GetCachedEpisodeCharacters _getCachedEpisodeCharacters;
  final FetchEpisodeCharacters _fetchEpisodeCharacters;
  StreamSubscription? _subscription;

  Future<void> loadEpisode(EpisodeSummary episode) async {
    await _subscription?.cancel();

    emit(state.copyWith(status: EpisodeDetailsStatus.loading, data: null, message: null, isFromCache: false));

    final cached = await _getCachedEpisodeCharacters(episode);
    if (cached != null) {
      emit(state.copyWith(status: EpisodeDetailsStatus.loading, data: cached, isFromCache: true, message: null));
    }

    var hasStreamData = false;

    _subscription = _fetchEpisodeCharacters(episode).listen(
      (fresh) {
        hasStreamData = true;
        emit(state.copyWith(status: EpisodeDetailsStatus.loading, data: fresh, isFromCache: false, message: null));
      },
      onError: (_) {
        if (cached == null && !hasStreamData) {
          emit(
            state.copyWith(
              status: EpisodeDetailsStatus.error,
              message: 'Unable to load episode. Check your connection and try again.',
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: EpisodeDetailsStatus.loaded,
            message: 'Unable to refresh. Showing cached data.',
            isFromCache: cached != null && !hasStreamData,
          ),
        );
      },
      onDone: () {
        if (isClosed) {
          return;
        }

        emit(state.copyWith(status: EpisodeDetailsStatus.loaded));
      },
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
