import 'package:cooky/core/models/models.dart';

abstract class FilteredRecipesState {
  final List<MealShort> recipes;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasError;
  final bool hasReachedMax;
  final int currentPage;
  final Category? selectedCategory;
  final Area? selectedArea;

  FilteredRecipesState({
    required this.recipes,
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasError = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.selectedCategory,
    this.selectedArea,
  });
}

class FilteredRecipesInitial extends FilteredRecipesState {
  FilteredRecipesInitial() : super(recipes: []);
}

class FilteredRecipesLoading extends FilteredRecipesState {
  FilteredRecipesLoading({
    required super.recipes,
    required super.currentPage,
    super.selectedCategory,
    super.selectedArea,
  }) : super(isLoading: true);
}

class FilteredRecipesLoaded extends FilteredRecipesState {
  final bool hasMoreData;

  FilteredRecipesLoaded({
    required super.recipes,
    required super.currentPage,
    required this.hasMoreData,
    super.selectedCategory,
    super.selectedArea,
  }) : super(
         isLoading: false,
         isRefreshing: false,
         hasError: false,
         hasReachedMax: !hasMoreData,
       );
}

class FilteredRecipesError extends FilteredRecipesState {
  final String? errorMessage;

  FilteredRecipesError({
    required super.recipes,
    required super.currentPage,
    super.selectedCategory,
    super.selectedArea,
    this.errorMessage,
  }) : super(hasError: true);
}
