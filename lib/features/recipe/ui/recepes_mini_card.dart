import 'package:cooky/core/models/meal.dart';
import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecepesMiniCard extends StatelessWidget {
  final MealShort meal;
  const RecepesMiniCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/recipes/${meal.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение с градиентным оверлеем
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      meal.thumbnail,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.fieldBackground,
                          child: const Icon(
                            Icons.restaurant,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  // Градиентный оверлей
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Контент
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralGrayDark,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
