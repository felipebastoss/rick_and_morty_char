import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_char/src/core/client/app_http_client.dart';
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

final getIt = GetIt.instance;

void configureDependencies() {
  getIt
    ..registerLazySingleton<http.Client>(() => http.Client())
    ..registerLazySingleton<AppHttpClient>(() => AppHttpClient(getIt<http.Client>()))
    ..registerLazySingleton<AppDatabase>(() => AppDatabase())
    ..registerLazySingleton<EpisodeRemoteDataSource>(() => EpisodeRemoteDataSource(getIt<AppHttpClient>()))
    ..registerLazySingleton<EpisodeLocalDataSource>(() => EpisodeLocalDataSource(getIt<AppDatabase>()))
    ..registerLazySingleton<EpisodeRepository>(
      () => EpisodeRepositoryImpl(getIt<EpisodeRemoteDataSource>(), getIt<EpisodeLocalDataSource>()),
    )
    ..registerLazySingleton<GetCachedEpisodesOverview>(() => GetCachedEpisodesOverview(getIt<EpisodeRepository>()))
    ..registerLazySingleton<FetchEpisodesOverview>(() => FetchEpisodesOverview(getIt<EpisodeRepository>()))
    ..registerLazySingleton<GetCachedEpisodeCharacters>(() => GetCachedEpisodeCharacters(getIt<EpisodeRepository>()))
    ..registerLazySingleton<FetchEpisodeCharacters>(() => FetchEpisodeCharacters(getIt<EpisodeRepository>()))
    ..registerFactory<EpisodesCubit>(
      () => EpisodesCubit(getIt<GetCachedEpisodesOverview>(), getIt<FetchEpisodesOverview>()),
    )
    ..registerFactory<EpisodeDetailsCubit>(
      () => EpisodeDetailsCubit(getIt<GetCachedEpisodeCharacters>(), getIt<FetchEpisodeCharacters>()),
    );
}
