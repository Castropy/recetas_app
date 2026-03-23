import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/screens/screen_lobby/screen_lobby.dart'; // New Lobby
import 'package:recetas_app/screens/Screen_inventario/screen_inventario.dart';
import 'package:recetas_app/screens/Screen_recetas/Screen_recetas.dart';
import 'package:recetas_app/screens/Screen_reporte/screen_reporte.dart';
import 'package:recetas_app/screens/Screen_vender/screen_vender.dart';
import 'package:recetas_app/providers/botton_nav_provider.dart';
import 'package:recetas_app/widgets/shared/custom_drawer.dart'; // New Drawer
import 'package:recetas_app/widgets/shared/ad_banner_widget.dart';

class PantallaPrincipal extends StatelessWidget {
  PantallaPrincipal({super.key});

  // The list is updated to include the Lobby at index 0
  final List<Widget> _screens = [
    const ScreenLobby(),
    const ScreenRecetas(),
    const ScreenVender(),
    const ScreenInventario(),
    const ScreenReporte()
  ];

  @override
  Widget build(BuildContext context) {
    final navBarProvider = context.watch<BottomNavBarProvider>();

    return Scaffold(
      // The AppBar automatically handles the hamburger icon when a Drawer is present
      appBar: AppBar(
        title: const Text('Recetas App'),
        backgroundColor: const Color.fromARGB(255, 45, 85, 216),
        foregroundColor: Colors.white,
      ),
      
      // It injects the new navigation drawer
      drawer: const CustomDrawer(),

      // It displays the selected screen from the provider's index
      body: Column(
        children: [
          Expanded(
            child: _screens[navBarProvider.currentIndex],
          ),
          // It maintains the banner at the bottom of the content
          const AdBannerWidget(),
        ],
      ),
    );
  }
}