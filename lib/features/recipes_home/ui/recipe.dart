import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class RecipeScreen extends StatefulWidget {
  final String id;
  const RecipeScreen({super.key, required this.id});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late YoutubePlayerController _controller;
  bool _isFavorite = false;
  final ScrollController _scrollController = ScrollController();

  double _titleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    final meal = context.read<RecipesBloc>().getMealById(widget.id);
    if (meal != null) {
      final videoId = YoutubePlayerController.convertUrlToId(meal.youtube);
      if (videoId != null) {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          params: const YoutubePlayerParams(showFullscreenButton: true),
        );
      }
    }

    // Добавляем слушатель скролла для анимации заголовка
    _scrollController.addListener(() {
      final offset = _scrollController.position.pixels - 200;
      final opacity = (offset / 50).clamp(0.0, 1.0);
      setState(() {
        _titleOpacity = opacity;
      });
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // TODO: Добавить логику сохранения в избранное
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favorites' : 'Removed from favorites',
        ),
        backgroundColor: AppColors.accentBrown,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meal = context.read<RecipesBloc>().getMealById(widget.id);

    if (meal == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Recipe', style: AppTextStyles.heading(context)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.neutralGrayDark,
              ),
              const SizedBox(height: 16),
              Text('Recipe not found', style: AppTextStyles.heading(context)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.fieldBackground,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.accentBrown,
            flexibleSpace: FlexibleSpaceBar(
              title: Opacity(
                opacity: _titleOpacity,
                child: Text(
                  meal.name,
                  style: AppTextStyles.heading(context).copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(_titleOpacity),
                  ),
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: meal.id,
                    child: Image.network(meal.thumbnail, fit: BoxFit.cover),
                  ),
                  // Градиент поверх изображения
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
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
                  onPressed: _toggleFavorite,
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
          ),

          // Основной контент
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок рецепта
                  Text(
                    meal.name,
                    style: AppTextStyles.heading(context).copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neutralGrayDark,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Теги и категории
                  if (meal.category.isNotEmpty || meal.area.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (meal.category.isNotEmpty)
                          _buildChip(
                            meal.category,
                            Icons.category,
                            AppColors.accentBrown,
                          ),
                        if (meal.area.isNotEmpty)
                          _buildChip(
                            meal.area,
                            Icons.location_on,
                            AppColors.accentYellowDark,
                          ),
                      ],
                    ),
                  const SizedBox(height: 24),

                  // Инструкции
                  _buildSection(
                    'Instructions',
                    Icons.menu_book,
                    meal.formattedInstructions,
                  ),
                  const SizedBox(height: 24),

                  // Теги
                  if (meal.tags != null && meal.tags!.isNotEmpty)
                    _buildSection('Tags', Icons.tag, meal.tags!),
                  const SizedBox(height: 24),

                  // Видео
                  _buildSection(
                    'Recipe Video',
                    Icons.play_circle_outline,
                    '',
                    isVideo: true,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.body(
              context,
            ).copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    IconData icon,
    String content, {
    bool isVideo = false,
  }) {
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
              child: Icon(icon, color: AppColors.accentBrown, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTextStyles.heading(context).copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutralGrayDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isVideo)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: YoutubePlayer(controller: _controller),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              content,
              style: AppTextStyles.body(context).copyWith(
                fontSize: 16,
                color: AppColors.accentBrownDark,
                height: 1.6,
              ),
            ),
          ),
      ],
    );
  }
}
