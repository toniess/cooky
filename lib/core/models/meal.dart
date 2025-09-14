import 'package:hive/hive.dart';

part 'meal.g.dart';

@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? alternate;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final String area;
  @HiveField(5)
  final String instructions;
  @HiveField(6)
  final String thumbnail;
  @HiveField(7)
  final String? tags;
  @HiveField(8)
  final String youtube;
  @HiveField(9)
  final List<MealIngredient> ingredients;

  Meal({
    required this.id,
    required this.name,
    this.alternate,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    this.tags,
    required this.youtube,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<MealIngredient> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null &&
          ingredient.toString().isNotEmpty &&
          measure != null &&
          measure.toString().isNotEmpty) {
        ingredients.add(
          MealIngredient(
            name: ingredient.toString(),
            measure: measure.toString(),
          ),
        );
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      alternate: json['strMealAlternate'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      tags: json['strTags'] ?? '',
      youtube: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }

  static List<Meal> fromJsonList(dynamic jsonList) {
    try {
      return (jsonList as List).map((json) => Meal.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // only for poor api, need to improve later
  String get formattedInstructions {
    if (instructions.contains('STEP')) {
      final formattedInstructions = instructions.trim().replaceAll(
        'STEP',
        '\n    STEP',
      );
      return '    ${formattedInstructions.trim()}';
    }
    final lines = instructions.trim().split('\n');
    for (int i = 0; i < lines.length; i++) {
      lines[i] = '${i + 1}. ${lines[i]}';
    }
    final formattedLines = lines
        .map((line) {
          if (line.startsWith('-')) {
            return line;
          }
          return '    $line';
        })
        .join('\n\n');
    return formattedLines;
  }
}

@HiveType(typeId: 1)
class MealIngredient extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String measure;

  MealIngredient({required this.name, required this.measure});
}

extension MealIngredientImageExtension on MealIngredient {
  static const String _baseUrl = 'https://www.themealdb.com/images/ingredients';

  String get imageUrl => '$_baseUrl/$name.png';
  String get imageUrlSmall => '$_baseUrl/$name-small.png';
  String get imageUrlMedium => '$_baseUrl/$name-medium.png';
  String get imageUrlLarge => '$_baseUrl/$name-large.png';
}

@HiveType(typeId: 2)
class MealShort extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String thumbnail;

  MealShort({required this.id, required this.name, required this.thumbnail});

  factory MealShort.fromJson(Map<String, dynamic> json) {
    return MealShort(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
    );
  }

  static List<MealShort> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MealShort.fromJson(json)).toList();
  }
}
