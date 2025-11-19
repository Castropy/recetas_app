import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart'; // Importa la DB

class DetalleRecetaScreen extends StatelessWidget {
  static const String routeName = 'detalle_receta';

  const DetalleRecetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // El ID de la receta se pasa como argumento de la ruta
    final int? recetaId = ModalRoute.of(context)?.settings.arguments as int?;

    if (recetaId == null) {
      return const Scaffold(
        
        body: Center(child: Text('ID de receta no proporcionado.')),
      );
    }

    // Instancia de la base de datos inyectada con Provider
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Receta'),
      ),
      // Usamos FutureBuilder para esperar el resultado de la consulta a la DB
      body: FutureBuilder<Map<Receta, List<RecetaIngrediente>>>(
        // Llama al nuevo método para obtener la receta y sus ingredientes
        future: db.getRecetaDetails(recetaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se pudo cargar el detalle de la receta.'));
          }

          final MapEntry<Receta, List<RecetaIngrediente>> entry = snapshot.data!.entries.first;
          final Receta receta = entry.key;
          final List<RecetaIngrediente> ingredientes = entry.value;

          return _RecetaDetailBody(receta: receta, ingredientesReceta: ingredientes, db: db);
        },
      ),
    );
  }
}

class _RecetaDetailBody extends StatelessWidget {
  final Receta receta;
  // Renombramos a 'ingredientesReceta' para mayor claridad
  final List<RecetaIngrediente> ingredientesReceta; 
  final AppDatabase db;

  const _RecetaDetailBody({
    required this.receta,
    required this.ingredientesReceta,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Paso 1: Obtener todos los IDs de ingredientes necesarios
    final List<int> ids = ingredientesReceta.map((ri) => ri.ingredienteId).toList();

    // 🟢 Paso 2: Usar FutureBuilder para buscar TODOS los objetos Ingrediente (Nombres)
    return FutureBuilder<List<Ingrediente>>(
      future: db.getIngredientesByIds(ids), 
      builder: (context, snapshotIngredientes) {
        // Mantenemos la lógica de carga para esta segunda consulta
        if (snapshotIngredientes.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); 
        }

        // Convertir la lista de Ingredientes en un Map para búsqueda O(1) por ID
        final Map<int, Ingrediente> ingredienteMap = {
          for (var item in snapshotIngredientes.data ?? []) item.id: item
        };

        // 🟢 Paso 3: Renderizado de la UI (Ahora todos los datos están disponibles)
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la Receta
              Text(
                receta.nombre,
                style: theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Costo Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Costo de Producción:', style: TextStyle(fontSize: 16)),
                  Text(
                    '\$${receta.costoTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),

              // Sección de Ingredientes
              Text(
                'Ingredientes Utilizados (${ingredientesReceta.length}):',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),

              // Lista de Ingredientes (sin FutureBuilder anidado)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ingredientesReceta.length,
                itemBuilder: (context, index) {
                  final RecetaIngrediente ri = ingredientesReceta[index];
                  
                  // 🟢 ¡Optimizado! Acceso instantáneo al nombre usando el Map
                  final String nombre = ingredienteMap[ri.ingredienteId]?.nombre ?? 'Ingrediente Desconocido';
                  
                  // Se puede calcular el subtotal aquí si el precio unitario se almacenara
                  // en RecetaIngrediente, pero por ahora solo mostramos el nombre y cantidad.
                  
                  return Card(
                    elevation: 0.5,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Text(
                        'Cantidad: ${ri.cantidadNecesaria.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// NOTA: Para que funcione, tienes que añadir este helper en database.dart
/*
  Future<Ingrediente?> getIngredienteById(int id) {
    return (select(ingredientes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
*/