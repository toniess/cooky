import 'package:cooky/core/models/models.dart';
import 'package:cooky/features/recipe/bloc/filtered_recipes/filtered_recipes.dart';
import 'package:cooky/features/recipe/ui/recepes_mini_card.dart';
import 'package:cooky/main.dart';
import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredRecipesWidget extends StatefulWidget {
  final Category? category;
  final Area? area;
  final ScrollController? scrollController;

  const FilteredRecipesWidget({
    super.key,
    this.category,
    this.area,
    this.scrollController,
  });

  @override
  State<FilteredRecipesWidget> createState() => _FilteredRecipesWidgetState();
}

class _FilteredRecipesWidgetState extends State<FilteredRecipesWidget> {
  late FilteredRecipesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = FilteredRecipesBloc();

    // Добавляем слушатель прокрутки если передан ScrollController
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_onScroll);
    }

    _bloc.add(
      FilteredRecipesLoad(category: widget.category, area: widget.area),
    );
  }

  void _onScroll() {
    if (widget.scrollController != null) {
      final position = widget.scrollController!.position;
      final pixels = position.pixels;
      final maxScrollExtent = position.maxScrollExtent;
      final threshold = maxScrollExtent + 100;

      if (pixels >= threshold) {
        if (_bloc.canLoadMore) {
          talker.info('Loading more recipes...');
          _bloc.add(
            FilteredRecipesLoadMore(
              category: widget.category,
              area: widget.area,
            ),
          );
        } else {
          talker.info(
            'Cannot load more: isLoading=${_bloc.state.isLoading}, hasReachedMax=${_bloc.state.hasReachedMax}',
          );
        }
      }
    }
  }

  @override
  void dispose() {
    // Удаляем слушатель прокрутки если он был добавлен
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_onScroll);
    }
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentBrown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.receipt,
                color: AppColors.accentBrown,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'See also',
              style: AppTextStyles.heading(context).copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralGrayDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        BlocProvider.value(
          value: _bloc,
          child: BlocBuilder<FilteredRecipesBloc, FilteredRecipesState>(
            builder: (context, state) {
              if (state.isLoading && state.recipes.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state.hasError && state.recipes.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.neutralGrayMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load recipes',
                        style: AppTextStyles.body(context).copyWith(
                          color: AppColors.neutralGrayDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          _bloc.add(
                            FilteredRecipesLoad(
                              category: widget.category,
                              area: widget.area,
                            ),
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: state.recipes.length,
                    itemBuilder: (context, index) {
                      return RecepesMiniCard(meal: state.recipes[index]);
                    },
                  ),
                  // Индикатор загрузки дополнительных рецептов
                  if (state.isLoading && state.recipes.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  // Сообщение о достижении конца списка
                  if (state.hasReachedMax && state.recipes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'No more recipes to load',
                          style: AppTextStyles.body(context).copyWith(
                            color: AppColors.neutralGrayMedium,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
