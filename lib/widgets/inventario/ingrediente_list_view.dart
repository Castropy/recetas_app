import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Asegúrate de que esta ruta sea correcta para tu base de datos
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/widgets/shared/icon_button_custom.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart'; 

class IngredienteListView extends StatelessWidget {
  const IngredienteListView({super.key});

  // Marcamos la función como async para esperar la operación de la base de datos
  void deleteIngrediente(BuildContext context, int id) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    
    try {
      // Usamos await para esperar a que la operación de borrado se complete
      await database.deleteIngrediente(id);
      if (!context.mounted) return;
      
      // Mostrar notificación después de la eliminación exitosa
      // Usamos 'context' dentro del try para asegurar que la notificación se muestra solo si no hay error
      NotificacionSnackBar.mostrarSnackBar(context, 'Ingrediente eliminado exitosamente (ID: $id)');
    } catch (e) {
      // Manejo de errores básico
      if (!context.mounted) return;
      NotificacionSnackBar.mostrarSnackBar(context, 'Error al eliminar ingrediente: $e',);
      debugPrint('Error al eliminar ingrediente: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // El widget Listview necesita estar envuelto en algo flexible como Expanded
    return Expanded(
      child: StreamBuilder<List<Ingrediente>>(
        // Accede a la instancia de la DB a través del Provider
        stream: Provider.of<AppDatabase>(context).select(
          Provider.of<AppDatabase>(context).ingredientes
        ).watch(), 
        
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay ingredientes guardados.'));
          }

          final ingredientes = snapshot.data!;
          return ListView.builder(
            itemCount: ingredientes.length,
            itemBuilder: (context, index) {
              final ing = ingredientes[index];
              return ListTile(
                title: Text(
                  ing.nombre, 
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Id: ${ing.id} | Cant: ${ing.cantidad} | Precio: \$${ing.precio.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 2, 2, 2),
                    fontSize: 16,
                  ),
                ),
                // --- CAMBIO CLAVE: Botón de eliminación en el trailing ---
                trailing:  DeleteButton(
                  ingredienteId: ing.id,
                  onDelete: deleteIngrediente,
                ),
                // --------------------------------------------------------
              );
            },
          );
        },
      ),
    );
  }
}