import 'package:flutter/material.dart';
// Asegúrate de que estas importaciones sean correctas en el archivo donde lo pongas
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/text_form_fields.dart'; 


class InventarioFormFields extends StatelessWidget {
  // Se requiere el Notifier para que los campos puedan actualizar el estado del formulario.
  final InventarioFormNotifier inventarioNotifier;
  
  const InventarioFormFields({
    required this.inventarioNotifier, 
    super.key, // Añadir Key para una mejor práctica
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Campo Nombre
        CustomTextFormField(
          onChanged: inventarioNotifier.updateNombre,
          hintText: 'Nombre',
          prefixIcon: Icons.dinner_dining,
        ),
        const SizedBox(height: 10),

        // 2. Campo Cantidad
        CustomTextFormField(
          onChanged: inventarioNotifier.updateCantidad,
          keyboardType: TextInputType.number,
          hintText: 'Cantidad',
          prefixIcon: Icons.confirmation_number_rounded,
        ),
        const SizedBox(height: 10),
        
        // 3. Campo Precio
        CustomTextFormField(
          onChanged: inventarioNotifier.updatePrecio,
          keyboardType: TextInputType.number,
          hintText: 'Precio', // Corregido de 'precio' a 'Precio'
          prefixIcon: Icons.price_change_sharp,
        ),
        const SizedBox(height: 10),
        
        // Puedes agregar aquí un botón de Cancelar/Limpiar si solo aplica al formulario
      ],
    );
  }
}