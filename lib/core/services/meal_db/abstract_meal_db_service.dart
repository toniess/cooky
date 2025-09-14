import 'package:cooky/core/models/models.dart';

abstract class AbstractMealDbService {
  Future<List<Meal>> latestRecipes();
  Future<List<Meal>> randomSelection();
  Future<List<Meal>> searchMealsByName(String name);
  Future<List<MealShort>> getFilteredRecipes({
    Category? category,
    Area? area,
    int page = 1,
    int limit = 10,
  });
  Future<Category> getCategoryByName(String name);
  Future<Meal?> lookupMealById(String id);
  Future<List<Category>> getCategories();
  Future<List<Area>> getAreas();
  Future<List<Meal>> filterByCategory(Category category);
  Future<List<Meal>> filterByArea(Area area);
}
