class CatBreed {
  final String id;
  final String name;
  final String? description;
  final String? origin;
  final int? intelligence;
  final int? adaptability;
  final int? lifeSpan;
  final String? temperament;
  final String? imageUrl;
  final Weight? weight;
  final String? countryCode;
  final String? countryCodes;

  CatBreed({
    required this.id,
    required this.name,
    this.description,
    this.origin,
    this.intelligence,
    this.adaptability,
    this.lifeSpan,
    this.temperament,
    this.imageUrl,
    this.weight,
    this.countryCode,
    this.countryCodes,
  });

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      origin: json['origin'],
      intelligence: json['intelligence'],
      adaptability: json['adaptability'],
      lifeSpan:
          json['life_span'] != null
              ? int.tryParse(json['life_span'].toString())
              : null,
      temperament: json['temperament'],

      imageUrl: json['image'] != null ? json['image']['url'] : null,
      weight: json['weight'] != null ? Weight.fromJson(json['weight']) : null,
      countryCode: json['country_code'],
      countryCodes: json['country_codes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'origin': origin,
      'intelligence': intelligence,
      'adaptability': adaptability,
      'life_span': lifeSpan,
      'temperament': temperament,

      'image': imageUrl != null ? {'url': imageUrl} : null,
      'weight': weight?.toJson(),
      'country_code': countryCode,
      'country_codes': countryCodes,
    };
  }
}

class Weight {
  final String? imperial;
  final String? metric;

  Weight({this.imperial, this.metric});

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(imperial: json['imperial'], metric: json['metric']);
  }

  Map<String, dynamic> toJson() {
    return {'imperial': imperial, 'metric': metric};
  }
}
