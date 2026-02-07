import 'package:flutter/material.dart';
import '../data/database/database.dart'; 
import 'dart:convert';
import 'package:drift/drift.dart';

class InventarioFormNotifier extends ChangeNotifier {
  final AppDatabase db;

  // Controladores para la UI
  final nombreController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();

  InventarioFormNotifier({required this.db});

  Ingrediente? _ingredienteAntes; 
  int? _editingIngredienteId;
  int? get editingIngredienteId => _editingIngredienteId;

  String nombre = '';
  String cantidad = '';
  String precio = '';
  String unidadMedida = 'g';

  // --- Actualización de variables ---
  void updateNombre(String value) {
    nombre = value;
    notifyListeners(); 
  }

  void updateCantidad(String value) {
    cantidad = value.replaceAll(RegExp(r'[^\d\.]'), '');
    notifyListeners();
  }

  void updatePrecio(String value) {
    precio = value.replaceAll(RegExp(r'[^\d\.]'), '');
    notifyListeners();
  }

  void updateUnidad(String value) {
    unidadMedida = value;
    notifyListeners();
  }

  // --- Carga para edición ---
  void loadIngredienteForEditing(Ingrediente ingrediente) {
    _ingredienteAntes = ingrediente; 
    _editingIngredienteId = ingrediente.id;
    
    nombreController.text = ingrediente.nombre;
    // Al editar, mostramos la cantidad total, pero el precioUnitario 
    // lo revertimos a formato "comercial" para que el usuario no vea 0.00122
    cantidadController.text = ingrediente.cantidad.toString();
    
    double precioAMostrar;
    if (ingrediente.unidadMedida == 'und') {
      precioAMostrar = ingrediente.costoUnitario * ingrediente.cantidad;
    } else {
      precioAMostrar = ingrediente.costoUnitario * 1000.0;
    }
    precioController.text = precioAMostrar.toStringAsFixed(2);

    nombre = ingrediente.nombre;
    cantidad = ingrediente.cantidad.toString(); 
    precio = precioAMostrar.toString(); 
    unidadMedida = ingrediente.unidadMedida; 
    
    notifyListeners();
  }
  
  void clearForm() {
    _editingIngredienteId = null;
    _ingredienteAntes = null;
    nombreController.clear();
    cantidadController.clear();
    precioController.clear();
    nombre = '';
    cantidad = '';
    precio = '';
    unidadMedida = 'g';
    notifyListeners();
  }

  // --- Lógica de persistencia CORREGIDA ---
  Future<bool> guardarDatos() async {
    final nombreItem = nombre.trim();
    if (nombreItem.isEmpty) return false;

    final cant = double.tryParse(cantidad);
    final precInput = double.tryParse(precio);

    if (cant == null || cant <= 0 || precInput == null || precInput < 0) {
      debugPrint('Error: Valores de cantidad o precio inválidos.');
      return false;
    }

    // 🟢 ESTANDARIZACIÓN: Calculamos el costo de 1 unidad base para la DB
    double costoRealUnitario;
    if (unidadMedida == 'und') {
      // Ejemplo: $6 / 30 huevos = $0.20 por huevo
      costoRealUnitario = precInput / cant; 
    } else {
      // Ejemplo: $1.22 (el kilo) / 1000 = $0.00122 por gramo/ml
      // Asumimos que el precio en 'g' o 'ml' se ingresa por Kilo o Litro
      costoRealUnitario = precInput / 1000.0;
    }

    try {
      if (_editingIngredienteId != null) {
        final idToUpdate = _editingIngredienteId!;

        final ingredienteToUpdate = Ingrediente(
          id: idToUpdate,
          nombre: nombreItem,
          cantidad: cant,
          costoUnitario: costoRealUnitario, // Guardamos costo base
          unidadMedida: unidadMedida,
          fechaCreacion: _ingredienteAntes!.fechaCreacion,
        );

        await db.updateIngrediente(ingredienteToUpdate);

        final String detallesJson = jsonEncode({
          "antes": {"cant": _ingredienteAntes!.cantidad, "costo": _ingredienteAntes!.costoUnitario, "unidad": _ingredienteAntes!.unidadMedida},
          "despues": {"cant": cant, "costo": costoRealUnitario, "unidad": unidadMedida},
        });

        await db.insertTransaccion(TransaccionesCompanion.insert(
          tipo: 'Edición',
          entidad: 'Ingrediente',
          entidadId: Value(idToUpdate),
          detalles: detallesJson, 
        ));
      } else {
        final ingredienteCompanion = IngredientesCompanion.insert(
          nombre: nombreItem,
          cantidad: cant,
          costoUnitario: costoRealUnitario, // Guardamos costo base
          unidadMedida: Value(unidadMedida),
        );
        final int newId = await db.insertIngrediente(ingredienteCompanion);

        await db.insertTransaccion(TransaccionesCompanion.insert(
          tipo: 'Alta',
          entidad: 'Ingrediente',
          entidadId: Value(newId),
          detalles: '{"cant": $cant, "costo_base": $costoRealUnitario, "unidad": "$unidadMedida"}',
        ));
      }
    } catch (e) {
      debugPrint('Error al guardar en DB: $e');
      return false; 
    }

    clearForm();
    return true; 
  }

  Future<void> deleteIngredienteConHistorial(Ingrediente ingrediente) async {
    try {
      await db.deleteIngrediente(ingrediente.id);
      await db.insertTransaccion(TransaccionesCompanion.insert(
        tipo: 'Eliminado',
        entidad: 'Ingrediente',
        entidadId: Value(ingrediente.id),
        detalles: jsonEncode({"nombre": ingrediente.nombre, "cant": ingrediente.cantidad}),
      ));
    } catch (e) {
      debugPrint('Error al eliminar: $e');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    nombreController.dispose();
    cantidadController.dispose();
    precioController.dispose();
    super.dispose();
  }
}