import 'package:flutter/material.dart';
// Asegúrate de que la ruta coincida con tu proyecto
import 'package:recetas_app/widgets/shared/app_guide_widget.dart'; 

class ScreenLobby extends StatelessWidget {
  const ScreenLobby({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60), // Espacio superior para centrar visualmente
              const Icon(
                Icons.restaurant_menu_rounded, 
                size: 100, 
                color: Color.fromARGB(255, 45, 85, 216)
              ),
              const SizedBox(height: 24),
              const Text(
                'Recetas App',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Seleccione una opción del menú para comenzar',
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 40),
              
              // app guide widget
              const AppGuideWidget(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}