import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'package:recetas_app/widgets/shared/floating_action_buttons.dart';
import 'package:recetas_app/widgets/shared/text_form_fields.dart';

class ScreenInventario extends StatelessWidget {
  const ScreenInventario({super.key});

  @override
  Widget build(BuildContext context) {
    final inventarioNotifier = Provider.of<InventarioFormNotifier>(context, listen: false);
    return Scaffold(
      body: Consumer<FormVisibilityNotifier>(
        builder: (context, notifier, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Mostrar/Ocultar los campos condicionalmente
                if (notifier.isVisible) ...[
                  // --- Campos de Formulario ---
                   CustomTextFormField(
                    onChanged: inventarioNotifier.updateNombre,
                    hintText: 'Nombre',
                    prefixIcon: Icons.dinner_dining,),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    onChanged: inventarioNotifier.updateCantidad,
                    keyboardType: TextInputType.number,
                    hintText: 'Cantidad',
                    prefixIcon: Icons.confirmation_number_rounded,),
                 const SizedBox(height: 10),
                 CustomTextFormField(
                    onChanged: inventarioNotifier.updatePrecio,
                    keyboardType: TextInputType.number,
                    hintText: 'precio',
                    prefixIcon: Icons.price_change_sharp,),
                    const SizedBox(height: 10),

                  // --- Botón de Cancelar ---
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButtonCancelar(),                  
                        const SizedBox(width: 10),
                        FloatingActionButtonGuardar(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                
                ],
                // El resto del contenido de la pantalla iría aquí
                // ... otros widgets ...
              ],
              
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButtonAgregar(),
          const SizedBox(height: 10),
          FloatingActionButtonEditar()
        ],
      ),
      
    );
  }
}