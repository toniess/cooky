import 'package:cooky/core/models/models.dart';
import 'package:cooky/core/services/favorites/abstract_favorites_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Сервис для работы с избранными рецептами с использованием Hive
class FavoritesService implements AbstractFavoritesService {
  static const String _boxName = 'favorites_box';
  late Box<Meal> _favoritesBox;

  @override
  Future<void> init() async {
    // Проверяем, не инициализирован ли уже бокс
    if (Hive.isBoxOpen(_boxName)) {
      _favoritesBox = Hive.box<Meal>(_boxName);
      return;
    }

    // Регистрируем адаптеры
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MealAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MealIngredientAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MealShortAdapter());
    }

    // Открываем бокс для избранных рецептов
    _favoritesBox = await Hive.openBox<Meal>(_boxName);
  }

  @override
  Future<void> addToFavorites(Meal meal) async {
    try {
      await _favoritesBox.put(meal.id, meal);
    } catch (e) {
      // Если бокс не инициализирован, инициализируем его
      await init();
      await _favoritesBox.put(meal.id, meal);
    }
  }

  @override
  Future<void> removeFromFavorites(String mealId) async {
    try {
      await _favoritesBox.delete(mealId);
    } catch (e) {
      await init();
      await _favoritesBox.delete(mealId);
    }
  }

  @override
  Future<bool> isFavorite(String mealId) async {
    try {
      return _favoritesBox.containsKey(mealId);
    } catch (e) {
      await init();
      return _favoritesBox.containsKey(mealId);
    }
  }

  @override
  Future<List<Meal>> getFavorites() async {
    try {
      return _favoritesBox.values.toList();
    } catch (e) {
      await init();
      return _favoritesBox.values.toList();
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      await _favoritesBox.clear();
    } catch (e) {
      await init();
      await _favoritesBox.clear();
    }
  }

  @override
  Future<int> getFavoritesCount() async {
    try {
      return _favoritesBox.length;
    } catch (e) {
      await init();
      return _favoritesBox.length;
    }
  }

  /// Получить поток изменений избранных рецептов
  Stream<List<Meal>> get favoritesStream {
    try {
      return _favoritesBox.watch().map((_) => _favoritesBox.values.toList());
    } catch (e) {
      return Stream.value(<Meal>[]);
    }
  }

  /// Закрыть бокс (вызывать при завершении работы приложения)
  Future<void> dispose() async {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        await _favoritesBox.close();
      }
    } catch (e) {
      // Игнорируем ошибки при закрытии
    }
  }
}
