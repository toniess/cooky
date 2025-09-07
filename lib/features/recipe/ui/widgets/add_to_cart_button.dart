import 'package:cooky/core/models/meal.dart';
import 'package:cooky/features/cart/bloc/bloc.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddToCartButton extends StatelessWidget {
  final Meal meal;

  const AddToCartButton({super.key, required this.meal});

  void _addToCart(BuildContext context) {
    context.read<CartBloc>().add(AddMealIngredientsToCart(meal));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${meal.ingredients.length} ingredients to shopping list!',
        ),
        backgroundColor: AppColors.accentBrown,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'View List',
          textColor: Colors.white,
          onPressed: () {
            context.go('/cart');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'add_to_cart_button',
      onPressed: () => _addToCart(context),
      backgroundColor: AppColors.accentBrown,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.list_alt_rounded, size: 24),
    );
  }
}
