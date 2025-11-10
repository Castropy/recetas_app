import 'package:flutter/material.dart';

class NotificacionSnackBar {
  static void mostrarSnackBar(BuildContext context, String mensaje) {
    final snackBar = SnackBar(
      content: Text(
        mensaje,
        style: const TextStyle(color: Colors.white), // Mejorar contraste
      ),
      duration: const Duration(seconds: 2),
      
      // 📌 Configuración para que aparezca en la parte superior:
      behavior: SnackBarBehavior.floating, 
      margin: const EdgeInsets.only(
        top: 60.0, // Altura deseada desde arriba
        left: 20.0,
        right: 20.0,
      ),
      backgroundColor: const Color.fromARGB(255, 130, 156, 243), // Usar el color del AppBar
      elevation: 6.0, // Añadir sombra para que resalte
    );
    
    // Asegurarse de que el ScaffoldMessenger existe y mostrarlo
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}