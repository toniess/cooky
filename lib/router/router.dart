import 'package:cooky/features/features.dart';
import 'package:cooky/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

final router = GoRouter(
  initialLocation: '/home',
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
          path: '/home',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: HomeScreen(title: 'Home')),
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
