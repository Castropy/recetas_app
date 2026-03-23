import 'package:flutter/material.dart';
import 'package:recetas_app/screens/screen_lobby/screen_lobby.dart'; // New import
import 'package:recetas_app/screens/Screen_inventario/screen_inventario.dart';
import 'package:recetas_app/screens/Screen_recetas/Screen_recetas.dart';
import 'package:recetas_app/screens/Screen_reporte/screen_reporte.dart';
import 'package:recetas_app/screens/Screen_vender/screen_vender.dart'; 

class BottomNavBarProvider with ChangeNotifier {
  int _currentIndex = 0; // Starts at ScreenLobby

  int get currentIndex => _currentIndex;

  void updateIndex(int newIndex) {
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      notifyListeners(); 
    }
  }
} 

// The list now includes 5 elements, starting with the Lobby
final List<Widget> screens = [
  const ScreenLobby(),     // Index 0: Dashboard/Home
  const ScreenRecetas(),   // Index 1
  const ScreenVender(),    // Index 2
  const ScreenInventario(),// Index 3
  const ScreenReporte(),   // Index 4
];