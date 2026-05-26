import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_char/src/domain/entities/character.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/domain/usecases/fetch_episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/usecases/get_cached_episode_characters.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_state.dart';

import '../../../test_utils/fake_episode_repository.dart';

void main() {
  test('streams character updates as images arrive', () async {
    final episode = EpisodeSummary(id: 1, name: 'Pilot', episodeCode: 'S01E01', characterIds: const [1, 2]);

    final cachedCharacters = EpisodeCharacters(
      episode: episode,
      characters: [Character(id: 1, name: 'Rick Sanchez', imageBytes: Uint8List(0))],
    );

    final controller = StreamController<EpisodeCharacters>();
    final repository = FakeEpisodeRepository(cachedCharacters: cachedCharacters, characterStream: controller.stream);

    final cubit = EpisodeDetailsCubit(GetCachedEpisodeCharacters(repository), FetchEpisodeCharacters(repository));

    final states = <EpisodeDetailsState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.loadEpisode(episode);
    await Future<void>.delayed(Duration.zero);

    controller.add(
      EpisodeCharacters(
        episode: episode,
        characters: [
          Character(id: 1, name: 'Rick Sanchez', imageBytes: Uint8List.fromList([1, 2, 3])),
          Character(id: 2, name: 'Morty Smith', imageBytes: Uint8List.fromList([4, 5, 6])),
        ],
      ),
    );

    await Future<void>.delayed(Duration.zero);
    await controller.close();
    await Future<void>.delayed(Duration.zero);

    expect(states.first.status, EpisodeDetailsStatus.loading);
    expect(states.first.data, isNull);
    expect(states[1].data?.characters.length, 1);
    expect(states.last.status, EpisodeDetailsStatus.loaded);

    await subscription.cancel();
    await cubit.close();
  });

  test('emits error when stream fails without cache', () async {
    final episode = EpisodeSummary(id: 1, name: 'Pilot', episodeCode: 'S01E01', characterIds: const [1]);

    final repository = FakeEpisodeRepository(
      cachedCharacters: null,
      characterStream: Stream<EpisodeCharacters>.error(Exception('fail')),
    );

    final cubit = EpisodeDetailsCubit(GetCachedEpisodeCharacters(repository), FetchEpisodeCharacters(repository));

    final states = <EpisodeDetailsState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.loadEpisode(episode);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(states.length, 3);
    expect(states[0].status, EpisodeDetailsStatus.loading);
    expect(states[1].status, EpisodeDetailsStatus.error);
    expect(states[1].message, isNotNull);
    expect(states[2].status, EpisodeDetailsStatus.loaded);

    await subscription.cancel();
    await cubit.close();
  });

  test('emits warning when stream fails with cached data', () async {
    final episode = EpisodeSummary(id: 1, name: 'Pilot', episodeCode: 'S01E01', characterIds: const [1]);
    final cachedCharacters = EpisodeCharacters(
      episode: episode,
      characters: [Character(id: 1, name: 'Rick Sanchez', imageBytes: Uint8List(0))],
    );

    final repository = FakeEpisodeRepository(
      cachedCharacters: cachedCharacters,
      characterStream: Stream<EpisodeCharacters>.error(Exception('fail')),
    );

    final cubit = EpisodeDetailsCubit(GetCachedEpisodeCharacters(repository), FetchEpisodeCharacters(repository));

    final states = <EpisodeDetailsState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.loadEpisode(episode);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(states.length, 4);
    expect(states[0].status, EpisodeDetailsStatus.loading);
    expect(states[1].data, isNotNull);
    expect(states[2].status, EpisodeDetailsStatus.loaded);
    expect(states[2].message, isNotNull);
    expect(states[3].status, EpisodeDetailsStatus.loaded);

    await subscription.cancel();
    await cubit.close();
  });
}
