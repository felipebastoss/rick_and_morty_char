import 'dart:typed_data';

class Character {
  const Character({required this.id, required this.name, required this.imageBytes});

  final int id;
  final String name;
  final Uint8List imageBytes;
}
