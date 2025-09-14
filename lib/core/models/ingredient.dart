class Ingredient {
  final String id;
  final String name;
  final String description;
  final String? type;

  Ingredient({
    required this.id,
    required this.name,
    required this.description,
    this.type,
  });

  Ingredient.named(this.name) : id = '0', description = '', type = '';

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['idIngredient'] as String,
      name: json['strIngredient'] as String,
      description: json['strDescription'] as String? ?? '',
      type: json['strType'] as String?,
    );
  }

  static List<Ingredient> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Ingredient.fromJson(json)).toList();
  }
}

extension IngredientImageExtension on Ingredient {
  static const String _baseUrl = 'https://www.themealdb.com/images/ingredients';

  String get imageUrl => '$_baseUrl/$name.png';
  String get imageUrlSmall => '$_baseUrl/$name-small.png';
  String get imageUrlMedium => '$_baseUrl/$name-medium.png';
  String get imageUrlLarge => '$_baseUrl/$name-large.png';
}
