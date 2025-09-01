import 'package:cooky/core/models/models.dart';

abstract class AbstractMealDbService {
  Future<List<Meal>> randomSelection();
}
