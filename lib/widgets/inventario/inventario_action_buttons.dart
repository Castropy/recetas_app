import 'package:flutter/material.dart';
//import 'package:provider/provider.dart'; // Asumiendo que Provider se sigue usando para los FABs hijos
// Asegúrate de importar los proveedores y los widgets de los botones
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

  // --- Grupo 1: Agregar y Editar (Modo Vista) ---
  Widget _buildViewModeButtons(BuildContext context) {
    // Usamos una clave para que AnimatedSwitcher sepa que este es un hijo distinto.
    return Row(
      key: const ValueKey('viewMode'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // NOTA: FloatingActionButtonAgregar debe llamar internamente a formVisibilityNotifier.showForm()
        FloatingActionButtonAgregar(), 
        const SizedBox(width: 6),
        // NOTA: FloatingActionButtonEditar debe llamar internamente a formVisibilityNotifier.showForm()
        FloatingActionButtonEditar(),
      ],
    );
  }

  // --- Grupo 2: Guardar y Cancelar (Modo Edición) ---
  Widget _buildEditModeButtons(BuildContext context) {
    // Usamos una clave para que AnimatedSwitcher sepa que este es un hijo distinto.
    return Row(
      key: const ValueKey('editMode'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // El botón Cancelar debe llamar internamente a formVisibilityNotifier.hideForm()
        FloatingActionButtonCancelar(), 
        const SizedBox(width: 6),
        FloatingActionButtonGuardar(
          onPressed: () {
            // Lógica de guardado centralizada
            inventarioNotifier.guardarDatos(); 
            
            // 💡 OCULTAR: Regresa al modo de vista (asumiendo que Guardar no lo hace internamente)
            formVisibilityNotifier.hideForm();
            
            // Mostrar notificación
            NotificacionSnackBar.mostrarSnackBar(
              context, 
              '¡Ingrediente guardado con éxito!',
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 💡 Paso 1: Usamos ListenableBuilder para escuchar el Notifier y redibujar.
    return ListenableBuilder(
      listenable: formVisibilityNotifier,
      builder: (context, child) {
        final isFormVisible = formVisibilityNotifier.isVisible;
        
        // 💡 Paso 2: Usamos AnimatedSwitcher para hacer el cambio de forma animada.
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          // Puedes usar un transitionBuilder personalizado si lo deseas.
          // Aquí se usa el efecto por defecto (FadeTransition).
          
          // 💡 Paso 3: Renderizado Condicional
          child: isFormVisible
            // Si el formulario es visible (al presionar Agregar/Editar)
            ? _buildEditModeButtons(context)
            // Si el formulario NO es visible (al inicio o al presionar Guardar/Cancelar)
            : _buildViewModeButtons(context),
        );
      },
    );
  }
}

//Este es el conjunto de Botones 