import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/screens/Screen_inventario/screen_inventario.dart';
import 'package:recetas_app/screens/Screen_recetas/Screen_recetas.dart';
import 'package:recetas_app/screens/Screen_reporte/screen_reporte.dart';
import 'package:recetas_app/screens/Screen_vender/screen_vender.dart';
import 'package:recetas_app/providers/botton_nav_provider.dart';
import 'package:recetas_app/widgets/shared/ad_banner_widget.dart'; // Importación del widget de anuncios

class PantallaPrincipal extends StatelessWidget {
  PantallaPrincipal({super.key});

  final List<Widget> _screens = [
    const ScreenRecetas(),
    const ScreenVender(),
    const ScreenInventario(),
    const ScreenReporte()
  ];

  @override
  Widget build(BuildContext context) {
    final navBarProvider = context.watch<BottomNavBarProvider>();

    return Scaffold(
      // 1. Mostrar la pantalla correspondiente al índice actual
      body: _screens[navBarProvider.currentIndex],

      // Centralizamos el Banner aquí para que sea persistente en toda la navegación
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
        children: [
          const AdBannerWidget(),
          const SizedBox(width: 8), // Espacio entre el banner y el BottomNavigationBar
           // El banner aparecerá siempre sobre el BottomNavigationBar
          BottomNavigationBar(
            selectedItemColor: const Color.fromARGB(255, 247, 247, 248),
            unselectedItemColor: const Color.fromARGB(214, 160, 168, 177),
            backgroundColor: const Color.fromARGB(255, 45, 85, 216),

            // 2. Tamaños y Estilos
            iconSize: 14,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
            
            // 3. Estado del Provider
            currentIndex: navBarProvider.currentIndex,

            // 4. Actualizar el índice al pulsar
            onTap: (index) {
              context.read<BottomNavBarProvider>().updateIndex(index);
            },

            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_sharp), label: 'Recetas'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.monetization_on_sharp), label: 'Vender'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_sharp), label: 'Inventario'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.file_present), label: 'Reportes'),
            ],
          ),
        ],
      ),
    );
  }
}