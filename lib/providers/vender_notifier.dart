import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart'; // Asegúrate de que la ruta sea correcta

class VenderNotifier extends ChangeNotifier {
  final AppDatabase db;
  VenderNotifier({required this.db});

  final List<Receta> _recetasSeleccionadas = [];
  List<Receta> get recetasSeleccionadas => _recetasSeleccionadas;

  // Stream para obtener todas las recetas disponibles
  Stream<List<Receta>> watchAllRecetas() => db.watchAllRecetas();

  // 🟢 1. Lógica para seleccionar/deseleccionar una receta
  void toggleRecetaSelection(Receta receta) {
    if (_recetasSeleccionadas.contains(receta)) {
      _recetasSeleccionadas.remove(receta);
    } else {
      _recetasSeleccionadas.add(receta);
    }
    notifyListeners();
  }

  // 🟢 2. Ejecutar la Venta
  // vender_notifier.dart

// ... (inicio de la clase VenderNotifier)

  // 🟢 2. Ejecutar la Venta
  Future<void> venderRecetas(BuildContext context) async {
    if (_recetasSeleccionadas.isEmpty) {
      if (context.mounted) { // 👈 AGREGAR CHECK
        NotificacionSnackBar.mostrarSnackBar(context, 'Por favor, selecciona al menos una receta para vender.');
      }
      return;
    }

    // Usaremos un Set para rastrear las recetas que se vendieron con éxito
    final List<Receta> recetasVendidasConExito = [];

    // Iteramos sobre una copia de la lista seleccionada para poder modificar la original si falla.
    for (final receta in List<Receta>.from(_recetasSeleccionadas)) {
      try {
        await db.venderRecetaTransaction(receta.id); // 👈 EL GAP ASÍNCRONO ESTÁ AQUÍ

        recetasVendidasConExito.add(receta);
      } on InsufficientStockException catch (e) {
        
        // 🟢 3. Manejo del Error Condicional
        if (context.mounted) { // 👈 AGREGAR CHECK ANTES DE USAR CONTEXT
            NotificacionSnackBar.mostrarSnackBar(
                context,
                'No se pudo vender "${receta.nombre}": ${e.toString()}',
                // Usa un color de error si tu Snackbar lo soporta
            );
        }
        
        // Si falla una, detenemos la venta para no procesar las demás y revisamos inventario.
        return; 
      } catch (e) {
        // Manejar otros errores (DB, red, etc.)
        if (context.mounted) { // 👈 AGREGAR CHECK ANTES DE USAR CONTEXT
            NotificacionSnackBar.mostrarSnackBar(context, 'Error inesperado al vender ${receta.nombre}: $e');
        }
        return;
      }
    }
    
    // Si llegamos aquí, todas las recetas se vendieron con éxito
    if (recetasVendidasConExito.isNotEmpty) {
        if (context.mounted) { // 👈 AGREGAR CHECK ANTES DE USAR CONTEXT
            NotificacionSnackBar.mostrarSnackBar(
                context, 
                'Venta de ${recetasVendidasConExito.length} receta(s) exitosa. Inventario actualizado.'
            );
        }
        // Limpiar la selección solo después de una venta completa y exitosa
        _recetasSeleccionadas.clear();
        notifyListeners();
    }
  }
}