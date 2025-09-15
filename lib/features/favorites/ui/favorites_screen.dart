import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooky/core/models/meal.dart';
import 'package:cooky/core/utils/navigation_helper.dart';
import 'package:cooky/features/favorites/bloc/bloc.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Экран избранных рецептов
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FavoritesView();
  }
}

class _FavoritesView extends StatefulWidget {
  const _FavoritesView();

  @override
  State<_FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<_FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.neutralGrayDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoaded && state.favorites.isNotEmpty) {
                return IconButton(
                  onPressed: () => _showClearDialog(context),
                  icon: Icon(Icons.clear_all, color: AppColors.neutralGrayDark),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentBrown),
            );
          }

          if (state is FavoritesError) {
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
                    'Loading Error',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.neutralGrayDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutralGrayMedium,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FavoritesBloc>().add(LoadFavorites()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBrown,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FavoritesEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: AppColors.neutralGrayMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Favorite Recipes',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.neutralGrayDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add recipes to favorites\nto see them here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutralGrayMedium,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/recipes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBrown,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Go to Recipes'),
                  ),
                ],
              ),
            );
          }

          if (state is FavoritesLoaded) {
            return _FavoritesList(favorites: state.favorites);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Clear Favorites'),
        content: const Text(
          'Are you sure you want to remove all recipes from favorites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<FavoritesBloc>().add(ClearFavorites());
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  final List<Meal> favorites;

  const _FavoritesList({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final meal = favorites[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Dismissible(
            key: ValueKey(meal.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white, size: 24),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove from Favorites'),
                  content: Text('Remove "${meal.name}" from favorites?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              context.read<FavoritesBloc>().add(RemoveFromFavorites(meal.id));
            },
            child: _FavoriteCard(meal: meal),
          ),
        );
      },
    );
  }
}

class _FavoriteCard extends StatefulWidget {
  final Meal meal;

  const _FavoriteCard({required this.meal});

  @override
  State<_FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<_FavoriteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onRemovePressed() {
    _controller.forward().then((_) {
      context.read<FavoritesBloc>().add(RemoveFromFavorites(widget.meal.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push(
                  NavigationHelper.getRecipePath(context, widget.meal.id),
                ),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: widget.meal.thumbnail,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.neutralGrayLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.accentBrown,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.neutralGrayLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.neutralGrayMedium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.meal.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.neutralGrayDark,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.meal.area} • ${widget.meal.category}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.neutralGrayMedium,
                                  ),
                            ),
                            if (widget.meal.tags != null &&
                                widget.meal.tags!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: widget.meal.tags!
                                    .split(',')
                                    .take(3)
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.accentBrown
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          tag.trim(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.accentBrown,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _onRemovePressed,
                        icon: const Icon(
                          Icons.favorite,
                          color: AppColors.errorRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
