import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'package:recetas_app/providers/search_notifier.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';

import 'package:recetas_app/widgets/inventario/ingrediente_list_view.dart';
import 'package:recetas_app/widgets/inventario/inventario_action_buttons.dart';
import 'package:recetas_app/widgets/shared/inventario_form_fields.dart';
import 'package:recetas_app/widgets/shared/custom_search_bar.dart';

class ScreenInventario extends StatelessWidget {
  const ScreenInventario({super.key});

  bool _filterItem(Ingrediente item, String query, SearchFilter filter) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();

    switch (filter) {
      case SearchFilter.nombre:
        return item.nombre.toLowerCase().contains(q);
      case SearchFilter.id:
        return item.id.toString().contains(q);
      case SearchFilter.precio:
        return item.costoUnitario.toStringAsFixed(2).contains(q);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos read para acciones puntuales, pero Consumer para la UI reactiva
    final inventarioNotifier = context.read<InventarioFormNotifier>();
    final db = context.read<AppDatabase>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Inventario',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: Color.fromARGB(255, 45, 85, 216),
          ),
        ),
        centerTitle: true,
      ),
      // Botones de acción (Guardar/Cerrar)
      floatingActionButton: InventarioActionButtons(
        inventarioNotifier: inventarioNotifier,
        formVisibilityNotifier: context.watch<FormVisibilityNotifier>(),
      ),
      body: SafeArea(
        child: Consumer<FormVisibilityNotifier>(
          builder: (context, visibilityNotifier, child) {
            return Column(
              children: [
                // 1. Buscador fijo arriba
                const CustomSearchBar(),

                // 2. Contenido con Scroll (Formulario + Lista)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    children: [
                      // Formulario dinámico
                      if (visibilityNotifier.isVisible) ...[
                        const SizedBox(height: 10),
                        
                        // 🟢 CLAVE: Consumer para que el formulario reaccione al cambio de unidad
                        Consumer<InventarioFormNotifier>(
                          builder: (context, notifier, child) {
                            return InventarioFormFields(inventarioNotifier: notifier);
                          },
                        ),
                        
                        const SizedBox(height: 10),
                      ],

                      const SizedBox(height: 15),

                      // 3. Lista de ingredientes desde la DB
                      StreamBuilder<List<Ingrediente>>(
                        stream: db.watchInventarioIngredientes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text('No hay ingredientes registrados.'),
                              ),
                            );
                          }

                          final todos = snapshot.data!;

                          // Filtrado reactivo mediante SearchNotifier
                          return Consumer<SearchNotifier>(
                            builder: (context, search, child) {
                              final filtrados = todos
                                  .where((item) => _filterItem(item, search.query, search.filter))
                                  .toList();

                              if (filtrados.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: Text(
                                      'No se hallaron resultados para "${search.query}"',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                );
                              }

                              return IngredienteListView(
                                ingredientes: filtrados,
                                notifier: inventarioNotifier,
                                visibilityNotifier: visibilityNotifier,
                              );
                            },
                          );
                        },
                      ),
                      // Espacio extra inferior
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}