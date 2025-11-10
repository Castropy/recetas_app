import 'package:flutter/material.dart';

class InventarioFormNotifier extends ChangeNotifier {
  // 1. Propiedades para almacenar los valores del formulario
  String nombre = '';
  String cantidad = '';
  String precio = '';

  // 2. Método para actualizar los valores (se usa en onChanged del TextFormField)
  void updateNombre(String value) {
    nombre = value;
    // No es necesario notificar aquí, solo al guardar.
  }

  void updateCantidad(String value) {
    cantidad = value;
    // No es necesario notificar aquí, solo al guardar.
  }

  void updatePrecio(String value) {
    precio = value;
    // No es necesario notificar aquí, solo al guardar.
  }

  // 3. Función clave para guardar en la base de datos
  void guardarDatos() {
    // Conversión y validación
    final String nombreItem = nombre;
    final int? cant = int.tryParse(cantidad);
    final double? prec = double.tryParse(precio);

    if (nombreItem.isEmpty || cant == null || prec == null || cant <= 0 || prec <= 0) {
      // Manejo de error/validación. Podrías notificar un estado de error.
     // print('Error de validación');
      return;
    }

    // Lógica real de la base de datos (InventarioDao.insert, etc.)
   // print('Datos listos para DB: Nombre=$nombreItem, Cantidad=$cant, Precio=$prec');

    // 4. Limpiar el formulario y notificar a los listeners
    nombre = '';
    cantidad = '';
    precio = '';
    notifyListeners(); // Notifica a la UI para que los campos se reseteen.
  }
}