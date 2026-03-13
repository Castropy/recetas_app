import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/data/daos/recetas_dao.dart'; // 🟢 IMPORTANTE: Para InsufficientStockException
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';

class VenderNotifier extends ChangeNotifier {
  final AppDatabase db;
  VenderNotifier({required this.db});

  final List<Receta> _recetasSeleccionadas = [];
  List<Receta> get recetasSeleccionadas => _recetasSeleccionadas;

  // 🛠️ CORRECCIÓN: Apuntar al DAO de recetas
  Stream<List<Receta>> watchAllRecetas() => db.recetasDao.watchAllRecetas();

  void toggleRecetaSelection(Receta receta) {
    if (_recetasSeleccionadas.contains(receta)) {
      _recetasSeleccionadas.remove(receta);
    } else {
      _recetasSeleccionadas.add(receta);
    }
    notifyListeners();
  }

  Future<void> venderRecetas(BuildContext context) async {
    if (_recetasSeleccionadas.isEmpty) {
      if (context.mounted) {
        NotificacionSnackBar.mostrarSnackBar(context, 'Por favor, selecciona al menos una receta para vender.');
      }
      return;
    }

    final List<Receta> recetasVendidasConExito = [];

    for (final receta in List<Receta>.from(_recetasSeleccionadas)) {
      try {
        // 🛠️ CORRECCIÓN: db -> db.recetasDao
        await db.recetasDao.venderRecetaTransaction(receta.id);

        recetasVendidasConExito.add(receta);
      } on InsufficientStockException catch (e) {
        if (context.mounted) {
            NotificacionSnackBar.mostrarSnackBar(
                context,
                'No se pudo vender "${receta.nombre}": ${e.toString()}',
            );
        }
        return; 
      } catch (e) {
        if (context.mounted) {
            NotificacionSnackBar.mostrarSnackBar(context, 'Error inesperado al vender ${receta.nombre}: $e');
        }
        return;
      }
    }
    
    if (recetasVendidasConExito.isNotEmpty) {
        if (context.mounted) {
            NotificacionSnackBar.mostrarSnackBar(
                context, 
                'Venta de ${recetasVendidasConExito.length} receta(s) exitosa. Inventario actualizado.'
            );
        }
        _recetasSeleccionadas.clear();
        notifyListeners();
    }
  }
}