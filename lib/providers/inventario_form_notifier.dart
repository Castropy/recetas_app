import 'package:flutter/material.dart';
import '../data/database/database.dart'; 
import 'package:drift/drift.dart';

class InventarioFormNotifier extends ChangeNotifier {
  final AppDatabase db;

  // Controladores que mantienen el texto real en pantalla
  final nombreController = TextEditingController();
  final cantidadController = TextEditingController();
  final precioController = TextEditingController();

  InventarioFormNotifier({required this.db});

  Ingrediente? _ingredienteAntes; 
  int? _editingIngredienteId;
  int? get editingIngredienteId => _editingIngredienteId;

  String unidadMedida = 'g';

  // 🟢 Solo notificamos al cambiar de unidad (Gramos, Milis, Unid)
  void updateUnidad(String value) {
    unidadMedida = value;
    notifyListeners(); 
  }

  void loadIngredienteForEditing(Ingrediente ingrediente) {
    _ingredienteAntes = ingrediente; 
    _editingIngredienteId = ingrediente.id;
    
    nombreController.text = ingrediente.nombre;
    cantidadController.text = ingrediente.cantidad.toString();
    
    double precioAMostrar;
    if (ingrediente.unidadMedida == 'und') {
      precioAMostrar = ingrediente.costoUnitario * ingrediente.cantidad;
    } else {
      precioAMostrar = ingrediente.costoUnitario * 1000.0;
    }
    precioController.text = precioAMostrar.toStringAsFixed(2);
    unidadMedida = ingrediente.unidadMedida; 
    
    notifyListeners();
  }
  
  void clearForm() {
    _editingIngredienteId = null;
    _ingredienteAntes = null;
    nombreController.clear();
    cantidadController.clear();
    precioController.clear();
    unidadMedida = 'g';
    notifyListeners();
  }

  Future<bool> guardarDatos() async {
    // 🟢 CLAVE: Extraemos los datos directamente del texto de los controladores
    final String nombreTexto = nombreController.text.trim();
    final double? cant = double.tryParse(cantidadController.text);
    final double? precInput = double.tryParse(precioController.text);

    // Validaciones de seguridad
    if (nombreTexto.isEmpty || cant == null || cant <= 0 || precInput == null || precInput < 0) {
      return false;
    }

    double costoRealUnitario;
    if (unidadMedida == 'und') {
      costoRealUnitario = precInput / cant; 
    } else {
      // Si el usuario pone $1.22 por Kilo, el gramo vale 0.00122
      costoRealUnitario = precInput / 1000.0;
    }

    try {
      if (_editingIngredienteId != null) {
        await db.updateIngrediente(Ingrediente(
          id: _editingIngredienteId!,
          nombre: nombreTexto,
          cantidad: cant,
          costoUnitario: costoRealUnitario, 
          unidadMedida: unidadMedida,
          fechaCreacion: _ingredienteAntes!.fechaCreacion,
        ));
      } else {
        await db.insertIngrediente(IngredientesCompanion.insert(
          nombre: nombreTexto,
          cantidad: cant,
          costoUnitario: costoRealUnitario,
          unidadMedida: Value(unidadMedida),
        ));
      }
      clearForm();
      return true;
    } catch (e) {
      debugPrint('Error en DB: $e');
      return false; 
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    cantidadController.dispose();
    precioController.dispose();
    super.dispose();
  }
}