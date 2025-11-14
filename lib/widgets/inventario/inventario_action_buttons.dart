import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButtonAgregar(),
        const SizedBox(height: 10),
        FloatingActionButtonEditar(),
        const SizedBox(height: 10),
        FloatingActionButtonCancelar(), 
        const SizedBox(height: 10),
        FloatingActionButtonGuardar(
          onPressed: () {
            // Lógica de guardado centralizada
            inventarioNotifier.guardarDatos(); 
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
} 