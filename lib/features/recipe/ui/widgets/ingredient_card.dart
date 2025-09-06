import 'package:cooky/core/models/meal.dart';
import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {
  final MealIngredient ingredient;

  const IngredientCard({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(ingredient.imageUrl),
      ),
      title: Text(ingredient.name),
      trailing: Text(ingredient.measure),
    );
  }
}
