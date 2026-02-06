import 'package:flutter/material.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart'; 
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart'; 

class InventarioActionButtons extends StatelessWidget {
  final InventarioFormNotifier inventarioNotifier;
  final FormVisibilityNotifier formVisibilityNotifier;

  const InventarioActionButtons({
    required this.inventarioNotifier,
    required this.formVisibilityNotifier,
    super.key,
  });

  // --- Grupo 1: Botón circular de Agregar (Modo Vista) ---
  Widget _buildViewModeButtons(BuildContext context) {
    return FloatingActionButton(
      key: const ValueKey('viewMode'),
      // Color azul consistente con tu AppBar
      backgroundColor: const Color.fromARGB(255, 45, 85, 216),
      onPressed: () {
        inventarioNotifier.clearForm(); // Asegura que el formulario esté limpio
        formVisibilityNotifier.showForm();
      },
      child: const Icon(Icons.add_rounded, size: 35, color: Colors.white),
    );
  }

  // --- Grupo 2: Botones de Guardar y Cancelar (Modo Edición) ---
  Widget _buildEditModeButtons(BuildContext context) {
    return Row(
      key: const ValueKey('editMode'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Botón Cancelar (Circular pequeño)
        FloatingActionButton.small(
          heroTag: 'cancelBtn',
          backgroundColor: Colors.redAccent,
          onPressed: () {
            inventarioNotifier.clearForm();
            formVisibilityNotifier.hideForm();
          },
          child: const Icon(Icons.close_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        // Botón Guardar (Extendec con texto e icono)
        FloatingActionButton.extended(
          heroTag: 'saveBtn',
          backgroundColor: Colors.green,
          icon: const Icon(Icons.save_rounded, color: Colors.white),
          label: const Text(
            'Guardar', 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          ),
          onPressed: () async {
            final isEditing = inventarioNotifier.editingIngredienteId != null;

            // Esperar resultado del guardado
            final exito = await inventarioNotifier.guardarDatos();

            if (!context.mounted) return;

            if (exito) {
              formVisibilityNotifier.hideForm();
              NotificacionSnackBar.mostrarSnackBar(
                context,
                isEditing
                    ? '¡Ingrediente actualizado con éxito!'
                    : '¡Ingrediente guardado con éxito!',
              );
            } else {
              NotificacionSnackBar.mostrarSnackBar(
                context,
                'Error: no se pudo guardar el ingrediente',
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos ListenableBuilder para reaccionar a la visibilidad del formulario
    return ListenableBuilder(
      listenable: formVisibilityNotifier,
      builder: (context, child) {
        final isFormVisible = formVisibilityNotifier.isVisible;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          // Animación de escala para que los botones aparezcan/desaparezcan con estilo
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: isFormVisible
              ? _buildEditModeButtons(context) // Guardar y Cancelar
              : _buildViewModeButtons(context), // Solo Agregar
        );
      },
    );
  }
}