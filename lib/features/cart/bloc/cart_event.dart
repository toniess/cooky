import 'package:cooky/core/models/models.dart';
import 'package:equatable/equatable.dart';

/// Базовый класс для событий корзины
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузить корзину
class LoadCart extends CartEvent {
  const LoadCart();
}

/// Добавить товар в корзину
class AddToCart extends CartEvent {
  final CartItem item;

  const AddToCart(this.item);

  @override
  List<Object?> get props => [item];
}

/// Удалить товар из корзины
class RemoveFromCart extends CartEvent {
  final String itemId;

  const RemoveFromCart(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Обновить количество товара
class UpdateItemQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateItemQuantity(this.itemId, this.quantity);

  @override
  List<Object?> get props => [itemId, quantity];
}

/// Очистить корзину
class ClearCart extends CartEvent {
  const ClearCart();
}

/// Добавить все ингредиенты рецепта в корзину
class AddMealIngredientsToCart extends CartEvent {
  final Meal meal;

  const AddMealIngredientsToCart(this.meal);

  @override
  List<Object?> get props => [meal];
}

/// Удалить все ингредиенты рецепта из корзины
class RemoveMealFromCart extends CartEvent {
  final String mealId;

  const RemoveMealFromCart(this.mealId);

  @override
  List<Object?> get props => [mealId];
}

/// Переключить статус покупки товара
class ToggleItemPurchased extends CartEvent {
  final String itemId;

  const ToggleItemPurchased(this.itemId);

  @override
  List<Object?> get props => [itemId];
}
