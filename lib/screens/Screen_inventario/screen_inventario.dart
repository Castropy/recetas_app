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
        double precioVisual = (item.unidadMedida == 'und') 
            ? item.costoUnitario 
            : item.costoUnitario * 1000.0;
        return precioVisual.toStringAsFixed(2).contains(q);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: InventarioActionButtons(
        inventarioNotifier: inventarioNotifier,
        formVisibilityNotifier: context.watch<FormVisibilityNotifier>(),
      ),
      body: SafeArea(
        child: Consumer<FormVisibilityNotifier>(
          builder: (context, visibilityNotifier, child) {
            return Column(
              children: [
                const CustomSearchBar(),
                Expanded(
                  child: ListView(
                    // Mejoramos el scroll para que sea más fluido en iOS y Android
                    physics: const BouncingScrollPhysics(),
                    key: const PageStorageKey('inventario_scroll'),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    children: [
                      if (visibilityNotifier.isVisible) ...[
                        const SizedBox(height: 10),
                        // Envolvemos el formulario en un Card para separarlo visualmente de la lista
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: InventarioFormFields(inventarioNotifier: inventarioNotifier),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 15),
                      StreamBuilder<List<Ingrediente>>(
                        stream: db.ingredientesDao.watchInventarioIngredientes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: Column(
                                  children: [
                                    Icon(Icons.inventory_2_outlined, size: 70, color: Colors.grey[400]),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No hay ingredientes registrados.',
                                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final todos = snapshot.data!;

                          return Consumer<SearchNotifier>(
                            builder: (context, search, child) {
                              final filtrados = todos
                                  .where((item) => _filterItem(item, search.query, search.filter))
                                  .toList();

                              if (filtrados.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Center(
                                    child: Text('Sin resultados para la búsqueda.', 
                                      style: TextStyle(color: Colors.grey)),
                                  ),
                                );
                              }

                              return IngredienteListView(
                                key: const ValueKey('lista_ingredientes'),
                                ingredientes: filtrados,
                                notifier: inventarioNotifier,
                                visibilityNotifier: visibilityNotifier,
                                // Importante: Si IngredienteListView tiene su propio ListView interno, 
                                // asegúrate de que tenga shrinkWrap: true y physics: NeverScrollableScrollPhysics()
                              );
                            },
                          );
                        },
                      ),
                      // Espaciador final para que el FAB no tape el último ingrediente
                      const SizedBox(height: 120),
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