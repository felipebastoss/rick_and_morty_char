import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_char/src/core/di/service_locator.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_overview.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/episode_details_page.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/cubit/episodes_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/cubit/episodes_state.dart';

class EpisodesPage extends StatefulWidget {
  const EpisodesPage({super.key});

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EpisodesCubit>().loadEpisodes();
    });
  }

  Future<void> _openEpisode(EpisodeSummary episode) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<EpisodeDetailsCubit>()..loadEpisode(episode),
          child: EpisodeDetailsPage(episode: episode),
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    await context.read<EpisodesCubit>().refreshCacheStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Episodes'),
      ),
      body: BlocBuilder<EpisodesCubit, EpisodesState>(
        builder: (context, state) {
          if (state.status == EpisodesStatus.loading && state.episodes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == EpisodesStatus.error && state.episodes.isEmpty) {
            return _Message(text: state.message ?? 'Something went wrong.');
          }

          if (state.episodes.isEmpty) {
            return const _Message(text: 'No episodes available.');
          }

          return Column(
            children: [
              if (state.message != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    state.message!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: state.episodes.length,
                  itemBuilder: (context, index) {
                    final overview = state.episodes[index];
                    return _EpisodeTile(
                      overview: overview,
                      onTap: () => _openEpisode(overview.episode),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({required this.overview, required this.onTap});

  final EpisodeOverview overview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(overview.cacheStatus);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overview.episode.episodeCode,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                overview.episode.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                '${overview.cachedCount}/${overview.totalCount} cached',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(EpisodeCacheStatus status) {
    switch (status) {
      case EpisodeCacheStatus.full:
        return Colors.green.shade200;
      case EpisodeCacheStatus.partial:
        return Colors.amber.shade200;
      case EpisodeCacheStatus.uncached:
        return Colors.grey.shade300;
    }
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
