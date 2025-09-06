import 'package:cooky/core/models/meal.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  final Meal meal;

  const AddToCartButton({super.key, required this.meal});

  void _addToCart(BuildContext context) {
    // TODO: Implement add to cart functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to cart!'),
        backgroundColor: AppColors.accentBrown,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      child: const Icon(Icons.shopping_cart_rounded, size: 24),
    );
  }
}
