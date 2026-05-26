import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_char/src/core/di/service_locator.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/cubit/episodes_cubit.dart';
import 'package:rick_and_morty_char/src/presentation/episodes/episodes_page.dart';

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true),
      home: BlocProvider(create: (_) => getIt<EpisodesCubit>(), child: const EpisodesPage()),
    );
  }
}
