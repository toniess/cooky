import 'package:equatable/equatable.dart';

abstract class FiltersEvent extends Equatable {
  const FiltersEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends FiltersEvent {}

class LoadAreas extends FiltersEvent {}

class SelectCategory extends FiltersEvent {
  final String? categoryId;

  const SelectCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SelectArea extends FiltersEvent {
  final String? areaName;

  const SelectArea(this.areaName);

  @override
  List<Object?> get props => [areaName];
}

class ClearFilters extends FiltersEvent {}
