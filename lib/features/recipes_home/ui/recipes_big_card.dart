import 'package:cooky/core/models/meal.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';

class RecipeBigCard extends StatelessWidget {
  final Meal meal;
  const RecipeBigCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: _buildCardContentTest2(context),
    );
  }

  Widget _buildCardContentTest2(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            meal.thumbnail,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.neutralGrayLight,
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${meal.area} • ${meal.category}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(200),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Icon(
            Icons.favorite,
            size: 30,
            color: AppColors.neutralGrayLight,
          ),
        ),
      ],
    );
  }
}
