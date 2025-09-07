import 'package:cooky/core/models/models.dart';
import 'package:cooky/core/services/cart/cart_service.dart';
import 'package:cooky/features/cart/bloc/bloc.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Экран корзины покупок
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(CartService())..add(const LoadCart()),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping List',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.neutralGrayDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: const [],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentBrown),
            );
          }

          if (state is CartError) {
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
                        context.read<CartBloc>().add(const LoadCart()),
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

          if (state is CartEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list_alt_outlined,
                    size: 64,
                    color: AppColors.neutralGrayMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Shopping List is Empty',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.neutralGrayDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add ingredients from recipes\nto create your shopping list',
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

          if (state is CartLoaded) {
            return _CartList(cart: state.cart);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CartList extends StatefulWidget {
  final Cart cart;

  const _CartList({required this.cart});

  @override
  State<_CartList> createState() => _CartListState();
}

class _CartListState extends State<_CartList> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    final groupedItems = _getGroupedItems();
    _animationControllers = List.generate(
      groupedItems.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 100)),
        vsync: this,
      ),
    );

    _slideAnimations = _animationControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();

    _fadeAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();

    // Запускаем анимации с задержкой
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  Map<String, List<CartItem>> _getGroupedItems() {
    final Map<String, List<CartItem>> groupedItems = {};
    for (final item in widget.cart.items) {
      if (!groupedItems.containsKey(item.mealId)) {
        groupedItems[item.mealId] = [];
      }
      groupedItems[item.mealId]!.add(item);
    }
    return groupedItems;
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = _getGroupedItems();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        final mealId = groupedItems.keys.elementAt(index);
        final items = groupedItems[mealId]!;
        final mealName = items.first.mealName;

        return SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: _MealGroupCard(
              key: ValueKey(mealId),
              mealName: mealName,
              mealId: mealId,
              items: items,
            ),
          ),
        );
      },
    );
  }
}

class _MealGroupCard extends StatefulWidget {
  final String mealName;
  final String mealId;
  final List<CartItem> items;

  const _MealGroupCard({
    super.key,
    required this.mealName,
    required this.mealId,
    required this.items,
  });

  @override
  State<_MealGroupCard> createState() => _MealGroupCardState();
}

class _MealGroupCardState extends State<_MealGroupCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Начинаем с развернутого состояния
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок группы
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentBrown.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: AppColors.accentBrown,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mealName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentBrown,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.items.where((item) => !item.isPurchased).length}/${widget.items.length} ingredients to buy',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.accentBrown.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Кнопка сворачивания/разворачивания
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.accentBrown.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _toggleExpanded,
                    icon: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.accentBrown,
                        size: 20,
                      ),
                    ),
                    tooltip: _isExpanded ? 'Collapse' : 'Expand',
                  ),
                ),
              ],
            ),
          ),
          // Список ингредиентов с анимацией
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: widget.items
                  .map((item) => _CartItemCard(item: item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatefulWidget {
  final CartItem item;

  const _CartItemCard({required this.item});

  @override
  State<_CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<_CartItemCard>
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Изображение ингредиента
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Opacity(
                    opacity: widget.item.isPurchased ? 0.5 : 1.0,
                    child: Image.network(
                      widget.item.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 60,
                          height: 60,
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
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.neutralGrayLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: AppColors.neutralGrayMedium,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Информация об ингредиенте
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: widget.item.isPurchased
                              ? AppColors.neutralGrayMedium
                              : AppColors.neutralGrayDark,
                          decoration: widget.item.isPurchased
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            widget.item.measure,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: widget.item.isPurchased
                                      ? AppColors.neutralGrayMedium.withValues(
                                          alpha: 0.6,
                                        )
                                      : AppColors.neutralGrayMedium,
                                  decoration: widget.item.isPurchased
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                          ),
                          if (widget.item.quantity > 1) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentBrown.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'x${widget.item.quantity}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.accentBrown,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Чекбокс для отметки купленного товара
                Checkbox(
                  value: widget.item.isPurchased,
                  onChanged: (value) {
                    context.read<CartBloc>().add(
                      ToggleItemPurchased(widget.item.id),
                    );
                  },
                  activeColor: AppColors.accentBrown,
                  shape: const CircleBorder(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
