# Rick and Morty Characters

A Flutter app that browses all Rick and Morty episodes and their characters using the [Rick and Morty API](https://rickandmortyapi.com). The app works offline-first: it shows cached data immediately and refreshes in the background, so the grid is always responsive even without a network connection.

## Features

- **Episodes grid** — all episodes displayed as color-coded tiles showing episode code, name, and how many characters are cached
- **Cache status colors** — green (fully cached), amber (partial), grey (not yet cached)
- **Character details** — tap any episode to see its cast; characters load progressively as images are fetched
- **Offline-first** — cached episodes and character images are shown immediately; network failures fall back gracefully with an inline message
- **Automatic image caching** — character images are stored locally as raw bytes and shown instantly on repeat visits

## Architecture

The project follows Clean Architecture with three layers:

```
lib/src/
├── domain/          # Entities, repository contracts, use cases
├── data/            # DTOs, remote/local data sources, repository implementation
└── presentation/    # Cubits, pages, widgets
```

**Domain layer** holds the core entities (`EpisodeSummary`, `EpisodeOverview`, `EpisodeCharacters`, `Character`) and the `EpisodeRepository` interface. Use cases (`FetchEpisodesOverview`, `FetchEpisodeCharacters`, `GetCachedEpisodesOverview`, `GetCachedEpisodeCharacters`) each wrap a single repository call.

**Data layer** implements `EpisodeRepository` using two data sources:
- `EpisodeRemoteDataSource` — fetches all episodes via paginated API calls; fetches characters in parallel chunks of 20 using the multi-character endpoint
- `EpisodeLocalDataSource` — reads and writes to a Drift (SQLite) database

**Presentation layer** uses `flutter_bloc` Cubits:
- `EpisodesCubit` — loads cached episodes first, then refreshes from the network
- `EpisodeDetailsCubit` — emits a stream of progressive updates as character images arrive one by one

## Tech Stack

| Concern | Library |
|---|---|
| State management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) |
| Dependency injection | [get_it](https://pub.dev/packages/get_it) |
| Local database | [drift](https://pub.dev/packages/drift) + [drift_flutter](https://pub.dev/packages/drift_flutter) |
| HTTP | [http](https://pub.dev/packages/http) |
| Mocking (tests) | [mocktail](https://pub.dev/packages/mocktail) |

## Project Structure

```
lib/
├── main.dart
└── src/
    ├── core/
    │   ├── client/          # AppHttpClient with retry + exponential backoff
    │   └── di/              # GetIt service locator
    ├── data/
    │   ├── datasources/     # Remote and local data sources
    │   ├── local/           # Drift database schema and generated code
    │   ├── models/          # JSON DTOs
    │   └── repositories/    # EpisodeRepositoryImpl
    ├── domain/
    │   ├── entities/        # EpisodeSummary, EpisodeOverview, Character, EpisodeCharacters
    │   ├── repositories/    # EpisodeRepository interface
    │   └── usecases/        # One class per use case
    └── presentation/
        ├── app.dart
        ├── episodes/        # Episodes grid page + EpisodesCubit
        └── episode_details/ # Episode details page + EpisodeDetailsCubit
```

## Getting Started

**Prerequisites**

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — the project uses [fvm](https://fvm.app) to pin the Flutter version; run `fvm install` once to set it up
- No API key required — the Rick and Morty API is public

**Run**

```bash
# with fvm
fvm flutter run

# without fvm (ensure your global flutter matches .fvmrc)
flutter run
```

## Testing

```bash
fvm flutter test
```

The test suite covers:

| Layer | What is tested |
|---|---|
| `AppHttpClient` | JSON parsing, non-2xx errors, retry with exponential backoff, `Retry-After` header |
| `EpisodeRemoteDataSource` | Pagination, chunked character fetching, single/list response handling |
| `EpisodeLocalDataSource` | DTO mapping, JSON encode/decode of character id lists |
| `EpisodeRepositoryImpl` | Cache-first logic, cache status computation, image byte validation |
| `AppDatabase` | All CRUD methods against an in-memory Drift database |
| `EpisodesCubit` | Loading states, network error fallback, cache-first flow |
| `EpisodeDetailsCubit` | Progressive image stream, error handling |
| `EpisodesPage` | All UI states (loading, error, empty, grid with/without banner), cache-status tile colors, navigation |
| `EpisodeDetailsPage` | Character list rendering, cached avatar display |
| `configureDependencies` | All types registered; lazy singletons return the same instance |

## Design Decisions

- **Episodes are cached locally** (id, name, code, character ids) so the grid can render offline-first and compute cache status without hitting the network.
- **Characters are cached individually** (id, name, image bytes), and tile colors are derived from the ratio of cached to total characters per episode.
- **The episodes grid loads cached data first**, refreshes from the network, and re-checks cache status after returning from the details screen.
- **Character requests use the multi-character endpoint** in chunks of 20 and run the chunks in parallel with `Future.wait`.
- **Characters are sorted case-insensitively** before display on the details screen.
- **Network failures fall back to cached data** when available and show a message only when needed; a full error state is only shown when there is nothing cached to display.
- **Character images are fetched progressively** — the repository yields the character list before images arrive and yields again as each image resolves, so the UI updates incrementally.
- **Image bytes are validated** (JPEG/PNG magic bytes) before being stored or rendered, so corrupted or empty responses are silently discarded.
- **The HTTP client uses exponential backoff** with a configurable base delay and respects the `Retry-After` response header when present.
