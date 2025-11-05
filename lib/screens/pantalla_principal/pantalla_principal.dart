import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/screens/Screen_inventario/screen_inventario.dart';
import 'package:recetas_app/screens/Screen_recetas/Screen_recetas.dart';
import 'package:recetas_app/screens/Screen_reporte/screen_reporte.dart';
import 'package:recetas_app/screens/Screen_vender/screen_vender.dart';
import 'package:recetas_app/screens/widgets/common/botton_navigation_bar.dart';

class PantallaPrincipal extends StatelessWidget {
   PantallaPrincipal({super.key}); 

   final List<Widget> _screens = [ScreenRecetas(), ScreenVender(), ScreenInventario(), ScreenReporte()];
 
  @override
  Widget build(BuildContext context) {
    final navBarProvider = context.watch<BottomNavBarProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recetas App',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color:  Color.fromARGB(255, 45, 85, 216),
            ),
          ),
      ),
      // 1. Mostrar la pantalla correspondiente al índice actual
      body: _screens[navBarProvider.currentIndex], 
      
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 247, 247, 248),
        unselectedItemColor: const Color.fromARGB(214, 160, 168, 177),
        backgroundColor: const Color.fromARGB(255, 45, 85, 216),

        // 2. Tamaños
        iconSize: 30, // Tamaño del Icono (todos)
        selectedLabelStyle: const TextStyle(
          fontSize: 20, // Tamaño de la etiqueta seleccionada
          fontWeight: FontWeight.w900,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900, // Tamaño de la etiqueta no seleccionada
        ),
        // 2. Usar el índice actual del Provider
        currentIndex: navBarProvider.currentIndex, 
        
        // 3. Actualizar el índice en el Provider al pulsar
        onTap: (index) {
          // Usamos 'read' (o listen: false) para solo llamar al método, sin reconstruir el Scaffold
          context.read<BottomNavBarProvider>().updateIndex(index); 
        },
        
        type: BottomNavigationBarType.fixed, // Recomendado para 4 ítems
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_sharp), label: 'Recetas'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on_sharp), label: 'Vender'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_sharp), label: 'Inventario'),
          BottomNavigationBarItem(icon: Icon(Icons.file_present), label: 'Reportes'),
        ],
      ),
    );
  }
}