import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/search_notifier.dart';
import 'package:recetas_app/screens/Screen_recetas/receta_form_screen.dart';
import 'package:recetas_app/screens/Screen_recetas/detalle_receta_screen.dart';
import 'package:recetas_app/widgets/shared/confirm_delete_dialog.dart';
import 'package:recetas_app/widgets/shared/custom_search_bar.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';

class ScreenRecetas extends StatelessWidget {
  const ScreenRecetas({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final theme = Theme.of(context);
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
      body: Column(
        children: [
          const CustomSearchBar(),
          Expanded(
            child: StreamBuilder<List<Receta>>(
              stream: db.recetasDao.watchAllRecetasFiltered(
                searchNotifier.query,
                searchNotifier.filter,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Optimizamos con LayoutBuilder y SingleChildScrollView para evitar overflow vertical
                  return LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book, size: 80, color: theme.colorScheme.primary),
                            const SizedBox(height: 10),
                            Text(
                              searchNotifier.query.isEmpty
                                  ? 'No hay recetas aún.'
                                  : 'No se encontraron recetas.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            if (searchNotifier.query.isEmpty)
                              const Text(
                                'Presiona "+" para añadir una nueva receta.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final recetas = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80), // Espacio para el FAB
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
                          child: FittedBox( // Asegura que el ID quepa siempre
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('${receta.id}', style: const TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        title: Text(
                          receta.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Evita que nombres largos rompan el diseño
                        ),
                        subtitle: Text(
                          'Costo: \$${receta.costoTotal.toStringAsFixed(2)}',
                          maxLines: 1,
                        ),
                        // Usamos un Row con mainAxisSize min para los botones
                        trailing: Wrap( // Wrap es más seguro que Row para evitar overflows horizontales
                          spacing: -8, // Ajuste para que no se vea muy separado
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, color: Colors.blueGrey),
                              onPressed: () => Navigator.pushNamed(
                                context, 
                                DetalleRecetaScreen.routeName, 
                                arguments: receta.id
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => Navigator.pushNamed(
                                context, 
                                RecetaFormScreen.routeName, 
                                arguments: receta.id
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirmed = await showConfirmDeleteDialog(
                                  context,
                                  itemName: receta.nombre,
                                );
                                if (confirmed == true) {
                                  await db.recetasDao.deleteRecetaTransaction(receta.id);
                                  if (context.mounted) {
                                    NotificacionSnackBar.mostrarSnackBar(
                                      context, 
                                      'Receta "${receta.nombre}" eliminada.'
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
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
        heroTag: 'addRecetaButton',
        backgroundColor: theme.colorScheme.primary,
        onPressed: () => Navigator.pushNamed(context, RecetaFormScreen.routeName),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}