import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/models/recipe_ingredient_model.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';

class RecetaFormNotifier extends ChangeNotifier {
  final AppDatabase db;
  RecetaFormNotifier({required this.db});

  // --- Estado del Formulario ---
  int? _idReceta; 
  String _nombre = '';
  List<RecipeIngredientModel> _ingredientesSeleccionados = [];

  // Getters
  int? get idReceta => _idReceta; 
  String get nombre => _nombre;
  List<RecipeIngredientModel> get ingredientesSeleccionados => _ingredientesSeleccionados;

  // 🟢 El costo total ahora es dinámico y exacto basado en el modelo
  double get costoTotal {
    return _ingredientesSeleccionados.fold(0.0, (sum, item) => sum + item.costoSubtotal);
  } 

  void updateNombre(String value) {
    _nombre = value;
    notifyListeners();
  }

  void addIngredient(RecipeIngredientModel item) {
    final existingIndex = _ingredientesSeleccionados.indexWhere((i) => i.ingredienteId == item.ingredienteId);
    
    if (existingIndex >= 0) {
      if (item.cantidadNecesaria <= 0) {
        _ingredientesSeleccionados.removeAt(existingIndex);
      } else {
        _ingredientesSeleccionados[existingIndex] = item;
      }
    } else {
      if (item.cantidadNecesaria > 0) {
        _ingredientesSeleccionados.add(item);
      }
    }
    notifyListeners();
  }

  void removeIngredient(int ingredienteId) {
    _ingredientesSeleccionados.removeWhere((i) => i.ingredienteId == ingredienteId);
    notifyListeners();
  }

  // 🟢 CARGA DE RECETA (Modo Edición) corregido para manejar unidades
  Future<void> loadRecetaToEdit(int id) async {
    if (_idReceta == id) return; 

    clearForm(); 

    final detailsMap = await db.getRecetaDetails(id);
    
    if (detailsMap.isEmpty) {
      debugPrint('Error: Receta con ID $id no encontrada.');
      return;
    }
    
    final MapEntry<Receta, List<RecetaIngrediente>> entry = detailsMap.entries.first;
    final Receta receta = entry.key;
    final List<RecetaIngrediente> ingredientesDB = entry.value;

    _idReceta = receta.id;
    _nombre = receta.nombre;

    final List<int> idsNecesarios = ingredientesDB.map((ri) => ri.ingredienteId).toList();
    final List<Ingrediente> inventarioIngredientes = await db.getIngredientesByIds(idsNecesarios);

    final Map<int, Ingrediente> ingredienteMap = {
      for (var item in inventarioIngredientes) item.id: item
    };

    _ingredientesSeleccionados = ingredientesDB.map((ri) {
      final ingrediente = ingredienteMap[ri.ingredienteId];
      
      if (ingrediente == null) {
        debugPrint('Advertencia: Ingrediente ID ${ri.ingredienteId} no encontrado.');
        return null;
      }

      // 🟢 ASIGNACIÓN CORRECTA: Pasamos los datos puros al modelo.
      // Ya NO dividimos entre 1000 aquí. El RecipeIngredientModel detectará
      // si es 'und', 'g' o 'ml' y aplicará la fórmula correcta.
      return RecipeIngredientModel(
        ingredienteId: ri.ingredienteId,
        nombre: ingrediente.nombre,
        precioUnitario: ingrediente.costoUnitario,
        cantidadNecesaria: ri.cantidadNecesaria,
        stockInventario: ingrediente.cantidad,     // Nueva propiedad necesaria
        unidadMedida: ingrediente.unidadMedida,    // Nueva propiedad necesaria
      );
    }).whereType<RecipeIngredientModel>().toList();

    notifyListeners();
  }
  
  void clearForm() {
    _idReceta = null;
    _nombre = '';
    _ingredientesSeleccionados = [];
    notifyListeners();
  }

  // 🟢 PERSISTENCIA: Guardar Receta
  Future<void> guardarReceta(BuildContext context) async {
    final nombreReceta = _nombre.trim();
    if (nombreReceta.isEmpty || _ingredientesSeleccionados.isEmpty) {
      if (context.mounted) {
          NotificacionSnackBar.mostrarSnackBar(context, 'Debe ingresar un nombre y seleccionar ingredientes.');
      }
      return;
    }
    
    if (_idReceta != null) {
        await _actualizarReceta(context, nombreReceta);
        return;
    }

    try {
      final recetaCompanion = RecetasCompanion.insert(
        nombre: nombreReceta,
        costoTotal: costoTotal,
      );
      
      final ingredientesCompanion = _ingredientesSeleccionados.map((item) {
        return RecetaIngredientesCompanion(
          recetaId: const Value.absent(), 
          ingredienteId: Value(item.ingredienteId), 
          cantidadNecesaria: Value(item.cantidadNecesaria), 
        );
      }).toList();

      await db.saveRecetaTransaction(recetaCompanion, ingredientesCompanion);
      
      clearForm();
      if (context.mounted) {
        NotificacionSnackBar.mostrarSnackBar(context, 'Receta "$nombreReceta" creada con éxito!');
        Navigator.of(context).pop(); 
      }

    } catch (e) {
      if (context.mounted) {
          NotificacionSnackBar.mostrarSnackBar(context, 'Error al guardar la receta.');
      }
      debugPrint('Error al guardar la receta en DB: $e');
    }
  }

  // 🟢 ACTUALIZACIÓN
  Future<void> _actualizarReceta(BuildContext context, String nombreReceta) async {
    if (_idReceta == null) return;

    try {
      final recetaCompanion = Receta(
        id: _idReceta!,
        nombre: nombreReceta,
        costoTotal: costoTotal,
        fechaCreacion: DateTime.now(), 
      );

      final ingredientesCompanion = _ingredientesSeleccionados.map((item) {
        return RecetaIngredientesCompanion(
          recetaId: Value(_idReceta!),
          ingredienteId: Value(item.ingredienteId),
          cantidadNecesaria: Value(item.cantidadNecesaria),
        );
      }).toList();

      await db.updateRecetaTransaction(recetaCompanion, ingredientesCompanion);

      clearForm();
      if (context.mounted) {
        NotificacionSnackBar.mostrarSnackBar(context, 'Receta "$nombreReceta" actualizada con éxito!');
        Navigator.of(context).pop(); 
      }
      
    } catch (e) {
      if (context.mounted) {
          NotificacionSnackBar.mostrarSnackBar(context, 'Error al actualizar la receta.');
      }
      debugPrint('Error al actualizar la receta en DB: $e');
    }
  }

  Stream<List<Ingrediente>> watchInventarioIngredientes() {
    return db.watchInventarioIngredientes();
  }

  // 🟢 HELPER DE UI: Transforma Ingrediente de DB a Modelo de UI
  RecipeIngredientModel createModelFromIngrediente(Ingrediente ingrediente) {
    // Al añadir un ingrediente nuevo, inyectamos sus metadatos de unidad y stock
    return RecipeIngredientModel(
      ingredienteId: ingrediente.id,
      nombre: ingrediente.nombre,
      precioUnitario: ingrediente.costoUnitario,
      cantidadNecesaria: 0, 
      stockInventario: ingrediente.cantidad, 
      unidadMedida: ingrediente.unidadMedida,
    );
  }
}