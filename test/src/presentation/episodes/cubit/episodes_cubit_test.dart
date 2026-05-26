import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/domain/usecases/fetch_episodes_overview.dart';
import 'package:rick_and_morty_char/src/domain/usecases/get_cached_episodes_overview.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/cubit/episodes_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/cubit/episodes_state.dart';

import '../../../test_utils/fake_episode_repository.dart';

class ThrowingEpisodeRepository extends FakeEpisodeRepository {
  ThrowingEpisodeRepository({super.cachedEpisodes = const <EpisodeOverview>[]});

  @override
  Future<List<EpisodeOverview>> fetchEpisodesOverview() async {
    throw Exception('network');
  }
}

void main() {
  test('emits cached then fresh episodes', () async {
    final cachedEpisode = EpisodeOverview(
      episode: EpisodeSummary(id: 1, name: 'Pilot', episodeCode: 'S01E01', characterIds: const [1, 2]),
      cacheStatus: EpisodeCacheStatus.partial,
      cachedCount: 1,
      totalCount: 2,
    );

    final freshEpisode = EpisodeOverview(
      episode: EpisodeSummary(id: 1, name: 'Pilot', episodeCode: 'S01E01', characterIds: const [1, 2]),
      cacheStatus: EpisodeCacheStatus.full,
      cachedCount: 2,
      totalCount: 2,
    );

    final repository = FakeEpisodeRepository(cachedEpisodes: [cachedEpisode], freshEpisodes: [freshEpisode]);

    final cubit = EpisodesCubit(GetCachedEpisodesOverview(repository), FetchEpisodesOverview(repository));

    final states = <EpisodesState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.loadEpisodes();
    await Future<void>.delayed(Duration.zero);

    expect(states.length, 3);
    expect(states[0].status, EpisodesStatus.loading);
    expect(states[0].episodes, isEmpty);
    expect(states[1].episodes.length, 1);
    expect(states[1].episodes.first.cacheStatus, EpisodeCacheStatus.partial);
    expect(states[2].status, EpisodesStatus.loaded);
    expect(states[2].episodes.length, 1);
    expect(states[2].episodes.first.cacheStatus, EpisodeCacheStatus.full);

    await subscription.cancel();
    await cubit.close();
  });

  test('emits error when refresh fails and cache is empty', () async {
    final repository = ThrowingEpisodeRepository();
    final cubit = EpisodesCubit(GetCachedEpisodesOverview(repository), FetchEpisodesOverview(repository));

    final states = <EpisodesState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.loadEpisodes();
    await Future<void>.delayed(Duration.zero);

    expect(states.length, 2);
    expect(states[0].status, EpisodesStatus.loading);
    expect(states[1].status, EpisodesStatus.error);
    expect(states[1].message, isNotNull);

    await subscription.cancel();
    await cubit.close();
  });

  test('emits cached data with warning when refresh fails', () async {
    final cachedEpisode = EpisodeOverview(
      episode: EpisodeSummary(id: 1, name: 'Pilot', episodeCode: 'S01E01', characterIds: const [1, 2]),
      cacheStatus: EpisodeCacheStatus.partial,
      cachedCount: 1,
      totalCount: 2,
    );

    final repository = ThrowingEpisodeRepository(cachedEpisodes: [cachedEpisode]);

    final cubit = EpisodesCubit(GetCachedEpisodesOverview(repository), FetchEpisodesOverview(repository));

    final states = <EpisodesState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.loadEpisodes();
    await Future<void>.delayed(Duration.zero);

    expect(states.length, 3);
    expect(states[0].status, EpisodesStatus.loading);
    expect(states[1].episodes.length, 1);
    expect(states[2].status, EpisodesStatus.loaded);
    expect(states[2].message, isNotNull);

    await subscription.cancel();
    await cubit.close();
  });

  test('refreshCacheStatus emits cached episodes', () async {
    final cachedEpisode = EpisodeOverview(
      episode: EpisodeSummary(id: 2, name: 'Lawnmower Dog', episodeCode: 'S01E02', characterIds: const [1]),
      cacheStatus: EpisodeCacheStatus.full,
      cachedCount: 1,
      totalCount: 1,
    );

    final repository = FakeEpisodeRepository(cachedEpisodes: [cachedEpisode]);
    final cubit = EpisodesCubit(GetCachedEpisodesOverview(repository), FetchEpisodesOverview(repository));

    final states = <EpisodesState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.refreshCacheStatus();
    await Future<void>.delayed(Duration.zero);

    expect(states.length, 1);
    expect(states.first.status, EpisodesStatus.loaded);
    expect(states.first.episodes.length, 1);

    await subscription.cancel();
    await cubit.close();
  });
}
