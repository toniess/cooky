import 'package:cooky/core/models/models.dart';
import 'package:cooky/core/services/meal_db/abstract_meal_db_service.dart';
import 'package:cooky/core/utils/extentions.dart';
import 'package:cooky/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'filtered_recipes_event.dart';
import 'filtered_recipes_state.dart';

class FilteredRecipesBloc
    extends Bloc<FilteredRecipesEvent, FilteredRecipesState> {
  final _repository = getIt.get<AbstractMealDbService>();
  static const int _pageSize = 10;

  FilteredRecipesBloc() : super(FilteredRecipesInitial()) {
    on<FilteredRecipesLoad>(_onLoad);
    on<FilteredRecipesLoadMore>(_onLoadMore);
    on<FilteredRecipesRefresh>(_onRefresh);
    on<FilteredRecipesReset>(_onReset);
  }

  Future<void> _onLoad(
    FilteredRecipesLoad event,
    Emitter<FilteredRecipesState> emit,
  ) async {
    try {
      emit(
        FilteredRecipesLoading(
          recipes: [],
          currentPage: event.page,
          selectedCategory: event.category,
          selectedArea: event.area,
        ),
      );

      final recipes = await _repository.getFilteredRecipes(
        category: event.category,
        area: event.area,
        page: event.page,
        limit: _pageSize,
      );

      final hasMoreData = recipes.length == _pageSize;

      emit(
        FilteredRecipesLoaded(
          recipes: recipes,
          currentPage: event.page,
          hasMoreData: hasMoreData,
          selectedCategory: event.category,
          selectedArea: event.area,
        ),
      );
    } catch (e) {
      talker.error('FilteredRecipesLoad Error: $e');
      emit(
        FilteredRecipesError(
          recipes: [],
          currentPage: event.page,
          selectedCategory: event.category,
          selectedArea: event.area,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    FilteredRecipesLoadMore event,
    Emitter<FilteredRecipesState> emit,
  ) async {
    if (state.isLoading || state.hasReachedMax) {
      return;
    }

    try {
      emit(
        FilteredRecipesLoading(
          recipes: state.recipes,
          currentPage: state.currentPage,
          selectedCategory: state.selectedCategory,
          selectedArea: state.selectedArea,
        ),
      );

      final nextPage = state.currentPage + 1;
      final newRecipes = await _repository.getFilteredRecipes(
        category: event.category ?? state.selectedCategory,
        area: event.area ?? state.selectedArea,
        page: nextPage,
        limit: _pageSize,
      );

      if (newRecipes.isEmpty) {
        emit(
          FilteredRecipesLoaded(
            recipes: state.recipes,
            currentPage: state.currentPage,
            hasMoreData: false,
            selectedCategory: state.selectedCategory,
            selectedArea: state.selectedArea,
          ),
        );
      } else {
        final allRecipes = [...state.recipes, ...newRecipes];
        final hasMoreData = newRecipes.length == _pageSize;

        emit(
          FilteredRecipesLoaded(
            recipes: allRecipes,
            currentPage: nextPage,
            hasMoreData: hasMoreData,
            selectedCategory: state.selectedCategory,
            selectedArea: state.selectedArea,
          ),
        );
      }
    } catch (e) {
      talker.error('FilteredRecipesLoadMore Error: $e');
      emit(
        FilteredRecipesError(
          recipes: state.recipes,
          currentPage: state.currentPage,
          selectedCategory: state.selectedCategory,
          selectedArea: state.selectedArea,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefresh(
    FilteredRecipesRefresh event,
    Emitter<FilteredRecipesState> emit,
  ) async {
    try {
      emit(
        FilteredRecipesLoading(
          recipes: state.recipes,
          currentPage: 1,
          selectedCategory: event.category,
          selectedArea: event.area,
        ),
      );

      final recipes = await _repository.getFilteredRecipes(
        category: event.category,
        area: event.area,
        page: 1,
        limit: _pageSize,
      );

      final hasMoreData = recipes.length == _pageSize;

      emit(
        FilteredRecipesLoaded(
          recipes: recipes,
          currentPage: 1,
          hasMoreData: hasMoreData,
          selectedCategory: event.category,
          selectedArea: event.area,
        ),
      );
    } catch (e) {
      talker.error('FilteredRecipesRefresh Error: $e');
      emit(
        FilteredRecipesError(
          recipes: state.recipes,
          currentPage: 1,
          selectedCategory: event.category,
          selectedArea: event.area,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onReset(
    FilteredRecipesReset event,
    Emitter<FilteredRecipesState> emit,
  ) async {
    emit(FilteredRecipesInitial());
  }

  MealShort? getMealById(String id) {
    return state.recipes.firstWhereOrNull((meal) => meal.id == id);
  }

  bool get canLoadMore => !state.isLoading && !state.hasReachedMax;
}
