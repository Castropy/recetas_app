import 'package:flutter/material.dart';
import '../data/database/database.dart'; 

class InventarioFormNotifier extends ChangeNotifier {
  final AppDatabase db;
  InventarioFormNotifier({required this.db});

  int? _editingIngredienteId;
  int? get editingIngredienteId => _editingIngredienteId;

  String nombre = '';
  String cantidad = '';
  String precio = '';

  void updateNombre(String value) {
    nombre = value;
    notifyListeners(); 
  }

  void updateCantidad(String value) {
    cantidad = value.replaceAll(RegExp(r'[^\d]'), '');
    notifyListeners();
  }

  void updatePrecio(String value) {
    precio = value.replaceAll(RegExp(r'[^\d\.]'), '');
    notifyListeners();
  }

  void loadIngredienteForEditing(Ingrediente ingrediente) {
    _editingIngredienteId = ingrediente.id;
    nombre = ingrediente.nombre;
    cantidad = ingrediente.cantidad.toString(); 
    precio = ingrediente.precio.toString();
    notifyListeners();
  }
  
  void clearForm() {
    _editingIngredienteId = null;
    nombre = '';
    cantidad = '';
    precio = '';
    notifyListeners();
  }

  void guardarDatos() async {
    final String nombreItem = nombre.trim();
    final int? cant = int.tryParse(cantidad.trim());
    final double? prec = double.tryParse(precio.trim());

    if (nombreItem.isEmpty || cant == null || prec == null || cant <= 0 || prec <= 0) {
      debugPrint('Error de validación: Revise los campos.');
      return;
    }

    try {
      if (_editingIngredienteId != null) {
        // --- MODO EDICIÓN ---
        final idToUpdate = _editingIngredienteId!;
        
        // NOTA IMPORTANTE: Creamos un objeto Ingrediente completo, NO un Companion, 
        // para que coincida con la firma 'updateIngrediente(Ingrediente)' de tu DB.
        final ingredienteToUpdate = Ingrediente(
          id: idToUpdate,
          nombre: nombreItem,
          cantidad: cant,
          precio: prec,
          // El campo fechaCreacion es obligatorio, usamos la fecha actual como placeholder/reemplazo.
          fechaCreacion: DateTime.now(), 
        );

        // NOTA IMPORTANTE: La llamada es con un solo argumento (Ingrediente)
        await db.updateIngrediente(ingredienteToUpdate); 
        debugPrint('Ingrediente "$nombreItem" actualizado (ID: $idToUpdate) con éxito!');
        
      } else {
        // --- MODO INSERCIÓN ---
        final ingredienteCompanion = IngredientesCompanion.insert(
          nombre: nombreItem,
          cantidad: cant,
          precio: prec,
        );
        await db.insertIngrediente(ingredienteCompanion);
        debugPrint('Ingrediente "$nombreItem" guardado con éxito!');
      }
      
    } catch (e) {
      debugPrint('Error al guardar/actualizar ingrediente en DB: $e');
    }

    clearForm();
  }
}
