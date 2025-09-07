import 'package:cooky/core/models/area.dart';
import 'package:cooky/core/models/category.dart';
import 'package:cooky/core/models/meal.dart';
import 'package:cooky/core/services/cart/cart_service.dart';
import 'package:cooky/features/cart/bloc/bloc.dart';
import 'package:cooky/features/cart/cart.dart';
import 'package:cooky/features/recipe/ui/filtered_recipes_widget.dart';
import 'package:cooky/features/recipe/ui/widgets/recepe_app_bar.dart';
import 'package:cooky/features/recipe/ui/widgets/widgets.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class RecipeScreen extends StatefulWidget {
  final String id;
  const RecipeScreen({super.key, required this.id});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final ScrollController _scrollController = ScrollController();

  Meal? _meal;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _loadMeal();
  }

  Future<void> _loadMeal() async {
    final meal = await context.read<RecipesBloc>().getMealById(widget.id);
    setState(() {
      _meal = meal;
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayerController.convertUrlToId(
      _meal?.youtube ?? '',
    );

    if (_meal == null) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

    return BlocProvider(
      create: (context) => CartBloc(CartService())..add(const LoadCart()),
      child: Scaffold(
        backgroundColor: AppColors.fieldBackground,
        floatingActionButton: AddToCartButton(meal: _meal!),
        body: CustomRefreshIndicator(
          onRefresh: () async {
            await _loadMeal();
          },
          builder: (context, child, controller) {
            return child;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // AppBar
              RecipeAppBar(meal: _meal!, scrollController: _scrollController),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок рецепта
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              _meal!.name,
                              style: AppTextStyles.heading(context).copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: AppColors.neutralGrayDark,
                              ),
                            ),
                          ),
                          ShareButton(meal: _meal!),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Теги и категории
                      if (_meal!.category.isNotEmpty || _meal!.area.isNotEmpty)
                        InfoChipsRow(
                          category: _meal!.category,
                          area: _meal!.area,
                        ),
                      const SizedBox(height: 24),

                      // Ингредиенты
                      IngredientsSection(ingredients: _meal!.ingredients),
                      const SizedBox(height: 24),
                      // Инструкции
                      InstructionsSection(
                        instructions: _meal!.formattedInstructions,
                      ),
                      const SizedBox(height: 24),

                      // Теги
                      if (_meal!.tags != null && _meal!.tags!.isNotEmpty)
                        TagsSection(tags: _meal!.tags!.split(',').join(', ')),
                      const SizedBox(height: 24),

                      // Видео
                      if (videoId != null) VideoSection(videoId: videoId),
                      const SizedBox(height: 24),
                      FilteredRecipesWidget(
                        category: Category.named(_meal!.category),
                        area: Area.named(_meal!.area),
                        scrollController: _scrollController,
                      ),
                      const SizedBox(height: 68),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
