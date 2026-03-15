import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';

// Importación simplificada mediante Barrel File
import 'widgets/widgets.dart'; 
import 'package:recetas_app/widgets/shared/custom_search_bar.dart';

/// Pantalla principal del Inventario.
/// 
/// Orquesta la visualización de ingredientes, la búsqueda y el formulario
/// de gestión mediante una estructura modular y el uso de un Barrel File para widgets.
class ScreenInventario extends StatelessWidget {
  const ScreenInventario({super.key});

  @override
  Widget build(BuildContext context) {
    final inventarioNotifier = context.read<InventarioFormNotifier>();
    final visibilityNotifier = context.watch<FormVisibilityNotifier>();

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
        formVisibilityNotifier: visibilityNotifier,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const CustomSearchBar(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                key: const PageStorageKey('inventario_scroll'),
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                children: [
                  // Formulario encapsulado
                  InventarioFormContainer(
                    visibilityNotifier: visibilityNotifier,
                    inventarioNotifier: inventarioNotifier,
                  ),

                  const SizedBox(height: 15),

                  // Vista de datos y lógica de filtrado
                  const InventarioDataView(),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}