import 'package:cooky/features/features.dart';
import 'package:cooky/features/recipes_home/ui/recipe.dart';
import 'package:cooky/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

final router = GoRouter(
  initialLocation: '/recipes',
  observers: [TalkerRouteObserver(talker)],
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationShell(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: '/favourite',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: Scaffold(body: Text('Favourite'))),
        ),
        GoRoute(
          path: '/recipes',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: HomeScreen(title: 'Home')),
          routes: [
            GoRoute(
              path: '/:id',
              builder: (context, state) {
                final id = state.pathParameters['id'];
                assert(id != null, 'Recipe ID is required');
                return RecipeScreen(id: id!);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: TalkerScreen(talker: talker)),
        ),
      ],
    ),
  ],
);
