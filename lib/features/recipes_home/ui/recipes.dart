import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_event.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_state.dart';
import 'package:cooky/features/recipes_home/ui/ui.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          _scrollController.position.maxScrollExtent - 30) {
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
      appBar: AppBar(title: Text('Recipes')),
      body: RefreshIndicator(
        edgeOffset: SearchBarDelegate().maxExtent,
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
            SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: SearchBarDelegate(),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            BlocBuilder<RecipesBloc, RecipesState>(
              bloc: recipesBloc,
              builder: (context, state) {
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
