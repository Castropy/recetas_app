import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/models/recipe_ingredient_model.dart';
import 'package:recetas_app/providers/receta_form_notifier.dart';

/// Widget que permite buscar y seleccionar ingredientes del inventario.
/// 
/// Incluye la lógica para mostrar el diálogo de cantidad y gestionar
/// la adición de nuevos ingredientes a la receta.
class IngredienteSelector extends StatelessWidget {
  final RecetaFormNotifier notifier;

  const IngredienteSelector({
    super.key, 
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Ingrediente>>(
      stream: notifier.watchInventarioIngredientes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No hay ingredientes en el inventario.', 
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final ingredientes = snapshot.data!;

        return DropdownButtonFormField<Ingrediente>(
          menuMaxHeight: 350, 
          decoration: const InputDecoration(
            labelText: 'Seleccionar Ingrediente',
            prefixIcon: Icon(Icons.add_shopping_cart),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          hint: const Text('Elige un ingrediente...'),
          isExpanded: true,
          items: ingredientes.map((ingrediente) {
            return DropdownMenuItem<Ingrediente>(
              value: ingrediente,
              child: Text(
                '${ingrediente.nombre} (${ingrediente.unidadMedida})',
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (ingrediente) {
            if (ingrediente != null) {
              mostrarDialogoCantidad(context, notifier, ingrediente);
            }
          },
        );
      },
    );
  }

  /// Método estático para abrir el diálogo de cantidad desde cualquier lugar.
  /// 
  /// Se utiliza tanto al seleccionar un nuevo ingrediente como al
  /// editar uno ya existente en la lista.
  static void mostrarDialogoCantidad(
    BuildContext context, 
    RecetaFormNotifier notifier, 
    Ingrediente ingrediente,
  ) {
    final TextEditingController controller = TextEditingController();
    
    // Buscamos si el ingrediente ya está en la receta para pre-cargar la cantidad
    final existingItem = notifier.ingredientesSeleccionados.firstWhere(
      (i) => i.ingredienteId == ingrediente.id, 
      orElse: () => RecipeIngredientModel(
        ingredienteId: ingrediente.id,
        nombre: ingrediente.nombre,
        precioUnitario: ingrediente.costoUnitario, 
        cantidadNecesaria: 0,
        stockInventario: ingrediente.cantidad,
        unidadMedida: ingrediente.unidadMedida,
      )
    );
    
    controller.text = existingItem.cantidadNecesaria > 0 
        ? existingItem.cantidadNecesaria.toString() 
        : '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Cantidad: ${ingrediente.nombre}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Unidad: ${ingrediente.unidadMedida}', 
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Cantidad Necesaria',
                  suffixText: ingrediente.unidadMedida,
                  border: const OutlineInputBorder(),
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                notifier.removeIngredient(ingrediente.id);
                Navigator.of(context).pop();
              }, 
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                final double? cantidad = double.tryParse(controller.text);
                if (cantidad != null && cantidad >= 0) {
                  final newItem = RecipeIngredientModel(
                    ingredienteId: ingrediente.id,
                    nombre: ingrediente.nombre,
                    precioUnitario: ingrediente.costoUnitario,
                    cantidadNecesaria: cantidad,
                    stockInventario: ingrediente.cantidad,
                    unidadMedida: ingrediente.unidadMedida,
                  );
                  notifier.addIngredient(newItem);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      }
    );
  }
}