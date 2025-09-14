import 'search_state.dart';

abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SearchSubmitted extends SearchEvent {
  final String query;
  SearchSubmitted(this.query);
}

class SearchCleared extends SearchEvent {}

class SearchFiltersChanged extends SearchEvent {
  final SearchFilters filters;
  SearchFiltersChanged(this.filters);
}

class SearchFiltersCleared extends SearchEvent {}

class SearchLoadMore extends SearchEvent {}

class SearchInitialized extends SearchEvent {}

class LoadRandomRecipes extends SearchEvent {}
