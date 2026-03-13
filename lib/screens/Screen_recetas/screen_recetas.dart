import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/search_notifier.dart'; // 🟢 NUEVO: Importar SearchNotifier
import 'package:recetas_app/screens/Screen_recetas/detalle_receta_screen.dart';
import 'package:recetas_app/screens/Screen_recetas/receta_form_screen.dart';
//import 'package:recetas_app/widgets/reporte/custom_search_bar.dart'; // 🟢 NUEVO: Importar CustomSearchBar
import 'package:recetas_app/widgets/shared/confirm_delete_dialog.dart';
import 'package:recetas_app/widgets/shared/custom_search_bar.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';
//import 'package:recetas_app/widgets/shared/custom_app_bar.dart';

class ScreenRecetas extends StatelessWidget {
  const ScreenRecetas({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final theme = Theme.of(context);
    // 🟢 NUEVO: Escuchar el Notifier para obtener el estado de la búsqueda
    final searchNotifier = context.watch<SearchNotifier>();

    return Scaffold(

     appBar: AppBar(
        title: const Text(
          'Recetas',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: Color.fromARGB(255, 45, 85, 216),
          ),
        ),
        centerTitle: true,
      ),
      body: Column( // 🟢 CAMBIO: Usamos Column para colocar la barra de búsqueda arriba
        children: [
          
          // 🟢 NUEVO: Colocar la barra de búsqueda en la parte superior
          const CustomSearchBar(), 

          // 🟢 CAMBIO: Envolvemos el StreamBuilder en Expanded para que ocupe el espacio restante
          Expanded(
            child: StreamBuilder<List<Receta>>(
              // 🟢 CAMBIO CLAVE: Usamos el stream filtrado con los valores del Notifier
              stream: db.recetasDao.watchAllRecetasFiltered(
                searchNotifier.query,
                searchNotifier.filter,
              ),
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
                        // Mensaje ajustado para mostrar si no hay resultados por búsqueda
                        Text(
                          searchNotifier.query.isEmpty
                              ? 'No hay recetas aún.'
                              : 'No se encontraron recetas con la búsqueda actual.',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        if (searchNotifier.query.isEmpty)
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
                          child: Text('${receta.id}', style: const TextStyle(color: Colors.white)), // Usar ID para ser consistente con el filtro
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
                                  arguments: receta.id
                                );
                              },
                            ),
                            IconButton(
                              // Botón de Edición
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                 Navigator.pushNamed(
                                  context, 
                                  RecetaFormScreen.routeName, 
                                  arguments: receta.id
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // 1. Llamar al diálogo y esperar la confirmación
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  itemName: receta.nombre,
                                );

                                // 2. Si se confirma (es 'true'), se procede a la eliminación
                                if (confirmed == true) {
                                  // Ejecuta la transacción de eliminación en la DB
                                  await db.recetasDao.deleteRecetaTransaction(receta.id);

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
          ),
        ],
      ),
      // Botón para navegar al formulario de creación
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(),
        heroTag: 'addRecetaButton',
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          // Navegar al formulario de creación de recetas
          Navigator.pushNamed(context, RecetaFormScreen.routeName);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}