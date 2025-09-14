import 'package:cooky/core/models/models.dart';
import 'package:cooky/core/services/meal_db/abstract_meal_db_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// todo review methods and dounble check
class MealDbService implements AbstractMealDbService {
  static final String apiKey = dotenv.env['THEMEALDB_API_KEY'] ?? '1';
  static final String baseUrl = 'https://www.themealdb.com/api/json/v2/$apiKey';
  final Dio _dio;

  MealDbService({Dio? dio}) : _dio = dio ?? Dio();

  /// Search meal by name
  @override
  Future<List<Meal>> searchMealsByName(String name) async {
    final response = await _dio.get(
      '$baseUrl/search.php',
      queryParameters: {'s': name},
    );
    return Meal.fromJsonList(response.data['meals']);
  }

  /// List all meals by first letter
  Future<List<Meal>> searchMealsByFirstLetter(String letter) async {
    final response = await _dio.get(
      '$baseUrl/search.php',
      queryParameters: {'f': letter},
    );
    return Meal.fromJsonList(response.data['meals']);
  }

  /// Lookup full meal details by ID
  @override
  Future<Meal?> lookupMealById(String id) async {
    final response = await _dio.get(
      '$baseUrl/lookup.php',
      queryParameters: {'i': id},
    );
    final meals = Meal.fromJsonList(response.data['meals']);
    return meals.isNotEmpty ? meals.first : null;
  }

  /// Lookup a single random meal
  Future<Meal?> randomMeal() async {
    final response = await _dio.get('$baseUrl/random.php');
    final meals = Meal.fromJsonList(response.data['meals']);
    return meals.isNotEmpty ? meals.first : null;
  }

  /// Lookup 10 random meals (Premium)
  @override
  Future<List<Meal>> randomSelection() async {
    final response = await _dio.get('$baseUrl/randomselection.php');
    return Meal.fromJsonList(response.data['meals']);
  }

  /// List all meal categories
  @override
  Future<List<Category>> getCategories() async {
    final response = await _dio.get('$baseUrl/categories.php');
    return Category.fromJsonList(response.data['categories']);
  }

  /// List all Categories
  @Deprecated('Use getCategories instead')
  Future<List<String>> listCategories() async {
    final response = await _dio.get(
      '$baseUrl/list.php',
      queryParameters: {'c': 'list'},
    );
    return (response.data['meals'] as List)
        .map<String>((e) => e['strCategory'] as String)
        .toList();
  }

  /// List all Areas
  @override
  Future<List<Area>> getAreas() async {
    final response = await _dio.get(
      '$baseUrl/list.php',
      queryParameters: {'a': 'list'},
    );
    return Area.fromJsonList(response.data['meals']);
  }

  /// List all Areas (deprecated)
  @Deprecated('Use getAreas instead')
  Future<List<Area>> listAreas() async {
    return getAreas();
  }

  /// List all Ingredients
  @override
  Future<List<Ingredient>> getIngredients() async {
    final response = await _dio.get(
      '$baseUrl/list.php',
      queryParameters: {'i': 'list'},
    );
    return Ingredient.fromJsonList(response.data['meals']);
  }

  /// List all Ingredients (deprecated)
  @Deprecated('Use getIngredients instead')
  Future<List<Ingredient>> listIngredients() async {
    return getIngredients();
  }

  /// Filter by ingredients
  @override
  Future<List<Meal>> filterByIngredient(List<Ingredient> ingredients) async {
    final ingredientsQuery = ingredients.map((e) => e.name).join(',');
    final response = await _dio.get(
      '$baseUrl/filter.php',
      queryParameters: {'i': ingredientsQuery},
    );
    return Meal.fromJsonList(response.data['meals']);
  }

  /// Filter by Category
  @override
  Future<List<Meal>> filterByCategory(Category category) async {
    final response = await _dio.get(
      '$baseUrl/filter.php',
      queryParameters: {'c': category.name},
    );
    final mealShorts = MealShort.fromJsonList(response.data['meals']);
    // Convert MealShort to Meal by looking up full details
    List<Meal> meals = [];
    for (final mealShort in mealShorts) {
      final meal = await lookupMealById(mealShort.id);
      if (meal != null) {
        meals.add(meal);
      }
    }
    return meals;
  }

  /// Filter by Area
  @override
  Future<List<Meal>> filterByArea(Area area) async {
    final response = await _dio.get(
      '$baseUrl/filter.php',
      queryParameters: {'a': area.name},
    );
    final mealShorts = MealShort.fromJsonList(response.data['meals']);
    // Convert MealShort to Meal by looking up full details
    List<Meal> meals = [];
    for (final mealShort in mealShorts) {
      final meal = await lookupMealById(mealShort.id);
      if (meal != null) {
        meals.add(meal);
      }
    }
    return meals;
  }

  /// Get filtered recipes with pagination
  @override
  Future<List<MealShort>> getFilteredRecipes({
    Category? category,
    Area? area,
    int page = 1,
    int limit = 10,
  }) async {
    List<MealShort> allRecipes = [];

    if (category != null) {
      final response = await _dio.get(
        '$baseUrl/filter.php',
        queryParameters: {'c': category.name},
      );
      allRecipes.addAll(MealShort.fromJsonList(response.data['meals']));
    }

    if (area != null) {
      final response = await _dio.get(
        '$baseUrl/filter.php',
        queryParameters: {'a': area.name},
      );
      allRecipes.addAll(MealShort.fromJsonList(response.data['meals']));
    }

    allRecipes.shuffle();

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= allRecipes.length) {
      return [];
    }

    return allRecipes.sublist(
      startIndex,
      endIndex > allRecipes.length ? allRecipes.length : endIndex,
    );
  }

  @override
  Future<Category> getCategoryByName(String name) async {
    final response = await _dio.get(
      '$baseUrl/filter.php',
      queryParameters: {'c': name},
    );
    return Category.fromJsonList(response.data['categories']).first;
  }

  @override
  Future<List<Meal>> latestRecipes() async {
    final response = await _dio.get('$baseUrl/latest.php');
    return Meal.fromJsonList(response.data['meals']);
  }
}
