import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_char/src/core/di/service_locator.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/domain/usecases/fetch_episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/usecases/fetch_episodes_overview.dart';
import 'package:rick_and_morty_char/src/domain/usecases/get_cached_episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/usecases/get_cached_episodes_overview.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/episode_details_page.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/cubit/episodes_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/cubit/episodes_state.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/episodes_page.dart';

import '../../test_utils/fake_episode_repository.dart';

class TestEpisodesCubit extends EpisodesCubit {
  TestEpisodesCubit(super.getCached, super.fetch);

  void emitState(EpisodesState state) {
    emit(state);
  }

  @override
  Future<void> loadEpisodes() async {}
}

class TestEpisodeDetailsCubit extends EpisodeDetailsCubit {
  TestEpisodeDetailsCubit(super.getCached, super.fetch);

  @override
  Future<void> loadEpisode(EpisodeSummary episode) async {}
}

void main() {
  final episode = EpisodeSummary(id: 1, name: 'Pilot', episodeCode: 'S01E01', characterIds: const [1, 2, 3]);

  Widget buildWidget(EpisodesCubit cubit) =>
      MaterialApp(home: BlocProvider<EpisodesCubit>.value(value: cubit, child: const EpisodesPage()));

  TestEpisodesCubit makeCubit() {
    final repo = FakeEpisodeRepository();
    return TestEpisodesCubit(GetCachedEpisodesOverview(repo), FetchEpisodesOverview(repo));
  }

  testWidgets('renders episodes grid tiles', (tester) async {
    final overview = EpisodeOverview(
      episode: episode,
      cacheStatus: EpisodeCacheStatus.partial,
      cachedCount: 1,
      totalCount: 3,
    );
    final cubit = makeCubit()..emitState(EpisodesState(status: EpisodesStatus.loaded, episodes: [overview]));

    await tester.pumpWidget(buildWidget(cubit));

    expect(find.text('Episodes'), findsOneWidget);
    expect(find.text('S01E01'), findsOneWidget);
    expect(find.text('Pilot'), findsOneWidget);
    expect(find.text('1/3 cached'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders loading indicator when loading with no episodes', (tester) async {
    final cubit = makeCubit()..emitState(const EpisodesState(status: EpisodesStatus.loading));

    await tester.pumpWidget(buildWidget(cubit));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders provided error message when error with no episodes', (tester) async {
    final cubit = makeCubit()
      ..emitState(const EpisodesState(status: EpisodesStatus.error, message: 'Network error'));

    await tester.pumpWidget(buildWidget(cubit));

    expect(find.text('Network error'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders fallback error message when error with no message', (tester) async {
    final cubit = makeCubit()..emitState(const EpisodesState(status: EpisodesStatus.error));

    await tester.pumpWidget(buildWidget(cubit));

    expect(find.text('Something went wrong.'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders no episodes message when episodes list is empty', (tester) async {
    final cubit = makeCubit()..emitState(const EpisodesState(status: EpisodesStatus.loaded));

    await tester.pumpWidget(buildWidget(cubit));

    expect(find.text('No episodes available.'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders error banner alongside episodes when message is present', (tester) async {
    final overview = EpisodeOverview(
      episode: episode,
      cacheStatus: EpisodeCacheStatus.partial,
      cachedCount: 0,
      totalCount: 1,
    );
    final cubit = makeCubit()
      ..emitState(EpisodesState(
        status: EpisodesStatus.loaded,
        episodes: [overview],
        message: 'Unable to refresh. Showing cached data.',
      ));

    await tester.pumpWidget(buildWidget(cubit));

    expect(find.text('S01E01'), findsOneWidget);
    expect(find.text('Unable to refresh. Showing cached data.'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('episode tile uses green color when fully cached', (tester) async {
    final overview = EpisodeOverview(
      episode: episode,
      cacheStatus: EpisodeCacheStatus.full,
      cachedCount: 3,
      totalCount: 3,
    );
    final cubit = makeCubit()..emitState(EpisodesState(status: EpisodesStatus.loaded, episodes: [overview]));

    await tester.pumpWidget(buildWidget(cubit));

    final ink = tester.widget<Ink>(find.byType(Ink).first);
    expect((ink.decoration as BoxDecoration).color, Colors.green.shade200);

    await cubit.close();
  });

  testWidgets('episode tile uses grey color when uncached', (tester) async {
    final overview = EpisodeOverview(
      episode: episode,
      cacheStatus: EpisodeCacheStatus.uncached,
      cachedCount: 0,
      totalCount: 3,
    );
    final cubit = makeCubit()..emitState(EpisodesState(status: EpisodesStatus.loaded, episodes: [overview]));

    await tester.pumpWidget(buildWidget(cubit));

    final ink = tester.widget<Ink>(find.byType(Ink).first);
    expect((ink.decoration as BoxDecoration).color, Colors.grey.shade300);

    await cubit.close();
  });

  group('navigation', () {
    setUp(() {
      final repo = FakeEpisodeRepository();
      getIt.registerFactory<EpisodeDetailsCubit>(
        () => TestEpisodeDetailsCubit(GetCachedEpisodeCharacters(repo), FetchEpisodeCharacters(repo)),
      );
    });

    tearDown(() async {
      await getIt.reset();
    });

    testWidgets('tapping episode tile navigates to episode details', (tester) async {
      final overview = EpisodeOverview(
        episode: episode,
        cacheStatus: EpisodeCacheStatus.uncached,
        cachedCount: 0,
        totalCount: 3,
      );
      final cubit = makeCubit()..emitState(EpisodesState(status: EpisodesStatus.loaded, episodes: [overview]));

      await tester.pumpWidget(buildWidget(cubit));

      await tester.tap(find.text('S01E01'));
      await tester.pumpAndSettle();

      expect(find.byType(EpisodeDetailsPage), findsOneWidget);

      await cubit.close();
    });

    testWidgets('navigating back from episode details returns to episodes page', (tester) async {
      final overview = EpisodeOverview(
        episode: episode,
        cacheStatus: EpisodeCacheStatus.uncached,
        cachedCount: 0,
        totalCount: 3,
      );
      final cubit = makeCubit()..emitState(EpisodesState(status: EpisodesStatus.loaded, episodes: [overview]));

      await tester.pumpWidget(buildWidget(cubit));

      await tester.tap(find.text('S01E01'));
      await tester.pumpAndSettle();

      expect(find.byType(EpisodeDetailsPage), findsOneWidget);

      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.byType(EpisodesPage), findsOneWidget);

      await cubit.close();
    });
  });
}
