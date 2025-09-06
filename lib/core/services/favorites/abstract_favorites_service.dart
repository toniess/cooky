import 'package:cooky/core/models/models.dart';

/// Абстрактный сервис для работы с избранными рецептами
abstract class AbstractFavoritesService {
  /// Инициализация сервиса
  Future<void> init();

  /// Добавить рецепт в избранное
  Future<void> addToFavorites(Meal meal);

  /// Удалить рецепт из избранного
  Future<void> removeFromFavorites(String mealId);

  /// Проверить, находится ли рецепт в избранном
  Future<bool> isFavorite(String mealId);

  /// Получить все избранные рецепты
  Future<List<Meal>> getFavorites();

  /// Очистить все избранные рецепты
  Future<void> clearFavorites();

  /// Получить количество избранных рецептов
  Future<int> getFavoritesCount();
}
