import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty_char/src/domain/entities/character.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/domain/usecases/fetch_episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/usecases/get_cached_episode_characters.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_state.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/episode_details_page.dart';

import '../../test_utils/fake_episode_repository.dart';

class TestEpisodeDetailsCubit extends EpisodeDetailsCubit {
  TestEpisodeDetailsCubit(super.getCached, super.fetch);

  void emitState(EpisodeDetailsState state) {
    emit(state);
  }

  @override
  Future<void> loadEpisode(EpisodeSummary episode) async {}
}

void main() {
  testWidgets('renders characters with cached avatars', (tester) async {
    const transparentImage = <int>[
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0A,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82,
    ];

    final episode = EpisodeSummary(id: 1, name: 'Pilot', episodeCode: 'S01E01', characterIds: const [1, 2]);

    final data = EpisodeCharacters(
      episode: episode,
      characters: [
        Character(id: 1, name: 'Rick Sanchez', imageBytes: Uint8List.fromList(transparentImage)),
        Character(id: 2, name: 'Morty Smith', imageBytes: Uint8List(0)),
      ],
    );

    final repository = FakeEpisodeRepository();
    final testCubit = TestEpisodeDetailsCubit(
      GetCachedEpisodeCharacters(repository),
      FetchEpisodeCharacters(repository),
    );
    final EpisodeDetailsCubit cubit = testCubit;

    testCubit.emitState(EpisodeDetailsState(status: EpisodeDetailsStatus.loaded, data: data, isFromCache: true));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<EpisodeDetailsCubit>.value(
          value: cubit,
          child: EpisodeDetailsPage(episode: episode),
        ),
      ),
    );

    expect(find.text('S01E01'), findsOneWidget);
    expect(find.text('Rick Sanchez'), findsOneWidget);
    expect(find.text('Morty Smith'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    final avatars = tester.widgetList<CircleAvatar>(find.byType(CircleAvatar)).toList();
    expect(avatars.length, 2);
    expect(avatars.first.backgroundImage, isA<MemoryImage>());

    await cubit.close();
  });
}
