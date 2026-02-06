import 'package:flutter/material.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/text_form_fields.dart'; 


class InventarioFormFields extends StatelessWidget {
  // Se requiere el Notifier para acceder a los controladores y actualizar el estado.
  final InventarioFormNotifier inventarioNotifier;
  
  const InventarioFormFields({
    required this.inventarioNotifier, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Campo Nombre
        CustomTextFormField(
          // 🟢 Vinculación con el controlador para carga automática
          controller: inventarioNotifier.nombreController,
          onChanged: inventarioNotifier.updateNombre,
          hintText: 'Nombre',
          prefixIcon: Icons.dinner_dining,
        ),
        const SizedBox(height: 10),

        // 2. Campo Cantidad
        CustomTextFormField(
          // 🟢 Vinculación con el controlador para carga automática
          controller: inventarioNotifier.cantidadController,
          onChanged: inventarioNotifier.updateCantidad,
          keyboardType: TextInputType.number,
          hintText: 'Ingresa la cantidad en GR o ML',
          prefixIcon: Icons.confirmation_number_rounded,
        ),
        const SizedBox(height: 10),
        
        // 3. Campo Precio
        CustomTextFormField(
          // 🟢 Vinculación con el controlador para carga automática
          controller: inventarioNotifier.precioController,
          onChanged: inventarioNotifier.updatePrecio,
          keyboardType: TextInputType.number,
          hintText: 'Precio por KG o LT', 
          prefixIcon: Icons.price_change_sharp,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}