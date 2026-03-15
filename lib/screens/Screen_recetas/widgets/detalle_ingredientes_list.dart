import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';

/// Lista que gestiona la carga y visualización de los ingredientes de una receta.
/// 
/// Realiza una consulta secundaria para obtener los nombres de los ingredientes
/// basándose en los IDs proporcionados por la relación [RecetaIngrediente].
class DetalleIngredientesList extends StatelessWidget {
  final AppDatabase db;
  final List<RecetaIngrediente> ingredientesRelacion;

  const DetalleIngredientesList({
    super.key, 
    required this.db, 
    required this.ingredientesRelacion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Obtenemos los IDs para la consulta masiva
    final List<int> ids = ingredientesRelacion.map((ri) => ri.ingredienteId).toList();

    return FutureBuilder<List<Ingrediente>>(
      // Usamos el helper del DAO para traer todos los nombres de un solo golpe
      future: db.ingredientesDao.getIngredientesByIds(ids),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: LinearProgressIndicator()),
          );
        }

        // Mapeo O(1) para asociar IDs con nombres rápidamente
        final Map<int, Ingrediente> ingredienteMap = {
          for (var item in snapshot.data ?? []) item.id: item
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredientes Utilizados (${ingredientesRelacion.length}):',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ingredientesRelacion.length,
              itemBuilder: (context, index) {
                final ri = ingredientesRelacion[index];
                final nombre = ingredienteMap[ri.ingredienteId]?.nombre ?? 'Ingrediente Desconocido';

                return Card(
                  elevation: 0.5,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2_outlined, size: 20),
                    title: Text(
                      nombre, 
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Text(
                      'Cant: ${ri.cantidadNecesaria.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}