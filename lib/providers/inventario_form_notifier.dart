import 'package:flutter/material.dart';
import '../data/database/database.dart'; 
import 'dart:convert';
import 'package:drift/drift.dart';


class InventarioFormNotifier extends ChangeNotifier {
  final AppDatabase db;
  InventarioFormNotifier({required this.db});
  Ingrediente? _ingredienteAntes; // Para almacenar el estado previo al editar

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
   _ingredienteAntes = ingrediente; // Guardamos el objeto actual
   _editingIngredienteId = ingrediente.id;
   nombre = ingrediente.nombre;
   cantidad = ingrediente.cantidad.toString(); 
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

  // 🟢 MODIFICACIÓN: guardarDatos para registrar Transacción
void guardarDatos() async {
  // ... (Validaciones existentes)
  final nombreItem = nombre.trim();
  if (nombreItem.isEmpty) {
    // Aquí puedes manejar una notificación de error o simplemente retornar
    debugPrint('Error: El nombre es obligatorio.');
    return;
  }
  
  // 2. Parsar y validar cantidad (de String a Int)
  final cant = int.tryParse(cantidad);
  if (cant == null || cant < 0) {
    debugPrint('Error: La cantidad debe ser un número entero válido.');
    return;
  }
  
  // 3. Parsar y validar precio (de String a Double)
  final prec = double.tryParse(precio);
  if (prec == null || prec < 0) {
    debugPrint('Error: El precio debe ser un número decimal válido.');
    return;
  }
  
  try {
    if (_editingIngredienteId != null) {
      // --- MODO EDICIÓN ---
      final idToUpdate = _editingIngredienteId!; 
      
      final ingredienteToUpdate = Ingrediente(
        id: idToUpdate,
        nombre:  nombreItem,
        cantidad: cant,
        costoUnitario: prec,
        fechaCreacion: _ingredienteAntes!.fechaCreacion, // Usar la fecha original
      );

      await db.updateIngrediente(ingredienteToUpdate); 
      
      // 🟢 REGISTRO DE HISTORIAL (Edición)
      final String detallesJson = jsonEncode({
        "antes": {"cant": _ingredienteAntes!.cantidad, "costo": _ingredienteAntes!.costoUnitario},
        "despues": {"cant": cant, "costo": prec},
      });

      await db.insertTransaccion(TransaccionesCompanion.insert(
        tipo: 'Edición',
        entidad: 'Ingrediente',
        entidadId: Value(idToUpdate),
        detalles: detallesJson,
      ));

    } else {
      // --- MODO INSERCIÓN ---
      final ingredienteCompanion = IngredientesCompanion.insert(
        nombre: nombreItem,
        cantidad: cant,
        costoUnitario: prec,
      );
      final int newId = await db.insertIngrediente(ingredienteCompanion);
      
      // 🟢 REGISTRO DE HISTORIAL (Alta)
      await db.insertTransaccion(TransaccionesCompanion.insert(
        tipo: 'Alta',
        entidad: 'Ingrediente',
        entidadId: Value(newId),
        detalles: '{"cant": $cant, "costo": $prec}',
      ));
    }
  
  } catch (e) {
    debugPrint('Error al guardar/actualizar ingrediente en DB: $e');
  }
  _ingredienteAntes = null; // Limpiar estado anterior
  clearForm();
}

Future<void> deleteIngredienteConHistorial(Ingrediente ingrediente) async {
  try {
    // 1. Eliminar de la DB
    await db.deleteIngrediente(ingrediente.id);

    // 2. Registrar Historial
    final String detallesJson = jsonEncode({
      "nombre": ingrediente.nombre,
      "cant": ingrediente.cantidad,
      "costo": ingrediente.costoUnitario,
    });

    await db.insertTransaccion(TransaccionesCompanion.insert(
      tipo: 'Eliminado',
      entidad: 'Ingrediente',
      entidadId: Value(ingrediente.id),
      detalles: detallesJson,
    ));

  } catch (e) {
    debugPrint('Error al eliminar ingrediente en DB: $e');
  }
  notifyListeners();
}

}