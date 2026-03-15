import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/screens/Screen_recetas/widgets/detalle_ingredientes_list.dart';
import 'package:recetas_app/screens/Screen_recetas/widgets/detalle_receta_header.dart';


/// Pantalla que muestra la información detallada de una receta.
/// 
/// Se encarga de la obtención inicial de los datos de la receta y 
/// delega la representación visual a componentes especializados.
class DetalleRecetaScreen extends StatelessWidget {
  static const String routeName = 'detalle_receta';

  const DetalleRecetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ID de la receta desde los argumentos de la ruta
    final int? recetaId = ModalRoute.of(context)?.settings.arguments as int?;
    final db = Provider.of<AppDatabase>(context);

    if (recetaId == null) {
      return const Scaffold(
        body: Center(child: Text('ID de receta no proporcionado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Receta'),
      ),
      body: FutureBuilder<Map<Receta, List<RecetaIngrediente>>>(
        // Obtenemos la receta y su relación de ingredientes desde el DAO
        future: db.recetasDao.getRecetaDetails(recetaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No se pudo cargar el detalle de la receta.'),
            );
          }

          // Extraemos los datos del Map devuelto por el DAO
          final entry = snapshot.data!.entries.first;
          final receta = entry.key;
          final ingredientesRelacion = entry.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Cabecera con Nombre y Costo Total
                DetalleRecetaHeader(receta: receta),
                
                const Divider(height: 30),

                // 2. Lista de ingredientes con carga de nombres optimizada
                DetalleIngredientesList(
                  db: db, 
                  ingredientesRelacion: ingredientesRelacion,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}