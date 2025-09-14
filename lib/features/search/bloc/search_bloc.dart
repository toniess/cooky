import 'dart:async';

import 'package:cooky/core/models/meal.dart';
import 'package:cooky/core/services/meal_db/abstract_meal_db_service.dart';
import 'package:cooky/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final AbstractMealDbService _mealDbService;
  Timer? _debounceTimer;

  SearchBloc({AbstractMealDbService? mealDbService})
    : _mealDbService = mealDbService ?? getIt.get<AbstractMealDbService>(),
      super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchCleared>(_onSearchCleared);
    on<SearchFiltersChanged>(_onSearchFiltersChanged);
    on<SearchFiltersCleared>(_onSearchFiltersCleared);
    on<SearchLoadMore>(_onSearchLoadMore);
    on<SearchInitialized>(_onSearchInitialized);
    on<LoadRandomRecipes>(_onLoadRandomRecipes);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (event.query.trim().isEmpty) {
        add(SearchCleared());
      } else {
        add(SearchSubmitted(event.query));
      }
    });
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(SearchLoading(event.query));

      final currentState = state;
      SearchFilters filters = const SearchFilters();

      if (currentState is SearchResults) {
        filters = currentState.filters;
      } else if (currentState is SearchEmpty) {
        filters = currentState.filters;
      }

      final recipes = await _performSearch(event.query, filters);

      if (recipes.isEmpty) {
        emit(SearchEmpty(query: event.query, filters: filters));
      } else {
        emit(
          SearchResults(
            recipes: recipes,
            query: event.query,
            filters: filters,
            hasMore:
                recipes.length >= 20, // Assuming API returns 20 items per page
          ),
        );
      }
    } catch (e) {
      talker.error('Search error: $e');
      emit(SearchError('Failed to search recipes: ${e.toString()}'));
    }
  }

  Future<void> _onSearchCleared(
    SearchCleared event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is SearchResults) {
      // If there are active filters, show filtered results without search query
      if (currentState.filters.hasActiveFilters) {
        final recipes = await _performSearch('', currentState.filters);
        if (recipes.isEmpty) {
          emit(SearchEmpty(query: '', filters: currentState.filters));
        } else {
          emit(
            SearchResults(
              recipes: recipes,
              query: '',
              filters: currentState.filters,
              hasMore: recipes.length >= 20,
            ),
          );
        }
      } else {
        // No filters, go to initial state
        emit(SearchInitial());
      }
    } else if (currentState is SearchEmpty) {
      // If there are active filters, show filtered results without search query
      if (currentState.filters.hasActiveFilters) {
        final recipes = await _performSearch('', currentState.filters);
        if (recipes.isEmpty) {
          emit(SearchEmpty(query: '', filters: currentState.filters));
        } else {
          emit(
            SearchResults(
              recipes: recipes,
              query: '',
              filters: currentState.filters,
              hasMore: recipes.length >= 20,
            ),
          );
        }
      } else {
        // No filters, go to initial state
        emit(SearchInitial());
      }
    } else {
      emit(SearchInitial());
    }
  }

  Future<void> _onSearchFiltersChanged(
    SearchFiltersChanged event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final currentState = state;
      String query = '';

      if (currentState is SearchResults) {
        query = currentState.query;
      } else if (currentState is SearchEmpty) {
        query = currentState.query;
      }

      emit(SearchLoading(query));

      final recipes = await _performSearch(query, event.filters);

      if (recipes.isEmpty) {
        emit(SearchEmpty(query: query, filters: event.filters));
      } else {
        emit(
          SearchResults(
            recipes: recipes,
            query: query,
            filters: event.filters,
            hasMore: recipes.length >= 20,
          ),
        );
      }
    } catch (e) {
      talker.error('Search filters error: $e');
      emit(SearchError('Failed to apply filters: ${e.toString()}'));
    }
  }

  void _onSearchFiltersCleared(
    SearchFiltersCleared event,
    Emitter<SearchState> emit,
  ) {
    final currentState = state;
    if (currentState is SearchResults || currentState is SearchEmpty) {
      add(SearchFiltersChanged(const SearchFilters()));
    }
  }

  Future<void> _onSearchLoadMore(
    SearchLoadMore event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is SearchResults &&
        currentState.hasMore &&
        !currentState.isLoadingMore) {
      try {
        emit(currentState.copyWith(isLoadingMore: true));

        // Load more recipes (implement pagination logic here)
        // For now, we'll just simulate loading more
        await Future.delayed(const Duration(seconds: 1));

        // In a real implementation, you would load more recipes from the API
        emit(currentState.copyWith(isLoadingMore: false));
      } catch (e) {
        talker.error('Load more error: $e');
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  void _onSearchInitialized(
    SearchInitialized event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }

  Future<List<Meal>> _performSearch(String query, SearchFilters filters) async {
    List<Meal> recipes;

    if (query.trim().isEmpty) {
      // If search query is empty but filters are active, get all recipes
      if (filters.hasActiveFilters) {
        recipes = await _getAllRecipesWithFilters(filters);
      } else {
        // No search query and no filters - return empty list
        recipes = [];
      }
    } else {
      // Search by name first
      recipes = await _mealDbService.searchMealsByName(query);

      // If ingredients are specified, also search by ingredients and combine results
      if (filters.selectedIngredients.isNotEmpty) {
        // Convert ingredient names to Ingredient objects
        final ingredients = await _mealDbService.getIngredients();
        final selectedIngredientObjects = ingredients
            .where(
              (ingredient) =>
                  filters.selectedIngredients.contains(ingredient.name),
            )
            .toList();

        final ingredientRecipes = await _mealDbService.filterByIngredient(
          selectedIngredientObjects,
        );
        // Combine and remove duplicates
        final allRecipes = <String, Meal>{};
        for (final recipe in recipes) {
          allRecipes[recipe.id] = recipe;
        }
        for (final recipe in ingredientRecipes) {
          allRecipes[recipe.id] = recipe;
        }
        recipes = allRecipes.values.toList();
      }

      // Apply other filters (category, area)
      recipes = _applyFilters(recipes, filters);
    }

    return recipes;
  }

  Future<List<Meal>> _getAllRecipesWithFilters(SearchFilters filters) async {
    List<Meal> allRecipes = [];

    // If ingredients are specified, use API to get recipes by ingredients
    if (filters.selectedIngredients.isNotEmpty) {
      // Convert ingredient names to Ingredient objects
      final ingredients = await _mealDbService.getIngredients();
      final selectedIngredientObjects = ingredients
          .where(
            (ingredient) =>
                filters.selectedIngredients.contains(ingredient.name),
          )
          .toList();

      allRecipes = await _mealDbService.filterByIngredient(
        selectedIngredientObjects,
      );
    } else {
      // Otherwise get random recipes
      allRecipes = await _mealDbService.randomSelection();
    }

    // Apply other filters (category, area)
    allRecipes = _applyFilters(allRecipes, filters);

    return allRecipes;
  }

  List<Meal> _applyFilters(List<Meal> recipes, SearchFilters filters) {
    return recipes.where((recipe) {
      // Category filter
      if (filters.selectedCategories.isNotEmpty &&
          !filters.selectedCategories.contains(recipe.category)) {
        return false;
      }

      // Area filter
      if (filters.selectedAreas.isNotEmpty &&
          !filters.selectedAreas.contains(recipe.area)) {
        return false;
      }

      // Note: Ingredients filter is now handled by API in _getAllRecipesWithFilters
      // and _performSearch, so we don't need to filter by ingredients here

      return true;
    }).toList();
  }

  Future<void> _onLoadRandomRecipes(
    LoadRandomRecipes event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading(''));

    try {
      final recipes = await _mealDbService.randomSelection();
      final filters = const SearchFilters();

      if (recipes.isEmpty) {
        emit(SearchEmpty(query: '', filters: filters));
      } else {
        emit(SearchResults(recipes: recipes, query: '', filters: filters));
      }
    } catch (e) {
      emit(SearchError('Failed to load random recipes: $e'));
    }
  }
}
