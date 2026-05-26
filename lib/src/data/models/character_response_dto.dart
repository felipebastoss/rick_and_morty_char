class CharacterResponseDto {
  CharacterResponseDto({required this.id, required this.name, required this.image});

  final int id;
  final String name;
  final String image;

  factory CharacterResponseDto.fromJson(Map<String, dynamic> json) {
    return CharacterResponseDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}
