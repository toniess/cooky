import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {
  /// Получает правильный путь к рецепту в зависимости от текущего таба
  static String getRecipePath(BuildContext context, String recipeId) {
    final currentPath = GoRouterState.of(context).uri.path;

    if (currentPath.startsWith('/favorites')) {
      return '/favorites/recipe/$recipeId';
    } else if (currentPath.startsWith('/recipes')) {
      return '/recipes/recipe/$recipeId';
    } else if (currentPath.startsWith('/cart')) {
      return '/cart/recipe/$recipeId';
    } else if (currentPath.startsWith('/settings')) {
      return '/settings/recipe/$recipeId';
    }

    // По умолчанию используем recipes таб
    return '/recipes/recipe/$recipeId';
  }
}
