import 'dart:async';

import 'package:cooky/core/models/meal.dart';
import 'package:cooky/features/recipe/ui/recepes_mini_card.dart';
import 'package:cooky/features/search/bloc/search_bloc.dart';
import 'package:cooky/features/search/bloc/search_event.dart';
import 'package:cooky/features/search/bloc/search_state.dart';
import 'package:cooky/features/search/ui/filters_screen.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  SearchFilters _getCurrentFilters(SearchState currentState) {
    if (currentState is SearchResults) {
      return currentState.filters;
    } else if (currentState is SearchEmpty) {
      return currentState.filters;
    }
    return const SearchFilters();
  }

  void _showFiltersScreen(BuildContext context, SearchState currentState) {
    final currentFilters = _getCurrentFilters(currentState);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FiltersScreen(
          initialFilters: currentFilters,
          onFiltersChanged: (newFilters) {
            context.read<SearchBloc>().add(SearchFiltersChanged(newFilters));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Recipes',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.neutralGrayDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.neutralGrayDark,
        centerTitle: true,
        elevation: 0,
        actions: [
          // Filters button
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              final hasActiveFilters = state is SearchResults
                  ? state.filters.hasActiveFilters
                  : state is SearchEmpty
                  ? state.filters.hasActiveFilters
                  : false;

              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.filter_list),
                    if (hasActiveFilters)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.accentBrown,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _showFiltersScreen(context, state),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                hintText: 'Search recipes...',
                hintStyle: TextStyle(color: AppColors.neutralGrayMedium),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.neutralGrayDark,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.neutralGrayDark,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          context.read<SearchBloc>().add(SearchCleared());
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (query) {
                setState(() {});
                _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                  if (query.trim().isEmpty) {
                    context.read<SearchBloc>().add(SearchCleared());
                  } else {
                    context.read<SearchBloc>().add(SearchQueryChanged(query));
                  }
                });
              },
            ),
          ),
          // Search results
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentBrown,
                    ),
                  );
                }

                if (state is SearchEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.neutralGrayMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No recipes found',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: AppColors.neutralGrayDark),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try changing your search query or filters',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.neutralGrayMedium),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SearchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.neutralGrayMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search Error',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: AppColors.neutralGrayDark),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.neutralGrayMedium),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SearchResults) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: state.recipes.length,
                    itemBuilder: (context, index) {
                      final meal = state.recipes[index];
                      final mealShort = MealShort(
                        id: meal.id,
                        name: meal.name,
                        thumbnail: meal.thumbnail,
                      );
                      return RecepesMiniCard(meal: mealShort);
                    },
                  );
                }

                // Initial state - show search hint
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: AppColors.neutralGrayMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search Recipes',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: AppColors.neutralGrayDark),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your query',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.neutralGrayMedium),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<SearchBloc>().add(LoadRandomRecipes());
                          },
                          icon: const Icon(Icons.shuffle),
                          label: const Text('Show 10 Random Recipes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentBrown,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
