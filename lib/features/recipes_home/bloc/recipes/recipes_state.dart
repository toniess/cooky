import 'package:cooky/core/models/meal.dart';

abstract class RecipesState {
  final List<Meal> recipes;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasError;
  final String? searchQuery;
  final bool isSearching;

  RecipesState({
    required this.recipes,
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasError = false,
    this.searchQuery,
    this.isSearching = false,
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

class RecipesSearching extends RecipesState {
  RecipesSearching({required super.recipes, required super.searchQuery})
    : super(isSearching: true);
}

class RecipesSearchResults extends RecipesState {
  RecipesSearchResults({required super.recipes, required super.searchQuery})
    : super(isSearching: false);
}
