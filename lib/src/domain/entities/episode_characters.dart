import 'package:rick_and_morty_char/src/domain/entities/character.dart';
import 'package:rick_and_morty_char/src/domain/entities/episode_summary.dart';

class EpisodeCharacters {
  const EpisodeCharacters({required this.episode, required this.characters});

  final EpisodeSummary episode;
  final List<Character> characters;
}
