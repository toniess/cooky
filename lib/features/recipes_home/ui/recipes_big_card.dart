import 'package:cooky/core/models/meal.dart';
import 'package:cooky/core/utils/navigation_helper.dart';
import 'package:cooky/features/favorites/bloc/bloc.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecipeBigCard extends StatelessWidget {
  final Meal meal;
  const RecipeBigCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push(NavigationHelper.getRecipePath(context, meal.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _buildCardContentTest1(context),
      ),
    );

    // return Container(
    //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //   width: double.infinity,
    //   height: 200,
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   clipBehavior: Clip.hardEdge,
    //   child: _buildCardContentTest2(context),
    // );
  }

  Widget _buildCardContentTest1(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 180,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    meal.thumbnail,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.neutralGrayLight,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _FavoriteButton(meal: meal),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 70,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Text(
                  meal.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "${meal.area} • ${meal.category}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildCardContentTest2(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            meal.thumbnail,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.neutralGrayLight,
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${meal.area} • ${meal.category}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(200),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(top: 16, right: 16, child: _FavoriteButton(meal: meal)),
      ],
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final Meal meal;

  const _FavoriteButton({required this.meal});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Загружаем избранные при инициализации
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  void _toggleFavorite(bool isFavorite) {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    if (isFavorite) {
      context.read<FavoritesBloc>().add(RemoveFromFavorites(widget.meal.id));
    } else {
      context.read<FavoritesBloc>().add(AddToFavorites(widget.meal));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        bool isFavorite = false;

        if (state is FavoritesLoaded) {
          isFavorite = state.favoriteStatus[widget.meal.id] ?? false;
        }

        return GestureDetector(
          onTap: () => _toggleFavorite(isFavorite),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.0),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 30,
                    color: isFavorite
                        ? AppColors.errorRed
                        : Colors.white.withValues(alpha: 0.7),
                  ),
          ),
        );
      },
    );
  }
}
