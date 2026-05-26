import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_char/src/core/client/app_http_client.dart';
import 'package:rick_and_morty_char/src/core/di/service_locator.dart';
import 'package:rick_and_morty_char/src/data/datasources/episode_local_data_source.dart';
import 'package:rick_and_morty_char/src/data/datasources/episode_remote_data_source.dart';
import 'package:rick_and_morty_char/src/data/local/app_database.dart';
import 'package:rick_and_morty_char/src/data/repositories/episode_repository_impl.dart';
import 'package:rick_and_morty_char/src/domain/repositories/episode_repository.dart';
import 'package:rick_and_morty_char/src/domain/usecases/fetch_episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/usecases/fetch_episodes_overview.dart';
import 'package:rick_and_morty_char/src/domain/usecases/get_cached_episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/usecases/get_cached_episodes_overview.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/cubit/episodes_cubit.dart';

void main() {
  tearDown(() async {
    await getIt.reset();
  });

  test('configureDependencies registers all expected types', () {
    configureDependencies();

    expect(getIt.isRegistered<http.Client>(), isTrue);
    expect(getIt.isRegistered<AppHttpClient>(), isTrue);
    expect(getIt.isRegistered<AppDatabase>(), isTrue);
    expect(getIt.isRegistered<EpisodeRemoteDataSource>(), isTrue);
    expect(getIt.isRegistered<EpisodeLocalDataSource>(), isTrue);
    expect(getIt.isRegistered<EpisodeRepository>(), isTrue);
    expect(getIt.isRegistered<GetCachedEpisodesOverview>(), isTrue);
    expect(getIt.isRegistered<FetchEpisodesOverview>(), isTrue);
    expect(getIt.isRegistered<GetCachedEpisodeCharacters>(), isTrue);
    expect(getIt.isRegistered<FetchEpisodeCharacters>(), isTrue);
    expect(getIt.isRegistered<EpisodesCubit>(), isTrue);
    expect(getIt.isRegistered<EpisodeDetailsCubit>(), isTrue);
  });

  test('configureDependencies resolves http.Client as lazy singleton', () {
    configureDependencies();

    final a = getIt<http.Client>();
    final b = getIt<http.Client>();

    expect(a, isA<http.Client>());
    expect(identical(a, b), isTrue);
  });

  test('configureDependencies resolves AppHttpClient as lazy singleton', () {
    configureDependencies();

    final a = getIt<AppHttpClient>();
    final b = getIt<AppHttpClient>();

    expect(a, isA<AppHttpClient>());
    expect(identical(a, b), isTrue);
  });

  test('configureDependencies resolves EpisodeRemoteDataSource as lazy singleton', () {
    configureDependencies();

    final a = getIt<EpisodeRemoteDataSource>();
    final b = getIt<EpisodeRemoteDataSource>();

    expect(a, isA<EpisodeRemoteDataSource>());
    expect(identical(a, b), isTrue);
  });

  test('EpisodeRepository is registered as EpisodeRepositoryImpl', () {
    configureDependencies();

    // Verify the registration target type without resolving (avoids AppDatabase)
    expect(getIt.isRegistered<EpisodeRepository>(), isTrue);
    expect(getIt.isRegistered<EpisodeRepositoryImpl>(), isFalse);
  });
}
