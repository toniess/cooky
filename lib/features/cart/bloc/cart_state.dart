import 'package:cooky/core/models/models.dart';

/// Базовый класс для состояний корзины
abstract class CartState {
  const CartState();
}

/// Начальное состояние
class CartInitial extends CartState {
  const CartInitial();
}

/// Загрузка корзины
class CartLoading extends CartState {
  const CartLoading();
}

/// Корзина загружена
class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded(this.cart);
}

/// Корзина пуста
class CartEmpty extends CartState {
  const CartEmpty();
}

/// Ошибка загрузки корзины
class CartError extends CartState {
  final String message;

  const CartError(this.message);
}
