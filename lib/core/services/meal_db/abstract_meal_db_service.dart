import 'package:cooky/core/models/models.dart';

abstract class AbstractMealDbService {
  Future<List<Meal>> randomSelection();
  Future<List<MealShort>> getFilteredRecipes({
    Category? category,
    Area? area,
    int page = 1,
    int limit = 10,
  });
  Future<Category> getCategoryByName(String name);
  Future<Meal?> lookupMealById(String id);
}
