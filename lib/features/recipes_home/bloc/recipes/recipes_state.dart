import 'package:cooky/core/models/meal.dart';

abstract class RecipesState {
  final List<Meal> recipes;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasError;

  RecipesState({
    required this.recipes,
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasError = false,
  });
}

class RecipesInitial extends RecipesState {
  RecipesInitial() : super(recipes: []);
}

class RecipesLoading extends RecipesState {
  RecipesLoading({required super.recipes}) : super(isLoading: true);
}

class RecipesLoaded extends RecipesState {
  RecipesLoaded({required super.recipes})
    : super(isLoading: false, isRefreshing: false, hasError: false);
}

class RecipesError extends RecipesState {
  RecipesError() : super(recipes: [], hasError: true);
}
