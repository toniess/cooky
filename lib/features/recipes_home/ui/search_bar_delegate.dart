import 'dart:async';

import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_event.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _SearchBarWidget();
  }

  @override
  bool shouldRebuild(SearchBarDelegate oldDelegate) => false;
}

class _SearchBarWidget extends StatefulWidget {
  @override
  State<_SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<_SearchBarWidget> {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.accentBrown),
      child: StatefulBuilder(
        builder: (context, setState) {
          return TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintText: 'Search for recipes...',
              hintStyle: TextStyle(color: AppColors.neutralGrayMedium),
              prefixIcon: Icon(Icons.search, color: AppColors.neutralGrayDark),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppColors.neutralGrayDark),
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
          );
        },
      ),
    );
  }
}
