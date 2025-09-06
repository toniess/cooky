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
        final recipes = await _repository.randomSelection();
        emit(RecipesLoaded(recipes: recipes));
      } catch (e) {
        talker.error('RecipesError: $e');
        emit(RecipesError());
      }
    });

    on<RecipesRefresh>((event, emit) async {
      emit(RecipesLoading(recipes: state.recipes));
      try {
        final recipes = await _repository.randomSelection();
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
