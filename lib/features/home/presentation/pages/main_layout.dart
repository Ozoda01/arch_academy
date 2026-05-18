import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    
    int getIndex() {
      if (location.startsWith('/courses')) return 1;
      if (location.startsWith('/progress')) return 2;
      if (location.startsWith('/profile')) return 3;
      return 0; // Default is Home /
    }

    void onItemTapped(int index) {
      switch (index) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/courses');
          break;
        case 2:
          context.go('/progress');
          break;
        case 3:
          context.go('/profile');
          break;
      }
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.black12,
              blurRadius: 20,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: getIndex(),
          onDestinationSelected: onItemTapped,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
          indicatorColor: (isDark ? AppColors.darkPrimary : AppColors.primary).withOpacity(0.15),
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              selectedIcon: Icon(Icons.home, color: isDark ? AppColors.darkPrimary : AppColors.primary),
              label: 'Bosh sahifa',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              selectedIcon: Icon(Icons.menu_book, color: isDark ? AppColors.darkPrimary : AppColors.primary),
              label: 'Kurslar',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              selectedIcon: Icon(Icons.analytics, color: isDark ? AppColors.darkPrimary : AppColors.primary),
              label: 'Progress',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              selectedIcon: Icon(Icons.person, color: isDark ? AppColors.darkPrimary : AppColors.primary),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
