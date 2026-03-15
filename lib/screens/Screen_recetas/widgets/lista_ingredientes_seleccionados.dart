import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/receta_form_notifier.dart';
import 'ingrediente_selector.dart'; // Necesario para re-usar el diálogo de cantidad

/// Lista vertical que muestra los ingredientes agregados a la receta actual.
/// 
/// Permite al usuario visualizar subtotales y re-editar cantidades
/// al hacer clic en cada elemento.
class ListaIngredientesSeleccionados extends StatelessWidget {
  final RecetaFormNotifier notifier;

  const ListaIngredientesSeleccionados({
    super.key, 
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay ingredientes, mostramos un mensaje informativo amigable
    if (notifier.ingredientesSeleccionados.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            'Agregue ingredientes a la receta.', 
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifier.ingredientesSeleccionados.length,
      itemBuilder: (context, index) {
        final item = notifier.ingredientesSeleccionados[index];
        
        return Card( 
          color: Colors.blue[50], 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.check_box_outlined, color: Colors.blue),
            title: Text(
              item.nombre, 
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${item.cantidadNecesaria} ${item.unidadMedida}'),
            trailing: Text(
              '\$${item.costoSubtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              // Convertimos el modelo a objeto de DB para re-usar el diálogo de edición
              final ingredienteDB = Ingrediente(
                id: item.ingredienteId, 
                nombre: item.nombre, 
                cantidad: item.stockInventario, 
                costoUnitario: item.precioUnitario,
                unidadMedida: item.unidadMedida, 
                fechaCreacion: DateTime.now(),
              );
              
              // Re-utilizamos la lógica del selector para editar la cantidad
              IngredienteSelector.mostrarDialogoCantidad(
                context, 
                notifier, 
                ingredienteDB,
              );
            },
          ),
        );
      },
    );
  }
}