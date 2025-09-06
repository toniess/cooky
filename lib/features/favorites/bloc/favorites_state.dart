import 'package:cooky/core/models/meal.dart';

/// Состояния блока избранного
abstract class FavoritesState {}

/// Начальное состояние
class FavoritesInitial extends FavoritesState {}

/// Загрузка избранных рецептов
class FavoritesLoading extends FavoritesState {}

/// Успешная загрузка избранных рецептов
class FavoritesLoaded extends FavoritesState {
  final List<Meal> favorites;
  final Map<String, bool> favoriteStatus;

  FavoritesLoaded({required this.favorites, required this.favoriteStatus});
}

/// Ошибка загрузки избранных рецептов
class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}

/// Пустой список избранных
class FavoritesEmpty extends FavoritesState {}
