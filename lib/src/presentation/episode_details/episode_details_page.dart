import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_characters.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episode_details/cubit/episode_details_state.dart';

class EpisodeDetailsPage extends StatelessWidget {
  const EpisodeDetailsPage({super.key, required this.episode});

  final EpisodeSummary episode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(episode.name)),
      body: BlocBuilder<EpisodeDetailsCubit, EpisodeDetailsState>(
        builder: (context, state) {
          if (state.status == EpisodeDetailsStatus.loading && state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == EpisodeDetailsStatus.error && state.data == null) {
            return _Message(text: state.message ?? 'Something went wrong.');
          }

          final data = state.data;
          if (data == null) {
            return const _Message(text: 'No characters available.');
          }

          return _EpisodeContent(
            data: data,
            isRefreshing: state.status == EpisodeDetailsStatus.loading,
            isFromCache: state.isFromCache,
            message: state.message,
          );
        },
      ),
    );
  }
}

class _EpisodeContent extends StatelessWidget {
  const _EpisodeContent({
    required this.data,
    required this.isRefreshing,
    required this.isFromCache,
    required this.message,
  });

  final EpisodeCharacters data;
  final bool isRefreshing;
  final bool isFromCache;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cachedCount = data.characters.where((character) => character.imageBytes.isNotEmpty).length;
    final totalCount = data.episode.characterIds.length;
    final isPartial = cachedCount < totalCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(data.episode.episodeCode, style: theme.textTheme.titleMedium),
        ),
        if (isFromCache || isPartial)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Cached $cachedCount of $totalCount characters', style: theme.textTheme.bodySmall),
          ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(message!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
          ),
        if (isRefreshing)
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: LinearProgressIndicator()),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: data.characters.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final character = data.characters[index];
              final hasImage = character.imageBytes.isNotEmpty;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: hasImage ? MemoryImage(character.imageBytes) : null,
                  child: hasImage ? null : const Icon(Icons.person),
                ),
                title: Text(character.name),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, textAlign: TextAlign.center));
  }
}
