import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_event.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_state.dart';
import 'package:cooky/features/recipes_home/ui/ui.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final recipesBloc = context.read<RecipesBloc>();
    recipesBloc.add(RecipesLoad());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent + 100) {
        recipesBloc.add(RecipesLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipesBloc = context.read<RecipesBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: AppColors.accentBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/search'),
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.transparent,
        color: AppColors.accentBrown,
        elevation: 0,
        onRefresh: () async {
          final recipesBloc = context.read<RecipesBloc>();
          recipesBloc.add(RecipesRefresh());
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Featured recipes section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Recipes',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.neutralGrayDark,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Recipes list
            BlocBuilder<RecipesBloc, RecipesState>(
              bloc: recipesBloc,
              builder: (context, state) {
                if (state.isLoading && state.recipes.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentBrown,
                        ),
                      ),
                    ),
                  );
                }

                if (state.hasError) {
                  return SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppColors.neutralGrayMedium,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(color: AppColors.neutralGrayDark),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please try again',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.neutralGrayMedium,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverList.builder(
                  itemCount: state.recipes.length,
                  itemBuilder: (context, index) {
                    final meal = state.recipes[index];
                    return RecipeBigCard(meal: meal);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
