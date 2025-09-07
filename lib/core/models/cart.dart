import 'package:hive/hive.dart';

import 'cart_item.dart';

part 'cart.g.dart';

@HiveType(typeId: 4)
class Cart extends HiveObject {
  @HiveField(0)
  final List<CartItem> items;

  Cart({required this.items});

  Cart.empty() : items = [];

  /// Получить общее количество товаров в корзине
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Получить количество уникальных товаров
  int get uniqueItemsCount => items.length;

  /// Проверить, пуста ли корзина
  bool get isEmpty => items.isEmpty;

  /// Проверить, не пуста ли корзина
  bool get isNotEmpty => items.isNotEmpty;

  /// Добавить товар в корзину
  Cart addItem(CartItem item) {
    final existingItemIndex = items.indexWhere(
      (existingItem) => existingItem.id == item.id,
    );

    if (existingItemIndex != -1) {
      // Если товар уже есть, увеличиваем количество
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex]
          .copyWith(
            quantity: updatedItems[existingItemIndex].quantity + item.quantity,
          );
      return Cart(items: updatedItems);
    } else {
      // Если товара нет, добавляем новый
      return Cart(items: [...items, item]);
    }
  }

  /// Удалить товар из корзины
  Cart removeItem(String itemId) {
    return Cart(items: items.where((item) => item.id != itemId).toList());
  }

  /// Обновить количество товара
  Cart updateItemQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      return removeItem(itemId);
    }

    final updatedItems = items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    return Cart(items: updatedItems);
  }

  /// Очистить корзину
  Cart clear() {
    return Cart(items: []);
  }

  /// Получить товар по ID
  CartItem? getItemById(String itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  /// Проверить, есть ли товар в корзине
  bool containsItem(String itemId) {
    return items.any((item) => item.id == itemId);
  }

  /// Получить товары по рецепту
  List<CartItem> getItemsByMealId(String mealId) {
    return items.where((item) => item.mealId == mealId).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cart &&
        other.items.length == items.length &&
        other.items.every((item) => items.contains(item));
  }

  @override
  int get hashCode => items.hashCode;

  @override
  String toString() {
    return 'Cart(items: ${items.length}, totalItems: $totalItems)';
  }
}
