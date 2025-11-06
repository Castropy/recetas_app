import 'package:flutter/material.dart';
import 'package:recetas_app/screens/Screen_inventario/screen_inventario.dart';
import 'package:recetas_app/screens/Screen_recetas/Screen_recetas.dart';
import 'package:recetas_app/screens/Screen_reporte/screen_reporte.dart';
import 'package:recetas_app/screens/Screen_vender/screen_vender.dart'; 

class BottomNavBarProvider with ChangeNotifier {
  
  // Variable para almacenar el índice de la pantalla actual.
  int _currentIndex = 0;

  // Getter para obtener el índice actual.
  int get currentIndex => _currentIndex;

  // Método para actualizar el índice.
  void updateIndex(int newIndex) {
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      // Notifica a los widgets "oyentes" para que se reconstruyan.
      notifyListeners(); 
    }
  }
}  


// Ejemplo de pantallas para cada índice

final List<Widget> screens = [
  ScreenRecetas(), // Primera pantalla
  ScreenVender(), // Segunda pantalla 
  ScreenReporte(), // Tercera pantalla
  ScreenInventario(), // Cuarta pantalla
]; 





