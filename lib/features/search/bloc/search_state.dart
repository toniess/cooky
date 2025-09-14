import 'package:cooky/core/models/meal.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  final String query;
  SearchLoading(this.query);
}

class SearchResults extends SearchState {
  final List<Meal> recipes;
  final String query;
  final SearchFilters filters;
  final bool hasMore;
  final bool isLoadingMore;

  SearchResults({
    required this.recipes,
    required this.query,
    required this.filters,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  SearchResults copyWith({
    List<Meal>? recipes,
    String? query,
    SearchFilters? filters,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SearchResults(
      recipes: recipes ?? this.recipes,
      query: query ?? this.query,
      filters: filters ?? this.filters,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

class SearchEmpty extends SearchState {
  final String query;
  final SearchFilters filters;
  SearchEmpty({required this.query, required this.filters});
}

class SearchFilters {
  final List<String> selectedCategories;
  final List<String> selectedAreas;
  final List<String> selectedIngredients;

  const SearchFilters({
    this.selectedCategories = const [],
    this.selectedAreas = const [],
    this.selectedIngredients = const [],
  });

  SearchFilters copyWith({
    List<String>? selectedCategories,
    List<String>? selectedAreas,
    List<String>? selectedIngredients,
  }) {
    return SearchFilters(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedAreas: selectedAreas ?? this.selectedAreas,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
    );
  }

  bool get hasActiveFilters {
    return selectedCategories.isNotEmpty ||
        selectedAreas.isNotEmpty ||
        selectedIngredients.isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchFilters &&
        other.selectedCategories.length == selectedCategories.length &&
        other.selectedAreas.length == selectedAreas.length &&
        other.selectedIngredients.length == selectedIngredients.length;
  }

  @override
  int get hashCode {
    return selectedCategories.hashCode ^
        selectedAreas.hashCode ^
        selectedIngredients.hashCode;
  }
}
