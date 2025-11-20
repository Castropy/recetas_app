
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/models/recipe_ingredient_model.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';

// Notifier que gestiona el estado temporal para crear o editar una Receta
 
class RecetaFormNotifier extends ChangeNotifier {
  final AppDatabase db;
  RecetaFormNotifier({required this.db});

  // --- Estado del Formulario ---
  //  Almacena el ID de la receta que se está editando
  int? _idReceta; 
  String _nombre = '';
  List<RecipeIngredientModel> _ingredientesSeleccionados = [];

  // Getter para acceder al ID (indica si estamos editando)
  int? get idReceta => _idReceta; 
  String get nombre => _nombre;
  List<RecipeIngredientModel> get ingredientesSeleccionados => _ingredientesSeleccionados;

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

  
  
  // ... (costoTotal, updateNombre, addIngredient, removeIngredient, watchInventarioIngredientes)

 // 🟢 Nuevo: Limpia y Carga la Receta Existente (Modo Edición)
Future<void> loadRecetaToEdit(int id) async {
  // Si ya estamos editando esta misma receta, no hacemos nada.
  if (_idReceta == id) return; 

  clearForm(); // Limpia el estado actual antes de cargar

  // 1. Obtener la Receta principal y sus entradas de unión (RecetaIngrediente)
  final detailsMap = await db.getRecetaDetails(id);
  
  if (detailsMap.isEmpty) {
    debugPrint('Error: Receta con ID $id no encontrada.');
    return;
  }
  
  final MapEntry<Receta, List<RecetaIngrediente>> entry = detailsMap.entries.first;
  final Receta receta = entry.key;
  final List<RecetaIngrediente> ingredientesDB = entry.value;

  // A. Actualizar el ID y Nombre de la Receta
  _idReceta = receta.id;
  _nombre = receta.nombre;

  // 2. Optimización: Obtener todos los objetos Ingrediente (Nombres y Precios Unitarios)
  final List<int> idsNecesarios = ingredientesDB.map((ri) => ri.ingredienteId).toList();
  // 🟢 Usamos la consulta optimizada por lote (JOIN/IN)
  final List<Ingrediente> inventarioIngredientes = await db.getIngredientesByIds(idsNecesarios);

  // 3. Crear un mapa para acceso rápido O(1)
  final Map<int, Ingrediente> ingredienteMap = {
    for (var item in inventarioIngredientes) item.id: item
  };

  // 4. Transformar los datos de la DB a Modelos de Receta
  _ingredientesSeleccionados = ingredientesDB.map((ri) {
    final ingrediente = ingredienteMap[ri.ingredienteId];
    
    // Si el ingrediente se eliminó del inventario, lo marcamos como desconocido o lo ignoramos.
    if (ingrediente == null) {
      debugPrint('Advertencia: Ingrediente ID ${ri.ingredienteId} no encontrado en el inventario.');
      return null;
    }
    
    final double precioUnitario = ingrediente.cantidad > 0 
        ? (ingrediente.precio / ingrediente.cantidad) 
        : 0.0;

    return RecipeIngredientModel(
      ingredienteId: ri.ingredienteId,
      nombre: ingrediente.nombre,
      precioUnitario: precioUnitario,
      cantidadNecesaria: ri.cantidadNecesaria,
    );
  }).whereType<RecipeIngredientModel>().toList(); // Filtramos cualquier elemento nulo

  notifyListeners();
}
  
  // 3. Modificación de clearForm para resetear el ID
  void clearForm() {
    _idReceta = null; // 🟢 Resetear el ID al limpiar
    _nombre = '';
    _ingredientesSeleccionados = [];
    notifyListeners();
  }

  // 4. 🟢 Modificación: Ahora maneja Inserción Y Actualización
  Future<void> guardarReceta(BuildContext context) async {
    final nombreReceta = _nombre.trim();
    if (nombreReceta.isEmpty || _ingredientesSeleccionados.isEmpty) {
      // ... (Mostrar SnackBar de error)
      if (context.mounted) {
          NotificacionSnackBar.mostrarSnackBar(context, 'Debe ingresar un nombre y seleccionar ingredientes.');
      }
      return;
    }
    
    // 🔔 Lógica de Actualización: Si existe el ID, llamamos a la DB para actualizar
    if (_idReceta != null) {
        await _actualizarReceta(context, nombreReceta);
        return;
    }

    // 🔔 Lógica de Inserción: Si _idReceta es null, procedemos a insertar (lógica existente)
    // ... (Tu código de inserción actual aquí)

    try {
      // ... (Código para crear recetaCompanion y ingredientesCompanion)
      
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
      
      // ... (Limpiar y notificar - Inserción)
      final savedName = nombreReceta;
      clearForm();
      if (context.mounted) {
        NotificacionSnackBar.mostrarSnackBar(context, 'Receta "$savedName" creada con éxito!');
        Navigator.of(context).pop(); 
      }

    } catch (e) {
      if (context.mounted) {
          NotificacionSnackBar.mostrarSnackBar(context, 'Error al guardar la receta.');
      }
      debugPrint('Error al guardar la receta en DB: $e');
    }
  }

  // 5. 🟢 Nuevo: Implementación de la Actualización
  Future<void> _actualizarReceta(BuildContext context, String nombreReceta) async {
    if (_idReceta == null) return; // Seguridad

    try {
      // 1. Crear el Companion de la Receta principal (para UPDATE)
      final recetaCompanion = Receta(
        id: _idReceta!, // Usamos el ID existente
        nombre: nombreReceta,
        costoTotal: costoTotal,
        fechaCreacion: DateTime.now(), // La fecha de creación la puedes mantener o actualizar
      );

      // 2. Crear los Companion de la tabla de unión (RecetaIngredientes)
      final ingredientesCompanion = _ingredientesSeleccionados.map((item) {
        // En este punto, no se requiere el RecetaId en el Companion porque 
        // la función de actualización de DB lo manejará.
        return RecetaIngredientesCompanion(
          recetaId: Value(_idReceta!), // Importante: Inyectamos el ID existente
          ingredienteId: Value(item.ingredienteId),
          cantidadNecesaria: Value(item.cantidadNecesaria),
        );
      }).toList();

      // 3. Llamar a una nueva transacción de actualización en la DB (a implementar)
      await db.updateRecetaTransaction(recetaCompanion, ingredientesCompanion);

      // 4. Limpiar y notificar
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
  // ... (Helper para la UI de Selección de Ingredientes: watchInventarioIngredientes)
}