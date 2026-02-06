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
    final inventarioNotifier = context.read<InventarioFormNotifier>();
    final searchNotifier = context.watch<SearchNotifier>();
    final db = context.read<AppDatabase>();

    final String currentQuery = searchNotifier.query;
    final SearchFilter currentFilter = searchNotifier.filter;

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ se adapta al teclado
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
      body: SafeArea(
        child: Consumer<FormVisibilityNotifier>(
          builder: (context, visibilityNotifier, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Formulario
                  if (visibilityNotifier.isVisible)
                    InventarioFormFields(inventarioNotifier: inventarioNotifier),

                  // 2. Botones de acción
                  InventarioActionButtons(
                    inventarioNotifier: inventarioNotifier,
                    formVisibilityNotifier: visibilityNotifier,
                  ),

                  // 3. StreamBuilder con lista
                  StreamBuilder<List<Ingrediente>>(
                    stream: db.watchInventarioIngredientes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No hay ingredientes registrados.'));
                      }

                      final todos = snapshot.data!;
                      final filtrados = todos
                          .where((item) =>
                              _filterItem(item, currentQuery, currentFilter))
                          .toList();

                      return Column(
                        children: [
                          if (todos.isNotEmpty) const CustomSearchBar(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: filtrados.isEmpty
                                ? Center(
                                    child: Text(
                                        'No se encontraron resultados para "$currentQuery".'),
                                  )
                                : IngredienteListView(
                                    ingredientes: filtrados,
                                    notifier: inventarioNotifier,
                                    visibilityNotifier: visibilityNotifier,
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}