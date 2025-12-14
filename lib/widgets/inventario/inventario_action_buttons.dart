import 'package:flutter/material.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart'; 
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/floating_action_buttons.dart'; 
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart'; 

class InventarioActionButtons extends StatelessWidget {
  final InventarioFormNotifier inventarioNotifier;
  final FormVisibilityNotifier formVisibilityNotifier;

  const InventarioActionButtons({
    required this.inventarioNotifier,
    required this.formVisibilityNotifier,
    super.key,
  });

  // --- Grupo 1: Agregar (Modo Vista) ---
  Widget _buildViewModeButtons(BuildContext context) {
    return const Row(
      key: ValueKey('viewMode'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButtonAgregar(),
      ],
    );
  }

  // --- Grupo 2: Guardar y Cancelar (Modo Edición) ---
  Widget _buildEditModeButtons(BuildContext context) {
    return Row(
      key: const ValueKey('editMode'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Botón Cancelar
        FloatingActionButtonCancelar(
          onPressed: () {
            inventarioNotifier.clearForm();
            formVisibilityNotifier.hideForm();
          },
        ),
        const SizedBox(width: 6),
        // Botón Guardar
        FloatingActionButtonGuardar(
          onPressed: () async {
            final isEditing = inventarioNotifier.editingIngredienteId != null;

            // Esperar resultado del guardado
            final exito = await inventarioNotifier.guardarDatos();

            // ✅ Verificar que el widget sigue montado antes de usar context
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
    return ListenableBuilder(
      listenable: formVisibilityNotifier,
      builder: (context, child) {
        final isFormVisible = formVisibilityNotifier.isVisible;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isFormVisible
              ? _buildEditModeButtons(context) // Guardar y Cancelar
              : _buildViewModeButtons(context), // Solo Agregar
        );
      },
    );
  }
}
