import 'package:cooky/core/models/meal.dart';

/// События для блока избранного
abstract class FavoritesEvent {}

/// Загрузка избранных рецептов
class LoadFavorites extends FavoritesEvent {}

/// Добавление рецепта в избранное
class AddToFavorites extends FavoritesEvent {
  final Meal meal;

  AddToFavorites(this.meal);
}

/// Удаление рецепта из избранного
class RemoveFromFavorites extends FavoritesEvent {
  final String mealId;

  RemoveFromFavorites(this.mealId);
}

/// Очистка всех избранных рецептов
class ClearFavorites extends FavoritesEvent {}

/// Обновление статуса избранного для рецепта
class UpdateFavoriteStatus extends FavoritesEvent {
  final String mealId;

  UpdateFavoriteStatus(this.mealId);
}
