import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({
    super.key,
    required this.child,
    required this.state,
  });

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        constraints: BoxConstraints(minHeight: 110),
        child: BottomNavigationBar(
          currentIndex: _getIndex(state.matchedLocation),
          onTap: (index) => _onTap(context, index),
          items: [
            buildBottomNavigationButton(Icons.favorite),
            buildBottomNavigationButton(Icons.book),
            buildBottomNavigationButton(Icons.settings),
          ],
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationButton(IconData icon) {
    return BottomNavigationBarItem(icon: Icon(icon), label: '');
  }

  int _getIndex(String path) => switch (path) {
    '/favourite' => 0,
    '/home' => 1,
    '/settings' => 2,
    _ => 0,
  };

  void _onTap(BuildContext context, int index) =>
      context.go(['/favourite', '/home', '/settings'][index]);
}
