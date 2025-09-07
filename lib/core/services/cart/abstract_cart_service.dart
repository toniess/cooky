import 'package:cooky/core/models/models.dart';

/// Абстрактный интерфейс для работы с корзиной
abstract class AbstractCartService {
  /// Инициализация сервиса
  Future<void> init();

  /// Добавить товар в корзину
  Future<void> addToCart(CartItem item);

  /// Удалить товар из корзины
  Future<void> removeFromCart(String itemId);

  /// Обновить количество товара в корзине
  Future<void> updateItemQuantity(String itemId, int quantity);

  /// Получить все товары в корзине
  Future<List<CartItem>> getCartItems();

  /// Получить корзину
  Future<Cart> getCart();

  /// Очистить корзину
  Future<void> clearCart();

  /// Получить количество товаров в корзине
  Future<int> getCartItemsCount();

  /// Проверить, есть ли товар в корзине
  Future<bool> isInCart(String itemId);

  /// Получить товары по рецепту
  Future<List<CartItem>> getItemsByMealId(String mealId);

  /// Удалить все товары рецепта из корзины
  Future<void> removeMealFromCart(String mealId);

  /// Поток изменений корзины
  Stream<Cart> get cartStream;
}
