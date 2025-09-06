import 'package:cooky/core/models/meal.dart';
import 'package:cooky/features/recipe/ui/widgets/ingredient_card.dart';
import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:flutter/material.dart';

class IngredientsSection extends StatelessWidget {
  final List<MealIngredient> ingredients;

  const IngredientsSection({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 16),
        _buildIngredientsGrid(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentBrown.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.restaurant, color: AppColors.accentBrown, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'Ingredients',
          style: AppTextStyles.heading(context).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.neutralGrayDark,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsGrid(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return IngredientCard(ingredient: ingredients[index]);
      },
    );
  }
}
