import 'package:cooky/core/models/models.dart';
import 'package:cooky/core/services/cart/abstract_cart_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Сервис для работы с корзиной с использованием Hive
class CartService implements AbstractCartService {
  static const String _boxName = 'cart_box';
  late Box<CartItem> _cartBox;

  @override
  Future<void> init() async {
    // Проверяем, не инициализирован ли уже бокс
    if (Hive.isBoxOpen(_boxName)) {
      _cartBox = Hive.box<CartItem>(_boxName);
      return;
    }

    // Регистрируем адаптеры
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CartItemAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CartAdapter());
    }

    // Открываем бокс для корзины
    _cartBox = await Hive.openBox<CartItem>(_boxName);
  }

  @override
  Future<void> addToCart(CartItem item) async {
    try {
      // Просто добавляем/обновляем товар в корзине
      await _cartBox.put(item.id, item);
    } catch (e) {
      // Если бокс не инициализирован, инициализируем его
      await init();
      await addToCart(item);
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    try {
      await _cartBox.delete(itemId);
    } catch (e) {
      await init();
      await _cartBox.delete(itemId);
    }
  }

  @override
  Future<void> updateItemQuantity(String itemId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(itemId);
        return;
      }

      final item = _cartBox.get(itemId);
      if (item != null) {
        final updatedItem = item.copyWith(quantity: quantity);
        await _cartBox.put(itemId, updatedItem);
      }
    } catch (e) {
      await init();
      await updateItemQuantity(itemId, quantity);
    }
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      return _cartBox.values.map((item) => _migrateCartItem(item)).toList();
    } catch (e) {
      await init();
      return _cartBox.values.map((item) => _migrateCartItem(item)).toList();
    }
  }

  /// Миграция старых записей CartItem для добавления поля isPurchased
  CartItem _migrateCartItem(CartItem item) {
    // Возвращаем товар как есть, так как поле isPurchased уже имеет значение по умолчанию
    return item;
  }

  @override
  Future<Cart> getCart() async {
    try {
      final items = _cartBox.values
          .map((item) => _migrateCartItem(item))
          .toList();
      return Cart(items: items);
    } catch (e) {
      await init();
      final items = _cartBox.values
          .map((item) => _migrateCartItem(item))
          .toList();
      return Cart(items: items);
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _cartBox.clear();
    } catch (e) {
      await init();
      await _cartBox.clear();
    }
  }

  @override
  Future<int> getCartItemsCount() async {
    try {
      final items = _cartBox.values.toList();
      int total = 0;
      for (final item in items) {
        total += item.quantity;
      }
      return total;
    } catch (e) {
      await init();
      final items = _cartBox.values.toList();
      int total = 0;
      for (final item in items) {
        total += item.quantity;
      }
      return total;
    }
  }

  @override
  Future<bool> isInCart(String itemId) async {
    try {
      return _cartBox.containsKey(itemId);
    } catch (e) {
      await init();
      return _cartBox.containsKey(itemId);
    }
  }

  @override
  Future<List<CartItem>> getItemsByMealId(String mealId) async {
    try {
      return _cartBox.values
          .where((item) => item.mealId == mealId)
          .map((item) => _migrateCartItem(item))
          .toList();
    } catch (e) {
      await init();
      return _cartBox.values
          .where((item) => item.mealId == mealId)
          .map((item) => _migrateCartItem(item))
          .toList();
    }
  }

  @override
  Future<void> removeMealFromCart(String mealId) async {
    try {
      final itemsToRemove = _cartBox.values
          .where((item) => item.mealId == mealId)
          .map((item) => item.id)
          .toList();

      for (final itemId in itemsToRemove) {
        await _cartBox.delete(itemId);
      }
    } catch (e) {
      await init();
      await removeMealFromCart(mealId);
    }
  }

  /// Получить поток изменений корзины
  @override
  Stream<Cart> get cartStream {
    try {
      return _cartBox.watch().map((_) {
        final items = _cartBox.values
            .map((item) => _migrateCartItem(item))
            .toList();
        return Cart(items: items);
      });
    } catch (e) {
      return Stream.value(Cart(items: []));
    }
  }

  /// Закрыть бокс (вызывать при завершении работы приложения)
  Future<void> dispose() async {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        await _cartBox.close();
      }
    } catch (e) {
      // Игнорируем ошибки при закрытии
    }
  }
}
