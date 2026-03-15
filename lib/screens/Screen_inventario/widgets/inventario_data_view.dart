import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/search_notifier.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'ingrediente_list_view.dart';

/// Widget responsable de gestionar el flujo de datos del inventario.
/// 
/// Escucha el Stream de la base de datos, aplica los filtros de búsqueda
/// y gestiona los estados de carga, lista vacía y resultados encontrados.
class InventarioDataView extends StatelessWidget {
  const InventarioDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final inventarioNotifier = context.read<InventarioFormNotifier>();
    final visibilityNotifier = context.watch<FormVisibilityNotifier>();

    return StreamBuilder<List<Ingrediente>>(
      stream: db.ingredientesDao.watchInventarioIngredientes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final todos = snapshot.data!;

        return Consumer<SearchNotifier>(
          builder: (context, search, child) {
            final filtrados = todos.where((item) {
              return _applyFilter(item, search.query, search.filter);
            }).toList();

            if (filtrados.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    'Sin resultados para la búsqueda.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            return IngredienteListView(
              key: const ValueKey('lista_ingredientes'),
              ingredientes: filtrados,
              notifier: inventarioNotifier,
              visibilityNotifier: visibilityNotifier,
            );
          },
        );
      },
    );
  }

  /// Lógica de filtrado desacoplada de la UI principal.
  bool _applyFilter(Ingrediente item, String query, SearchFilter filter) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();

    switch (filter) {
      case SearchFilter.nombre:
        return item.nombre.toLowerCase().contains(q);
      case SearchFilter.id:
        return item.id.toString().contains(q);
      case SearchFilter.precio:
        double precioVisual = (item.unidadMedida == 'und') 
            ? item.costoUnitario 
            : item.costoUnitario * 1000.0;
        return precioVisual.toStringAsFixed(2).contains(q);
    }
  }

  /// Estado visual cuando no hay registros en la base de datos.
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 70, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No hay ingredientes registrados.',
              style: TextStyle(
                fontSize: 16, 
                color: Colors.grey, 
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}