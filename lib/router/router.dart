import 'package:cooky/features/cart/cart.dart';
import 'package:cooky/features/favorites/favorites.dart';
import 'package:cooky/features/filters/bloc/filters_bloc.dart';
import 'package:cooky/features/filters/bloc/filters_event.dart';
import 'package:cooky/features/main_navigation/ui/main_navigation_shell.dart';
import 'package:cooky/features/recipe/ui/recipe.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/features/recipes_home/ui/recipes.dart';
import 'package:cooky/features/search/ui/search_screen.dart';
import 'package:cooky/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

final router = GoRouter(
  initialLocation: '/recipes',
  observers: [TalkerRouteObserver(talker)],
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
            GoRoute(
              path: '/favorites/recipe/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return RecipeScreen(id: id);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/recipes',
              builder: (context, state) => BlocProvider(
                create: (context) => RecipesBloc(),
                child: const HomeScreen(title: 'Recipes'),
              ),
            ),
            GoRoute(
              path: '/search',
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider<RecipesBloc>(create: (context) => RecipesBloc()),
                  BlocProvider<FiltersBloc>(
                    create: (context) => FiltersBloc()
                      ..add(LoadCategories())
                      ..add(LoadAreas()),
                  ),
                ],
                child: const SearchScreen(),
              ),
            ),
            GoRoute(
              path: '/recipes/recipe/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return RecipeScreen(id: id);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
            GoRoute(
              path: '/cart/recipe/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return RecipeScreen(id: id);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => TalkerScreen(talker: talker),
            ),
          ],
        ),
      ],
    ),
  ],
);
