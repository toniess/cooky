import 'package:cooky/core/models/models.dart';
import 'package:cooky/core/repositpries/abstract_repository.dart';
import 'package:cooky/core/services/meal_db/abstract_meal_db_service.dart';

class Repository implements AbstractRepository {
  final AbstractMealDbService _mealDbService;

  Repository({required AbstractMealDbService mealDbService})
    : _mealDbService = mealDbService;

  @override
  Future<List<Meal>> randomSelection() async {
    return _mealDbService.randomSelection();
  }
}
