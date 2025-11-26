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
 // 🟢 USAR el nuevo campo costoUnitario
   precio = ingrediente.costoUnitario.toString(); 
   notifyListeners();
 }
  
  void clearForm() {
    _editingIngredienteId = null;
    nombre = '';
    cantidad = '';
    precio = '';
    notifyListeners();
  }

  // Archivo: inventario.form_notifier.dart

// ... (métodos loadIngredienteForEditing y clearForm)

  void guardarDatos() async {
   final String nombreItem = nombre.trim();
   final int? cant = int.tryParse(cantidad.trim());
   final double? prec = double.tryParse(precio.trim()); 

  // 1. Validación de campos
   if (nombreItem.isEmpty || cant == null || prec == null || cant <= 0 || prec <= 0) {
    debugPrint('Error de validación: Revise los campos.');
    return;
  }

   try {
    if (_editingIngredienteId != null) {
  // --- MODO EDICIÓN ---
        // 🟢 Corrección 1: Definir idToUpdate
     final idToUpdate = _editingIngredienteId!; 
  
        // 🟢 Corrección 2: Asegurar el tipo INT para 'cant' y Double para 'prec' con !
     final ingredienteToUpdate = Ingrediente(
      id: idToUpdate,
      nombre: nombreItem,
      cantidad: cant, // Ya es int!
      costoUnitario: prec, // Ya es double!
      fechaCreacion: DateTime.now(), 
  );

  // 🟢 Corrección 3 y 4: Llamada correcta y uso de 'ingredienteToUpdate'
     await db.updateIngrediente(ingredienteToUpdate); 
     debugPrint('Ingrediente "$nombreItem" actualizado (ID: $idToUpdate) con éxito!');
  
  } else {
  // --- MODO INSERCIÓN ---
        // 🟢 Corrección 2: Asegurar el tipo INT para 'cant' y Double para 'prec' con !
     final ingredienteCompanion = IngredientesCompanion.insert(
      nombre: nombreItem,
      cantidad: cant, // Usar !
      costoUnitario: prec, // Usar !
 );
     await db.insertIngrediente(ingredienteCompanion);
     debugPrint('Ingrediente "$nombreItem" guardado con éxito!');
    }
 
  } catch (e) {
    debugPrint('Error al guardar/actualizar ingrediente en DB: $e');
  }
 // 2. Limpiar formulario después de éxito o error de DB
   clearForm();
 }
}