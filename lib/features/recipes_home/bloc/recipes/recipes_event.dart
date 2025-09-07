abstract class RecipesEvent {}

class RecipesLoad extends RecipesEvent {}

class RecipesRefresh extends RecipesEvent {}

class RecipesLoadMore extends RecipesEvent {}

class RecipesSearch extends RecipesEvent {
  final String query;

  RecipesSearch(this.query);
}

class RecipesClearSearch extends RecipesEvent {}

class RecipesFilterByCategory extends RecipesEvent {
  final String categoryId;

  RecipesFilterByCategory(this.categoryId);
}

class RecipesFilterByArea extends RecipesEvent {
  final String areaName;

  RecipesFilterByArea(this.areaName);
}
