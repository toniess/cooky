import 'dart:async';

import 'package:cooky/features/filters/filters.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_event.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_state.dart';
import 'package:cooky/features/recipes_home/ui/recipes_big_card.dart';
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
                hintText: 'Search for recipes...',
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
                          context.read<RecipesBloc>().add(RecipesClearSearch());
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
                    context.read<RecipesBloc>().add(RecipesClearSearch());
                  } else {
                    context.read<RecipesBloc>().add(RecipesSearch(query));
                  }
                });
              },
            ),
          ),
          // Filters section
          const FiltersSection(),
          // Search results
          Expanded(
            child: BlocBuilder<RecipesBloc, RecipesState>(
              builder: (context, state) {
                if (state.isSearching) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.accentBrown),
                        const SizedBox(height: 16),
                        Text(
                          'Searching for "${state.searchQuery}"...',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.neutralGrayMedium),
                        ),
                      ],
                    ),
                  );
                }

                if (state is RecipesSearchResults && state.recipes.isEmpty) {
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
                          'Try searching for something else',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.neutralGrayMedium),
                        ),
                      ],
                    ),
                  );
                }

                if (state is RecipesSearchResults) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.recipes.length,
                    itemBuilder: (context, index) {
                      final meal = state.recipes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RecipeBigCard(meal: meal),
                      );
                    },
                  );
                }

                // Initial state - show search hint
                return Center(
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
                        'Search for recipes',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: AppColors.neutralGrayDark),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter a recipe name to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.neutralGrayMedium,
                        ),
                      ),
                    ],
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
