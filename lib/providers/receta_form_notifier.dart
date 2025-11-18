
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/models/recipe_ingredient_model.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';

// Notifier que gestiona el estado temporal para crear o editar una Receta
class RecetaFormNotifier extends ChangeNotifier {
  final AppDatabase db;
  // Constructor: requiere la instancia de la base de datos para interactuar con ella.
  RecetaFormNotifier({required this.db});

  // --- Estado del Formulario ---
  String _nombre = '';
  // Lista de los ingredientes y cantidades seleccionados para la receta
  List<RecipeIngredientModel> _ingredientesSeleccionados = [];

  String get nombre => _nombre;
  List<RecipeIngredientModel> get ingredientesSeleccionados => _ingredientesSeleccionados;
  
  // Cálculo: suma de todos los costos subtotales de los ingredientes
  double get costoTotal {
    return _ingredientesSeleccionados.fold(0.0, (sum, item) => sum + item.costoSubtotal);
  }

  // --- Métodos de Actualización de UI/Estado ---
  void updateNombre(String value) {
    _nombre = value;
    notifyListeners();
  }

  // Agrega o actualiza un ingrediente en la lista de la receta
  void addIngredient(RecipeIngredientModel item) {
    final existingIndex = _ingredientesSeleccionados.indexWhere((i) => i.ingredienteId == item.ingredienteId);
    
    if (existingIndex >= 0) {
      if (item.cantidadNecesaria <= 0) {
        // Si ya existe y la cantidad es cero o menos, lo eliminamos
        _ingredientesSeleccionados.removeAt(existingIndex);
      } else {
        // Si ya existe y la cantidad es válida, lo actualizamos
        _ingredientesSeleccionados[existingIndex] = item;
      }
    } else {
      // Si es nuevo y la cantidad es válida, lo agregamos
      if (item.cantidadNecesaria > 0) {
        _ingredientesSeleccionados.add(item);
      }
    }
    notifyListeners();
  }

  // Elimina un ingrediente por su ID
  void removeIngredient(int ingredienteId) {
    _ingredientesSeleccionados.removeWhere((i) => i.ingredienteId == ingredienteId);
    notifyListeners();
  }
  
  // Limpia el estado del formulario después de guardar o cancelar
  void clearForm() {
    _nombre = '';
    _ingredientesSeleccionados = [];
    notifyListeners();
  }

  // --- Lógica de Guardado en la Base de Datos ---
  Future<void> guardarReceta(BuildContext context) async {
    final nombreReceta = _nombre.trim();
    if (nombreReceta.isEmpty || _ingredientesSeleccionados.isEmpty) {
      if (context.mounted) {
         NotificacionSnackBar.mostrarSnackBar(context, 'Debe ingresar un nombre y seleccionar ingredientes.');
      }
      return;
    }
    
    try {
      // 1. Crear el objeto Companion de la Receta principal
      final recetaCompanion = RecetasCompanion.insert(
        nombre: nombreReceta,
        costoTotal: costoTotal,
      );
      
      // 2. Crear los objetos Companion de la tabla de unión (RecetaIngredientes)
      final ingredientesCompanion = _ingredientesSeleccionados.map((item) {
  // Usamos el constructor sin '.insert', que acepta valores no opcionales
  // con tipos primitivos.
     return RecetaIngredientesCompanion(
       recetaId: const Value.absent(), // Mantenemos Value.absent() para la FK que se asigna después.
       ingredienteId: Value(item.ingredienteId), // Pasamos INT directamente
       cantidadNecesaria: Value(item.cantidadNecesaria), // Pasamos DOUBLE directamente
        );
     }).toList();

      // 3. Ejecutar la transacción atómica para guardar ambos sets de datos
      await db.createReceta(recetaCompanion, ingredientesCompanion);
      
      // 4. Limpiar y notificar al usuario
      final savedName = nombreReceta;
      clearForm();
      if (context.mounted) {
        NotificacionSnackBar.mostrarSnackBar(context, 'Receta "$savedName" creada con éxito!');
        // Regresar a la pantalla de listado de recetas
        Navigator.of(context).pop(); 
      }

    } catch (e) {
      if (context.mounted) {
         NotificacionSnackBar.mostrarSnackBar(context, 'Error al guardar la receta.');
      }
      debugPrint('Error al guardar la receta en DB: $e');
    }
  }

  // --- Helper para la UI de Selección de Ingredientes ---
  // Obtiene todos los ingredientes del inventario (Ingredientes de la DB)
  Stream<List<Ingrediente>> watchInventarioIngredientes() {
    return db.watchInventarioIngredientes();
  }
}