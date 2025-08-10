import 'package:cooky/core/services/meal_db_service.dart';
import 'package:cooky/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'recipes_event.dart';
import 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final _mealDbService = getIt.get<MealDbService>();

  RecipesBloc() : super(RecipesInitial()) {
    on<RecipesLoad>((event, emit) async {
      if (state.recipes.isNotEmpty) {
        emit(RecipesLoaded(recipes: state.recipes));
        return;
      }
      try {
        final recipes = await _mealDbService.randomSelection();
        emit(RecipesLoaded(recipes: recipes));
      } catch (e) {
        talker.error('RecipesError: $e');
        emit(RecipesError());
      }
    });

    on<RecipesRefresh>((event, emit) async {
      emit(RecipesLoading(recipes: state.recipes));
      try {
        final recipes = await _mealDbService.randomSelection();
        emit(RecipesLoaded(recipes: recipes));
      } catch (e) {
        emit(RecipesError());
      }
    });
  }
}
