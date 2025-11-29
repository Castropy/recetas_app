import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart'; // Necesario para el StreamBuilder
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'package:recetas_app/providers/search_notifier.dart'; 
import 'package:recetas_app/providers/form_visibility_notifier.dart';

// Importaciones originales del código "Antes"
import 'package:recetas_app/widgets/inventario/ingrediente_list_view.dart';
import 'package:recetas_app/widgets/inventario/inventario_action_buttons.dart';
import 'package:recetas_app/widgets/shared/inventario_form_fields.dart';

// 🆕 Importar el widget de búsqueda
import 'package:recetas_app/widgets/shared/custom_search_bar.dart'; 


// 🟢 Se elimina InventarioScreenWrapper y la definición local de FormularioInventario 
// y IngredienteListView, confiando en las importaciones originales.

class ScreenInventario extends StatelessWidget {
  const ScreenInventario({super.key});

  // 🟢 Lógica de Filtrado (movida fuera de build)
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
    // Acceder a notifiers. Usamos read para escritura, watch/Consumer para lectura.
    final inventarioNotifier = context.read<InventarioFormNotifier>(); 
    //final formVisibilityNotifier = context.read<FormVisibilityNotifier>();
    
    // Necesitamos que el SearchNotifier y FormVisibilityNotifier notifiquen cambios
    final searchNotifier = context.watch<SearchNotifier>(); // Leer query y filtro
    final db = context.read<AppDatabase>(); // Leer instancia de DB

    final String currentQuery = searchNotifier.query;
    final SearchFilter currentFilter = searchNotifier.filter;

    return Scaffold(
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
      
      // 🟢 USAMOS CONSUMER para la visibilidad del formulario (Estructura "Antes")
      body: Consumer<FormVisibilityNotifier>(
        builder: (context, visibilityNotifier, child) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                // 1. CAMPOS DE FORMULARIO (Estructura "Antes")
                if (visibilityNotifier.isVisible)
                  InventarioFormFields(inventarioNotifier: inventarioNotifier),
                
                // 2. BOTONES DE ACCIÓN (Estructura "Antes")
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: InventarioActionButtons(
                    inventarioNotifier: inventarioNotifier,
                    formVisibilityNotifier: visibilityNotifier,
                  ),
                ),
                
                // 3. STREAMBUILDER, BUSCADOR Y LISTA FILTRADA (Estructura "Ahora")
                Expanded(
                  child: StreamBuilder<List<Ingrediente>>(
                    stream: db.watchInventarioIngredientes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No hay ingredientes registrados.'));
                      }

                      final List<Ingrediente> todos = snapshot.data!;
                      
                      // 🟢 Aplicación del filtro usando el estado de SearchNotifier
                      final List<Ingrediente> filtrados = todos.where((item) => 
                         _filterItem(item, currentQuery, currentFilter)
                      ).toList();

                      return Column(
                        children: [
                          // Barra de Búsqueda (aparece si hay datos)
                          if (todos.isNotEmpty)
                            const CustomSearchBar(),
                          
                          Expanded(
                            child: filtrados.isEmpty
                                ? Center(child: Text('No se encontraron resultados para "$currentQuery".'))
                                : 
                                // 🟢 Usamos tu IngredienteListView importado, pasándole los datos filtrados
                                IngredienteListView(
                                    ingredientes: filtrados, 
                                    notifier: inventarioNotifier,
                                    visibilityNotifier: visibilityNotifier,
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}