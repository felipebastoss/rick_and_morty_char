import 'package:bloc/bloc.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';
import 'package:rick_and_morty_char/src/domain/usecases/fetch_episodes_overview.dart';
import 'package:rick_and_morty_char/src/domain/usecases/get_cached_episodes_overview.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/cubit/episodes_state.dart';

class EpisodesCubit extends Cubit<EpisodesState> {
  EpisodesCubit(
    this._getCachedEpisodesOverview,
    this._fetchEpisodesOverview,
  ) : super(const EpisodesState());

  final GetCachedEpisodesOverview _getCachedEpisodesOverview;
  final FetchEpisodesOverview _fetchEpisodesOverview;

  Future<void> loadEpisodes() async {
    emit(
      state.copyWith(
        status: EpisodesStatus.loading,
        episodes: const <EpisodeOverview>[],
        message: null,
      ),
    );

    final cached = await _getCachedEpisodesOverview();
    if (cached.isNotEmpty) {
      emit(
        state.copyWith(
          status: EpisodesStatus.loading,
          episodes: cached,
          message: null,
        ),
      );
    }

    try {
      final fresh = await _fetchEpisodesOverview();
      emit(
        state.copyWith(
          status: EpisodesStatus.loaded,
          episodes: fresh,
          message: null,
        ),
      );
    } catch (_) {
      if (cached.isEmpty) {
        emit(
          state.copyWith(
            status: EpisodesStatus.error,
            message:
                'Unable to load episodes. Check your connection and try again.',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: EpisodesStatus.loaded,
            message: 'Unable to refresh. Showing cached data.',
          ),
        );
      }
    }
  }

  Future<void> refreshCacheStatus() async {
    final cached = await _getCachedEpisodesOverview();
    if (cached.isNotEmpty) {
      emit(
        state.copyWith(
          status: EpisodesStatus.loaded,
          episodes: cached,
          message: null,
        ),
      );
    }
  }
}
