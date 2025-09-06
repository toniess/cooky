import 'package:cooky/core/services/favorites/abstract_favorites_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_event.dart';
import 'favorites_state.dart';

/// Блок для управления избранными рецептами
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final AbstractFavoritesService _favoritesService;

  FavoritesBloc(this._favoritesService) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ClearFavorites>(_onClearFavorites);
    on<UpdateFavoriteStatus>(_onUpdateFavoriteStatus);
  }

  /// Загрузка избранных рецептов
  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoading());

      final favorites = await _favoritesService.getFavorites();

      if (favorites.isEmpty) {
        emit(FavoritesEmpty());
      } else {
        // Создаем карту статусов избранного для всех рецептов
        final favoriteStatus = <String, bool>{};
        for (final meal in favorites) {
          favoriteStatus[meal.id] = true;
        }

        emit(
          FavoritesLoaded(favorites: favorites, favoriteStatus: favoriteStatus),
        );
      }
    } catch (e) {
      emit(FavoritesError('Ошибка загрузки избранных рецептов: $e'));
    }
  }

  /// Добавление рецепта в избранное
  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesService.addToFavorites(event.meal);

      // Перезагружаем список избранных
      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError('Ошибка добавления в избранное: $e'));
    }
  }

  /// Удаление рецепта из избранного
  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesService.removeFromFavorites(event.mealId);

      // Перезагружаем список избранных
      add(LoadFavorites());
    } catch (e) {
      emit(FavoritesError('Ошибка удаления из избранного: $e'));
    }
  }

  /// Очистка всех избранных рецептов
  Future<void> _onClearFavorites(
    ClearFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _favoritesService.clearFavorites();
      emit(FavoritesEmpty());
    } catch (e) {
      emit(FavoritesError('Ошибка очистки избранного: $e'));
    }
  }

  /// Обновление статуса избранного для рецепта
  Future<void> _onUpdateFavoriteStatus(
    UpdateFavoriteStatus event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final isFavorite = await _favoritesService.isFavorite(event.mealId);

      if (isFavorite) {
        add(RemoveFromFavorites(event.mealId));
      } else {
        // Если рецепт не найден в избранном, нужно получить его данные
        // Это может потребовать дополнительной логики в зависимости от архитектуры
        emit(FavoritesError('Рецепт не найден для добавления в избранное'));
      }
    } catch (e) {
      emit(FavoritesError('Ошибка обновления статуса избранного: $e'));
    }
  }
}
