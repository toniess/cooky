import 'package:cooky/core/models/models.dart';

abstract class FilteredRecipesEvent {}

class FilteredRecipesLoad extends FilteredRecipesEvent {
  final Category? category;
  final Area? area;
  final int page;

  FilteredRecipesLoad({this.category, this.area, this.page = 1});
}

class FilteredRecipesLoadMore extends FilteredRecipesEvent {
  final Category? category;
  final Area? area;

  FilteredRecipesLoadMore({this.category, this.area});
}

class FilteredRecipesRefresh extends FilteredRecipesEvent {
  final Category? category;
  final Area? area;

  FilteredRecipesRefresh({this.category, this.area});
}

class FilteredRecipesReset extends FilteredRecipesEvent {}
