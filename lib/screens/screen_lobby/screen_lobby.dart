import 'package:flutter/material.dart';

class ScreenLobby extends StatelessWidget {
  const ScreenLobby({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F7FA), // Light professional grey
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu_rounded, 
              size: 100, 
              color: Color.fromARGB(255, 45, 85, 216)
            ),
            SizedBox(height: 24),
            Text(
              'Recetas App',
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142)
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Seleccione una opción del menú para comenzar',
              style: TextStyle(color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}