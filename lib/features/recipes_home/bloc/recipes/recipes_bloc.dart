import 'package:cooky/core/models/category.dart';
import 'package:cooky/core/models/meal.dart';
import 'package:cooky/core/services/meal_db/abstract_meal_db_service.dart';
import 'package:cooky/core/utils/extentions.dart';
import 'package:cooky/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'recipes_event.dart';
import 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final _repository = getIt.get<AbstractMealDbService>();

  RecipesBloc() : super(RecipesInitial()) {
    on<RecipesLoad>((event, emit) async {
      if (state.recipes.isNotEmpty) {
        emit(RecipesLoaded(recipes: state.recipes));
        return;
      }
      try {
        final recipes = await _repository.latestRecipes();
        emit(RecipesLoaded(recipes: recipes));
      } catch (e) {
        talker.error('RecipesError: $e');
        emit(RecipesError());
      }
    });

    on<RecipesRefresh>((event, emit) async {
      emit(RecipesLoading(recipes: state.recipes));
      try {
        final recipes = await _repository.latestRecipes();
        emit(RecipesLoaded(recipes: recipes));
      } catch (e) {
        emit(RecipesError());
      }
    });

    on<RecipesLoadMore>((event, emit) async {
      if (state.isLoading) {
        return;
      }
      emit(RecipesLoading(recipes: state.recipes));
      try {
        final recipes = await _repository.randomSelection();
        emit(RecipesLoaded(recipes: [...state.recipes, ...recipes]));
      } catch (e) {
        emit(RecipesError());
      }
    });

    on<RecipesSearch>((event, emit) async {
      if (event.query.trim().isEmpty) {
        emit(RecipesLoaded(recipes: state.recipes));
        return;
      }

      emit(RecipesSearching(recipes: state.recipes, searchQuery: event.query));
      try {
        final searchResults = await _repository.searchMealsByName(event.query);
        emit(
          RecipesSearchResults(
            recipes: searchResults,
            searchQuery: event.query,
          ),
        );
      } catch (e) {
        talker.error('SearchError: $e');
        emit(RecipesError());
      }
    });

    on<RecipesClearSearch>((event, emit) async {
      emit(RecipesLoaded(recipes: state.recipes));
    });

    on<RecipesFilterByCategory>((event, emit) async {
      emit(RecipesSearching(recipes: state.recipes, searchQuery: ''));
      try {
        final categories = await _repository.getCategories();
        final category = categories.firstWhere((c) => c.id == event.categoryId);
        final filteredRecipes = await _repository.filterByCategory(category);
        emit(RecipesSearchResults(recipes: filteredRecipes, searchQuery: ''));
      } catch (e) {
        talker.error('FilterByCategory error: $e');
        emit(RecipesError());
      }
    });

    on<RecipesFilterByArea>((event, emit) async {
      emit(RecipesSearching(recipes: state.recipes, searchQuery: ''));
      try {
        final areas = await _repository.getAreas();
        final area = areas.firstWhere((a) => a.name == event.areaName);
        final filteredRecipes = await _repository.filterByArea(area);
        emit(RecipesSearchResults(recipes: filteredRecipes, searchQuery: ''));
      } catch (e) {
        talker.error('FilterByArea error: $e');
        emit(RecipesError());
      }
    });
  }

  Future<Meal?> getMealById(String id) async {
    final meal = state.recipes.firstWhereOrNull((meal) => meal.id == id);
    if (meal == null) {
      final meal = await _repository.lookupMealById(id);
      return meal;
    }
    return meal;
  }

  Future<Category> getCategoryByName(String name) {
    return _repository.getCategoryByName(name);
  }
}
