import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/screens/Screen_recetas/detalle_receta_screen.dart';
import 'package:recetas_app/screens/Screen_recetas/receta_form_screen.dart';
import 'package:recetas_app/widgets/shared/confirm_delete_dialog.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';
//import 'package:recetas_app/widgets/shared/custom_app_bar.dart';
 
class ScreenRecetas extends StatelessWidget {
  const ScreenRecetas({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final theme = Theme.of(context);

    return Scaffold(
      
      // Escucha en tiempo real todos los cambios en la tabla de recetas
      body: StreamBuilder<List<Receta>>(
        stream: db.watchAllRecetas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 80, color: theme.colorScheme.primary),
                  const SizedBox(height: 10),
                  const Text('No hay recetas aún.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const Text('Presiona "+" para añadir una nueva receta.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final recetas = snapshot.data!;
          return ListView.builder(
            itemCount: recetas.length,
            itemBuilder: (context, index) {
              final receta = recetas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(
                    receta.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Muestra el costo total calculado al guardar
                  subtitle: Text('Costo de Producción: \$${receta.costoTotal.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        color: Colors.blueGrey,
                        onPressed: () {
                           Navigator.pushNamed(
                            context, 
                            DetalleRecetaScreen.routeName, 
                            arguments: receta.id // Pasamos el ID de la receta
                          );
                          
                        },
                      ),
                      IconButton(
                        // 🟢 Nuevo: Botón de Edición
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                           Navigator.pushNamed(
                            context, 
                            RecetaFormScreen.routeName, 
                            arguments: receta.id // Pasamos el ID de la receta para edición
                          );
                        },
                      ),
                     IconButton(
                       icon: const Icon(Icons.delete, color: Colors.red),
                       onPressed: () async {
                       // 🟢 1. Llamar al diálogo y esperar la confirmación
                       final confirmed = await showConfirmDeleteDialog(
                       context,
                       itemName: receta.nombre,
                      );

                    // 🟢 2. Si se confirma (es 'true'), se procede a la eliminación
                      if (confirmed == true) {
                    // Ejecuta la transacción de eliminación en la DB
                      db.deleteRecetaTransaction(receta.id);

                      // Muestra un mensaje de éxito
                      if (context.mounted) {
                      NotificacionSnackBar.mostrarSnackBar(
                        context, 
                        'Receta "${receta.nombre}" eliminada con éxito.'
                       );
                     }
               }
    },
  ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // Botón para navegar al formulario de creación
      floatingActionButton: FloatingActionButton(
        heroTag: 'addRecetaButton',
        backgroundColor: theme.colorScheme.secondary,
        onPressed: () {
          // Navegar al formulario de creación de recetas
          Navigator.pushNamed(context, RecetaFormScreen.routeName);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
    
  