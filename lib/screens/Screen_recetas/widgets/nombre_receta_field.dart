import 'package:flutter/material.dart';
import 'package:recetas_app/providers/receta_form_notifier.dart';

/// Widget que gestiona la entrada de texto para el nombre de la receta.
/// 
/// Encapsula la lógica de actualización del [RecetaFormNotifier] y 
/// el manejo del foco del teclado.
class NombreRecetaField extends StatelessWidget {
  final RecetaFormNotifier notifier;

  const NombreRecetaField({
    super.key, 
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Mantiene el valor actual del notifier (útil en ediciones)
      initialValue: notifier.nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Nombre de la Receta',
        hintText: 'Ej. Galletas de Chispas de Chocolate',
        prefixIcon: Icon(Icons.restaurant_menu),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
      // Actualiza el estado global en cada cambio
      onChanged: notifier.updateNombre,
      // Mejora de UX: cierra el teclado al tocar cualquier área fuera del input
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      // Validación básica opcional
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa un nombre';
        }
        return null;
      },
    );
  }
}