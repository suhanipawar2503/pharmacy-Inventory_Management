import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'home_screen.dart';
import 'inventory_screen.dart';
import 'sales_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const InventoryScreen(),
    const SalesScreen(),
    const ReportsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: AppColors.surfaceWhite,
        indicatorColor: AppColors.primaryBlue.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: AppColors.primaryBlue),
            icon: Icon(Icons.home_outlined, color: AppColors.textMuted),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.inventory_2, color: AppColors.primaryBlue),
            icon: Icon(Icons.inventory_2_outlined, color: AppColors.textMuted),
            label: 'Inventory',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.point_of_sale, color: AppColors.primaryBlue),
            icon: Icon(Icons.point_of_sale_outlined, color: AppColors.textMuted),
            label: 'Sales',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.assessment, color: AppColors.primaryBlue),
            icon: Icon(Icons.assessment_outlined, color: AppColors.textMuted),
            label: 'Reports',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: AppColors.primaryBlue),
            icon: Icon(Icons.person_outline, color: AppColors.textMuted),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
