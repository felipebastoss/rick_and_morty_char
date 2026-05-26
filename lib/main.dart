import 'package:flutter/material.dart';
import 'package:rick_and_morty_char/src/core/di/service_locator.dart';
import 'package:rick_and_morty_char/src/presentation/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const RickAndMortyApp());
}
