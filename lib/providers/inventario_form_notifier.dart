import 'package:flutter/material.dart';
import '../data/database/database.dart'; 
import 'dart:convert';
import 'package:drift/drift.dart';

class InventarioFormNotifier extends ChangeNotifier {
  final AppDatabase db;

  // 🟢 Controladores para vincular con los campos de texto (UI)
  final nombreController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();

  InventarioFormNotifier({required this.db});

  Ingrediente? _ingredienteAntes; // Almacena el estado previo para el historial

  int? _editingIngredienteId;
  int? get editingIngredienteId => _editingIngredienteId;

  // Variables de respaldo para la lógica de validación
  String nombre = '';
  String cantidad = '';
  String precio = '';

  // --- Actualización de variables desde la UI ---
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

  // 🟢 CARGA AUTOMÁTICA: Este método llena los controladores al presionar editar
  void loadIngredienteForEditing(Ingrediente ingrediente) {
    _ingredienteAntes = ingrediente; // Guardamos el objeto actual
    _editingIngredienteId = ingrediente.id;
    
    // Asignar texto a los controladores para que aparezcan en los campos
    nombreController.text = ingrediente.nombre;
    cantidadController.text = ingrediente.cantidad.toString();
    precioController.text = ingrediente.costoUnitario.toString();

    // Sincronizar variables de validación
    nombre = ingrediente.nombre;
    cantidad = ingrediente.cantidad.toString(); 
    precio = ingrediente.costoUnitario.toString(); 
    
    notifyListeners();
  }
  
  void clearForm() {
    _editingIngredienteId = null;
    _ingredienteAntes = null;

    // Limpiar controladores visuales
    nombreController.clear();
    cantidadController.clear();
    precioController.clear();

    // Limpiar variables de estado
    nombre = '';
    cantidad = '';
    precio = '';
    notifyListeners();
  }

  // --- Lógica de persistencia ---
  Future<bool> guardarDatos() async {
    final nombreItem = nombre.trim();
    if (nombreItem.isEmpty) {
      debugPrint('Error: El nombre es obligatorio.');
      return false;
    }

    final cant = int.tryParse(cantidad);
    if (cant == null || cant < 0) {
      debugPrint('Error: La cantidad debe ser un número entero válido.');
      return false;
    }

    final prec = double.tryParse(precio);
    if (prec == null || prec < 0) {
      debugPrint('Error: El precio debe ser un número decimal válido.');
      return false;
    }

    try {
      if (_editingIngredienteId != null) {
        // --- MODO EDICIÓN ---
        final idToUpdate = _editingIngredienteId!;

        final ingredienteToUpdate = Ingrediente(
          id: idToUpdate,
          nombre: nombreItem,
          cantidad: cant,
          costoUnitario: prec,
          fechaCreacion: _ingredienteAntes!.fechaCreacion,
        );

        await db.updateIngrediente(ingredienteToUpdate);

        // Registro de transacción de edición
        final String detallesJson = jsonEncode({
          "antes": {
            "cant": _ingredienteAntes!.cantidad,
            "costo": _ingredienteAntes!.costoUnitario
          },
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

        await db.insertTransaccion(TransaccionesCompanion.insert(
          tipo: 'Alta',
          entidad: 'Ingrediente',
          entidadId: Value(newId),
          detalles: '{"cant": $cant, "costo": $prec}',
        ));
      }
    } catch (e) {
      debugPrint('Error al guardar/actualizar ingrediente en DB: $e');
      return false; 
    }

    clearForm();
    return true; 
  }

  Future<void> deleteIngredienteConHistorial(Ingrediente ingrediente) async {
    try {
      await db.deleteIngrediente(ingrediente.id);

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

  // 🟢 Limpieza de memoria al destruir el Provider
  @override
  void dispose() {
    nombreController.dispose();
    cantidadController.dispose();
    precioController.dispose();
    super.dispose();
  }
}