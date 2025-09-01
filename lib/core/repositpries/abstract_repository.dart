import 'package:cooky/core/models/models.dart';

abstract class AbstractRepository {
  Future<List<Meal>> randomSelection();
}
