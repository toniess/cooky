import 'package:cooky/core/models/models.dart';
import 'package:cooky/core/services/cart/abstract_cart_service.dart';
import 'package:cooky/features/cart/bloc/cart_event.dart';
import 'package:cooky/features/cart/bloc/cart_state.dart';
import 'package:cooky/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC для управления корзиной
class CartBloc extends Bloc<CartEvent, CartState> {
  final AbstractCartService _cartService;

  CartBloc(this._cartService) : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<ClearCart>(_onClearCart);
    on<AddMealIngredientsToCart>(_onAddMealIngredientsToCart);
    on<RemoveMealFromCart>(_onRemoveMealFromCart);
    on<ToggleItemPurchased>(_onToggleItemPurchased);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(const CartLoading());
      await _cartService.init();
      final cart = await _cartService.getCart();

      if (cart.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart));
      }
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.addToCart(event.item);

      // Обновляем текущее состояние
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        final updatedCart = currentState.cart.addItem(event.item);
        emit(CartLoaded(updatedCart));
      } else if (state is CartEmpty) {
        // Если корзина была пуста, создаем новую корзину
        final newCart = Cart.empty().addItem(event.item);
        emit(CartLoaded(newCart));
      } else {
        // Если состояние не определено, перезагружаем
        final cart = await _cartService.getCart();
        emit(CartLoaded(cart));
      }
    } catch (e) {
      emit(CartError('Failed to add item to cart: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartService.removeFromCart(event.itemId);

      // Обновляем текущее состояние
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        final updatedCart = currentState.cart.removeItem(event.itemId);

        if (updatedCart.isEmpty) {
          emit(const CartEmpty());
        } else {
          emit(CartLoaded(updatedCart));
        }
      } else {
        // Если состояние не определено, перезагружаем
        final cart = await _cartService.getCart();
        if (cart.isEmpty) {
          emit(const CartEmpty());
        } else {
          emit(CartLoaded(cart));
        }
      }
    } catch (e) {
      emit(CartError('Failed to remove item from cart: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartService.updateItemQuantity(event.itemId, event.quantity);
      final cart = await _cartService.getCart();

      if (cart.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart));
      }
    } catch (e) {
      emit(CartError('Failed to update item quantity: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.clearCart();
      emit(const CartEmpty());
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddMealIngredientsToCart(
    AddMealIngredientsToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Добавляем все ингредиенты рецепта в корзину
      Cart currentCart = state is CartLoaded
          ? (state as CartLoaded).cart
          : Cart.empty();

      for (final ingredient in event.meal.ingredients) {
        final cartItem = CartItem(
          id: '${event.meal.id}_${ingredient.name}',
          name: ingredient.name,
          measure: ingredient.measure,
          imageUrl: ingredient.imageUrl,
          quantity: 1,
          mealId: event.meal.id,
          mealName: event.meal.name,
        );
        await _cartService.addToCart(cartItem);
        currentCart = currentCart.addItem(cartItem);
      }

      emit(CartLoaded(currentCart));
    } catch (e) {
      emit(
        CartError('Failed to add meal ingredients to cart: ${e.toString()}'),
      );
    }
  }

  Future<void> _onRemoveMealFromCart(
    RemoveMealFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartService.removeMealFromCart(event.mealId);
      final cart = await _cartService.getCart();

      if (cart.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart));
      }
    } catch (e) {
      emit(CartError('Failed to remove meal from cart: ${e.toString()}'));
    }
  }

  Future<void> _onToggleItemPurchased(
    ToggleItemPurchased event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Обновляем текущее состояние напрямую
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        final item = currentState.cart.getItemById(event.itemId);

        if (item != null) {
          final updatedItem = item.copyWith(isPurchased: !item.isPurchased);

          // Обновляем товар в сервисе
          await _cartService.addToCart(updatedItem);

          // Обновляем корзину в состоянии
          final updatedItems = currentState.cart.items.map((cartItem) {
            if (cartItem.id == event.itemId) {
              return updatedItem;
            }
            return cartItem;
          }).toList();

          final updatedCart = Cart(items: updatedItems);
          talker.debug(
            '🛒 Cart updated, total items: ${updatedCart.items.length}',
          );
          emit(CartLoaded(updatedCart));
        } else {
          talker.debug('🛒 Item not found: ${event.itemId}');
        }
      } else {
        // Если состояние не определено, перезагружаем
        final cart = await _cartService.getCart();
        final item = cart.getItemById(event.itemId);

        if (item != null) {
          final updatedItem = item.copyWith(isPurchased: !item.isPurchased);
          await _cartService.addToCart(updatedItem);
          final updatedCart = await _cartService.getCart();
          emit(CartLoaded(updatedCart));
        }
      }
    } catch (e) {
      talker.handle(e);
      emit(
        CartError('Failed to toggle item purchased status: ${e.toString()}'),
      );
    }
  }
}
