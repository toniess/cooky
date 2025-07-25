import 'package:cooky/core/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// todo review methods and dounble check
class MealDbService {
  static final String apiKey = dotenv.env['API_KEY'] ?? '1'; // fallback to free api key
  static final String baseUrl = 'https://www.themealdb.com/api/json/v1/$apiKey';
  final Dio _dio;

  MealDbService({Dio? dio}) : _dio = dio ?? Dio();

  /// Search meal by name
  Future<List<Meal>> searchMealsByName(String name) async {
    final response = await _dio.get('$baseUrl/search.php', queryParameters: {'s': name});
    return Meal.fromJsonList(response.data['meals']);
  }

  /// List all meals by first letter
  Future<List<Meal>> searchMealsByFirstLetter(String letter) async {
    final response = await _dio.get('$baseUrl/search.php', queryParameters: {'f': letter});
    return Meal.fromJsonList(response.data['meals']);
  }

  /// Lookup full meal details by ID
  Future<Meal?> lookupMealById(String id) async {
    final response = await _dio.get('$baseUrl/lookup.php', queryParameters: {'i': id});
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
  Future<List<Meal>> randomSelection() async {
    final response = await _dio.get('$baseUrl/randomselection.php');
    return Meal.fromJsonList(response.data['meals']);
  }

  /// List all meal categories
  Future<List<Category>> getCategories() async {
    final response = await _dio.get('$baseUrl/categories.php');
    return Category.fromJsonList(response.data['categories']);
  }

  /// List all Categories
  @Deprecated('Use getCategories instead')
  Future<List<String>> listCategories() async {
    final response = await _dio.get('$baseUrl/list.php', queryParameters: {'c': 'list'});
    return (response.data['meals'] as List).map<String>((e) => e['strCategory'] as String).toList();
  }

  /// List all Areas
  Future<List<Area>> listAreas() async {
    final response = await _dio.get('$baseUrl/list.php', queryParameters: {'a': 'list'});
    return Area.fromJsonList(response.data['meals']);
  }

  /// List all Ingredients
  Future<List<Ingredient>> listIngredients() async {
    final response = await _dio.get('$baseUrl/list.php', queryParameters: {'i': 'list'});
    return Ingredient.fromJsonList(response.data['meals']);
  }

  /// Filter by ingredients
  Future<List<Meal>> filterByIngredient(List<Ingredient> ingredients) async {
    final ingredientsQuery = ingredients.map((e) => e.name).join(',');
    final response = await _dio.get('$baseUrl/filter.php', queryParameters: {'i': ingredientsQuery});
    return Meal.fromJsonList(response.data['meals']);
  }

  /// Filter by Category
  Future<List<Meal>> filterByCategory(Category category) async {
    final response = await _dio.get('$baseUrl/filter.php', queryParameters: {'c': category.name});
    return Meal.fromJsonList(response.data['meals']);
  }

  /// Filter by Area
  Future<List<Meal>> filterByArea(Area area) async {
    final response = await _dio.get('$baseUrl/filter.php', queryParameters: {'a': area.name});
    return Meal.fromJsonList(response.data['meals']);
  }
}
