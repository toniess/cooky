import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        constraints: const BoxConstraints(minHeight: 110),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _onTap(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          ],
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    if (navigationShell.currentIndex == index) {
      // Если кликнули на текущий таб, сбрасываем стек до корня
      // В StatefulNavigationShell нет прямого доступа к навигатору
      // Можно использовать context.go для возврата к корню текущего таба
      final currentPath = GoRouterState.of(context).uri.path;
      if (currentPath != '/favorites' &&
          currentPath != '/recipes' &&
          currentPath != '/cart' &&
          currentPath != '/settings') {
        // Если мы не на корневом пути таба, возвращаемся к нему
        if (index == 0)
          context.go('/favorites');
        else if (index == 1)
          context.go('/recipes');
        else if (index == 2)
          context.go('/cart');
        else if (index == 3)
          context.go('/settings');
      }
    } else {
      // Переключаемся на другой таб
      navigationShell.goBranch(index);
    }
  }
}
