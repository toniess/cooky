import 'package:cooky/features/filters/bloc/bloc.dart';
import 'package:cooky/features/filters/ui/filter_chip.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_event.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiltersSection extends StatelessWidget {
  const FiltersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltersBloc, FiltersState>(
      builder: (context, state) {
        if (state is FiltersLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is FiltersError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                style: TextStyle(color: AppColors.neutralGrayMedium),
              ),
            ),
          );
        }

        if (state is! FiltersLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories section
            if (state.categories.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.neutralGrayDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    final isSelected = state.selectedCategoryId == category.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CustomFilterChip(
                        label: category.name,
                        isSelected: isSelected,
                        onTap: () {
                          context.read<FiltersBloc>().add(
                            SelectCategory(isSelected ? null : category.id),
                          );
                          if (!isSelected) {
                            context.read<RecipesBloc>().add(
                              RecipesFilterByCategory(category.id),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],

            // Areas section
            if (state.areas.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Regions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.neutralGrayDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.areas.length,
                  itemBuilder: (context, index) {
                    final area = state.areas[index];
                    final isSelected = state.selectedAreaName == area.name;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CustomFilterChip(
                        label: area.name,
                        isSelected: isSelected,
                        onTap: () {
                          context.read<FiltersBloc>().add(
                            SelectArea(isSelected ? null : area.name),
                          );
                          if (!isSelected) {
                            context.read<RecipesBloc>().add(
                              RecipesFilterByArea(area.name),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],

            // Clear filters button
            if (state.selectedCategoryId != null ||
                state.selectedAreaName != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextButton.icon(
                  onPressed: () {
                    context.read<FiltersBloc>().add(ClearFilters());
                    context.read<RecipesBloc>().add(RecipesClearSearch());
                  },
                  icon: Icon(
                    Icons.clear,
                    size: 16,
                    color: AppColors.neutralGrayMedium,
                  ),
                  label: Text(
                    'Clear filters',
                    style: TextStyle(
                      color: AppColors.neutralGrayMedium,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
