import 'package:cooky/core/models/meal.dart';
import 'package:cooky/core/services/favorites/abstract_favorites_service.dart';
import 'package:cooky/main.dart';
import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecipeAppBar extends StatefulWidget {
  final Meal meal;
  final ScrollController scrollController;

  const RecipeAppBar({
    super.key,
    required this.meal,
    required this.scrollController,
  });

  @override
  State<RecipeAppBar> createState() => _RecipeAppBarState();
}

class _RecipeAppBarState extends State<RecipeAppBar> {
  bool _isFavorite = false;
  double _titleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    _checkFavoriteStatus();
  }

  @override
  void didUpdateWidget(covariant RecipeAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.meal.id != widget.meal.id) {
      _checkFavoriteStatus();
    }
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final isFavorite = await getIt<AbstractFavoritesService>().isFavorite(
        widget.meal.id,
      );
      if (mounted) {
        setState(() {
          _isFavorite = isFavorite;
        });
      }
    } catch (e) {
      // Обработка ошибки
    }
  }

  Future<void> _toggleFavorite() async {
    final favoriteService = getIt<AbstractFavoritesService>();

    try {
      if (_isFavorite) {
        await favoriteService.removeFromFavorites(widget.meal.id);
      } else {
        await favoriteService.addToFavorites(widget.meal);
      }

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    } catch (e) {
      if (mounted) {
        // Показать ошибку пользователю
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final offset = widget.scrollController.position.pixels - 200;
    final opacity = (offset / 50).clamp(0.0, 1.0);
    setState(() {
      _titleOpacity = opacity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.accentBrown,
      flexibleSpace: FlexibleSpaceBar(
        title: Opacity(
          opacity: _titleOpacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              widget.meal.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.heading(context).copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(_titleOpacity),
              ),
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(widget.meal.thumbnail, fit: BoxFit.cover),
            // Градиент поверх изображения
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(8),
        child: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      actions: [
        // Кнопка избранного в AppBar
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => _toggleFavorite(),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(_isFavorite),
                color: _isFavorite ? Colors.red : Colors.white,
                size: 28,
              ),
            ),
            iconSize: 28,
          ),
        ),
      ],
    );
  }
}
