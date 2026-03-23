import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/botton_nav_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the provider to update the index
    final navProvider = context.read<BottomNavBarProvider>();
    final currentIndex = context.watch<BottomNavBarProvider>().currentIndex;

    return Drawer(
      child: Column(
        children: [
          // 1. Header: Brand identity
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 45, 85, 216),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Recetas App',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // 2. Navigation Items: It maps each option to an index
          _DrawerItem(
            icon: Icons.home_rounded,
            label: 'Inicio',
            isSelected: currentIndex == 0,
            onTap: () => _handleNavigation(context, navProvider, 0),
          ),
          _DrawerItem(
            icon: Icons.list_alt_sharp,
            label: 'Recetas',
            isSelected: currentIndex == 1,
            onTap: () => _handleNavigation(context, navProvider, 1),
          ),
          _DrawerItem(
            icon: Icons.monetization_on_sharp,
            label: 'Vender',
            isSelected: currentIndex == 2,
            onTap: () => _handleNavigation(context, navProvider, 2),
          ),
          _DrawerItem(
            icon: Icons.inventory_sharp,
            label: 'Inventario',
            isSelected: currentIndex == 3,
            onTap: () => _handleNavigation(context, navProvider, 3),
          ),
          _DrawerItem(
            icon: Icons.file_present,
            label: 'Reportes',
            isSelected: currentIndex == 4,
            onTap: () => _handleNavigation(context, navProvider, 4),
          ),

          const Spacer(), // Pushes the rest to the bottom
          
          // 3. Footer: Version or branding
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'v1.0.3 - Beta Test',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to update index and close the drawer
  void _handleNavigation(BuildContext context, BottomNavBarProvider provider, int index) {
    provider.updateIndex(index);
    Navigator.pop(context); // It closes the drawer after selection
  }
}

// Private helper widget for clean list items
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color.fromARGB(255, 45, 85, 216) : Colors.grey),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color.fromARGB(255, 45, 85, 216) : Colors.black87,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}