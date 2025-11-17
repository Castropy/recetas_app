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
    // Botón Cancelar: Llama a clearForm() y oculta el formulario
     FloatingActionButtonCancelar(
          onPressed: () {
            inventarioNotifier.clearForm(); 
            formVisibilityNotifier.hideForm(); 
          },
        ), 
     const SizedBox(width: 6),
     // Botón Guardar
     FloatingActionButtonGuardar(
      onPressed: () {
            // Determinar si estamos editando ANTES de llamar a guardarDatos (que limpia el ID)
            final isEditing = inventarioNotifier.editingIngredienteId != null;
            
      // Lógica de guardado centralizada (llama al Notifier del Paso 2)
      inventarioNotifier.guardarDatos(); 
      
      // Ocultar el formulario
       formVisibilityNotifier.hideForm();
  
      // Mostrar notificación basada en el estado de edición
       NotificacionSnackBar.mostrarSnackBar(
        context, 
        isEditing 
                  ? '¡Ingrediente actualizado con éxito!'
                  : '¡Ingrediente guardado con éxito!',
       );
     },
),
],
 );
}

  @override
  Widget build(BuildContext context) {
 // Usamos ListenableBuilder para escuchar el Notifier y redibujar.
  return ListenableBuilder(
   listenable: formVisibilityNotifier,
   builder: (context, child) {
    final isFormVisible = formVisibilityNotifier.isVisible;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
     // Renderizado Condicional
     child: isFormVisible
 // Si el formulario es visible (Guardar y Cancelar)
       ? _buildEditModeButtons(context)
 // Si el formulario NO es visible (Solo Agregar)
       : _buildViewModeButtons(context),
   );
},
 );
 }
}