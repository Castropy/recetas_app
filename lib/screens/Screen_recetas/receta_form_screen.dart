// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/receta_form_notifier.dart';

// Importación de componentes encapsulados
import 'widgets/nombre_receta_field.dart';
import 'widgets/ingrediente_selector.dart';
import 'widgets/lista_ingredientes_seleccionados.dart';
import 'widgets/costo_total_section.dart';

/// Pantalla principal para la creación y edición de recetas.
/// 
/// Utiliza una arquitectura modular donde cada sección del formulario
/// está encapsulada en su propio widget dentro de la carpeta /widgets.
class RecetaFormScreen extends StatelessWidget {
  static const String routeName = 'receta_form';
  
  const RecetaFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ID de la receta si venimos de una edición
    final int? recetaId = ModalRoute.of(context)?.settings.arguments as int?;
    final notifier = Provider.of<RecetaFormNotifier>(context);
    final theme = Theme.of(context);

    // Inicialización de datos delegada a una microtarea para evitar conflictos de construcción
    _handleDataInitialization(notifier, recetaId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recetaId == null ? 'Crear Receta' : 'Editar Receta', 
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 28,
            color: Color.fromARGB(255, 45, 85, 216),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Campo de texto para el nombre
              NombreRecetaField(notifier: notifier),
              
              const SizedBox(height: 20),
              Text('Ingredientes Necesarios', style: theme.textTheme.titleMedium),
              const Divider(),
              
              // 2. Selector de ingredientes del inventario
              IngredienteSelector(notifier: notifier),
              
              const SizedBox(height: 10),
              
              // 3. Listado dinámico de ingredientes agregados
              ListaIngredientesSeleccionados(notifier: notifier),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // 4. Resumen de costos y botón de guardado persistente en la base
      bottomNavigationBar: CostoTotalSection(notifier: notifier),
    );
  }

  /// Gestiona la carga de datos inicial o la limpieza del formulario.
  void _handleDataInitialization(RecetaFormNotifier notifier, int? recetaId) {
    Future.microtask(() {
      if (recetaId != null) {
        notifier.loadRecetaToEdit(recetaId);
      } else {
        // Si no hay ID pero el notifier tiene datos antiguos, limpiamos
        if (notifier.idReceta != null) {
          notifier.clearForm();
        }
      }
    });
  }
}