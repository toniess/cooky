class Meal {
  final String id;
  final String name;
  final String? alternate;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String? tags;
  final String youtube;
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
      if (ingredient != null && ingredient.toString().isNotEmpty && measure != null && measure.toString().isNotEmpty) {
        ingredients.add(MealIngredient(
          name: ingredient.toString(),
          measure: measure.toString(),
        ));
      }
    }

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      alternate: json['strMealAlternate'],
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      tags: json['strTags'],
      youtube: json['strYoutube'],
      ingredients: ingredients,
    );
  }

  static List<Meal> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Meal.fromJson(json)).toList();
  }
}

class MealIngredient {
  final String name;
  final String measure;

  MealIngredient({
    required this.name,
    required this.measure,
  });
}
