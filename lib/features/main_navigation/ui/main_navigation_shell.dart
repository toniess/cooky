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
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -10),
            ),
          ],
        ),
        constraints: BoxConstraints(minHeight: 110),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _getIndex(state.matchedLocation),
          onTap: (index) => _onTap(context, index),
          items: [
            buildBottomNavigationButton(Icons.favorite),
            buildBottomNavigationButton(Icons.book),
            buildBottomNavigationButton(Icons.shopping_cart),
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

  int _getIndex(String path) {
    if (path.contains('/favourite')) return 0;
    if (path.contains('/recipes')) return 1;
    if (path.contains('/cart')) return 2;
    if (path.contains('/settings')) return 3;

    return 0;
  }

  void _onTap(BuildContext context, int index) =>
      context.go(['/favourite', '/recipes', '/cart', '/settings'][index]);
}
