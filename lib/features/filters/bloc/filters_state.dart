import 'package:cooky/core/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class FiltersState extends Equatable {
  const FiltersState();

  @override
  List<Object?> get props => [];
}

class FiltersInitial extends FiltersState {}

class FiltersLoading extends FiltersState {}

class FiltersLoaded extends FiltersState {
  final List<Category> categories;
  final List<Area> areas;
  final String? selectedCategoryId;
  final String? selectedAreaName;

  const FiltersLoaded({
    required this.categories,
    required this.areas,
    this.selectedCategoryId,
    this.selectedAreaName,
  });

  @override
  List<Object?> get props => [
    categories,
    areas,
    selectedCategoryId,
    selectedAreaName,
  ];

  FiltersLoaded copyWith({
    List<Category>? categories,
    List<Area>? areas,
    String? selectedCategoryId,
    String? selectedAreaName,
  }) {
    return FiltersLoaded(
      categories: categories ?? this.categories,
      areas: areas ?? this.areas,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedAreaName: selectedAreaName ?? this.selectedAreaName,
    );
  }
}

class FiltersError extends FiltersState {
  final String message;

  const FiltersError(this.message);

  @override
  List<Object> get props => [message];
}
