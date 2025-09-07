import 'package:cooky/core/services/meal_db/abstract_meal_db_service.dart';
import 'package:cooky/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'filters_event.dart';
import 'filters_state.dart';

class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
  final _repository = getIt.get<AbstractMealDbService>();

  FiltersBloc() : super(FiltersInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadAreas>(_onLoadAreas);
    on<SelectCategory>(_onSelectCategory);
    on<SelectArea>(_onSelectArea);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<FiltersState> emit,
  ) async {
    try {
      final categories = await _repository.getCategories();
      final currentState = state;
      if (currentState is FiltersLoaded) {
        emit(currentState.copyWith(categories: categories));
      } else {
        emit(FiltersLoaded(categories: categories, areas: []));
      }
    } catch (e) {
      talker.error('LoadCategories error: $e');
      emit(FiltersError('Failed to load categories'));
    }
  }

  Future<void> _onLoadAreas(LoadAreas event, Emitter<FiltersState> emit) async {
    try {
      final areas = await _repository.getAreas();
      final currentState = state;
      if (currentState is FiltersLoaded) {
        emit(currentState.copyWith(areas: areas));
      } else {
        emit(FiltersLoaded(categories: [], areas: areas));
      }
    } catch (e) {
      talker.error('LoadAreas error: $e');
      emit(FiltersError('Failed to load areas'));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<FiltersState> emit) {
    final currentState = state;
    if (currentState is FiltersLoaded) {
      emit(currentState.copyWith(selectedCategoryId: event.categoryId));
    }
  }

  void _onSelectArea(SelectArea event, Emitter<FiltersState> emit) {
    final currentState = state;
    if (currentState is FiltersLoaded) {
      emit(currentState.copyWith(selectedAreaName: event.areaName));
    }
  }

  void _onClearFilters(ClearFilters event, Emitter<FiltersState> emit) {
    final currentState = state;
    if (currentState is FiltersLoaded) {
      emit(
        currentState.copyWith(selectedCategoryId: null, selectedAreaName: null),
      );
    }
  }
}
