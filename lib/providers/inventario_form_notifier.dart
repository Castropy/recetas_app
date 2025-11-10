import 'package:flutter/material.dart';
import '../data/database/database.dart'; // <--- Asegúrate que esta ruta sea correcta

class InventarioFormNotifier extends ChangeNotifier {
  // 1. DEPENDENCIA: Requiere la instancia de AppDatabase
  final AppDatabase db;
  InventarioFormNotifier({required this.db});

  // 2. PROPIEDADES DEL FORMULARIO
  String nombre = '';
  String cantidad = '';
  String precio = '';

  // 3. MÉTODOS DE ACTUALIZACIÓN (onChanged)
  void updateNombre(String value) {
    nombre = value;
  }

  void updateCantidad(String value) {
    cantidad = value;
  }

  void updatePrecio(String value) {
    precio = value;
  }

  // 4. FUNCIÓN CLAVE: Guardar los datos en Drift
  void guardarDatos() async {
    // Conversión y validación de tipos
    final String nombreItem = nombre.trim();
    final int? cant = int.tryParse(cantidad.trim());
    final double? prec = double.tryParse(precio.trim());

    // Validación: Nombre no vacío, Cantidad y Precio son números positivos
    if (nombreItem.isEmpty || cant == null || prec == null || cant <= 0 || prec <= 0) {
      // Nota: En una app real, aquí se emitiría un error visible a la UI.
      debugPrint('Error de validación: Revise los campos.');
      return;
    }

    // 5. Crear el objeto Companion de Drift con los tres campos
    final nuevoIngrediente = IngredientesCompanion.insert(
      nombre: nombreItem,
      cantidad: cant, // Se inserta como int
      precio: prec,    // Se inserta como double
    );

    // 6. Ejecutar la operación de inserción en la DB
    try {
      await db.insertIngrediente(nuevoIngrediente);
      // Opcional: Mostrar un mensaje de éxito
      debugPrint('Ingrediente "$nombreItem" guardado con éxito!');
    } catch (e) {
      debugPrint('Error al guardar ingrediente en DB: $e');
      // Manejo de errores de la base de datos (ej. restricción única)
    }

    // 7. Limpiar el formulario y notificar a los listeners
    nombre = '';
    cantidad = '';
    precio = '';
    notifyListeners();
  }
}