import 'package:cooky/core/models/models.dart';
import 'package:equatable/equatable.dart';

/// Базовый класс для состояний корзины
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [cart];
}

/// Корзина пуста
class CartEmpty extends CartState {
  const CartEmpty();
}

/// Ошибка загрузки корзины
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
