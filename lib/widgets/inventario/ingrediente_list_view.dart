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
          Provider.of<AppDatabase>(context).ingredientes).watch(), 
        
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
              return Card(
                color: const Color.fromARGB(255, 23, 69, 150),
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(15.0),                 
                    ),   
                child: ListTile(
                title: Text(
                  ing.nombre, 
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 248, 246, 246),
                  ),
                ),
                subtitle: Text(
                  'Id: ${ing.id} | Stock: ${ing.cantidad} | Precio: \$${ing.precio.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 248, 246, 246),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // --- CAMBIO CLAVE: Botón de eliminación en el trailing ---
                trailing:  DeleteButton(
                  ingredienteId: ing.id,
                  onDelete: deleteIngrediente,
                ),
                // --------------------------------------------------------
              )); 
            },
          );
        },
      ),
    );
  }
}