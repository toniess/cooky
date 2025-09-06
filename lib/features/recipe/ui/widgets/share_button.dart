import 'package:cooky/core/models/meal.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final Meal meal;

  const ShareButton({super.key, required this.meal});

  void _shareRecipe(BuildContext context) {
    final shareText =
        '''
🍽️ ${meal.name}

${meal.category.isNotEmpty ? 'Category: ${meal.category}' : ''}
${meal.area.isNotEmpty ? 'Cuisine: ${meal.area}' : ''}

${meal.instructions.isNotEmpty ? 'Instructions:\n${meal.instructions}' : ''}

Check out this delicious recipe! 🍴
''';

    Share.share(shareText, subject: 'Delicious Recipe: ${meal.name}');
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _shareRecipe(context),
      backgroundColor: Colors.white,
      foregroundColor: AppColors.accentBrown,
      elevation: 0,
      child: const Icon(Icons.share_rounded, size: 24),
    );
  }
}
