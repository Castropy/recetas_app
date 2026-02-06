import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart'; 
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/icon_button_custom.dart'; 
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart'; 

class IngredienteListView extends StatelessWidget {
  final List<Ingrediente> ingredientes;
  final InventarioFormNotifier notifier; 
  final FormVisibilityNotifier visibilityNotifier; 

  const IngredienteListView({
    super.key,
    required this.ingredientes,
    required this.notifier,
    required this.visibilityNotifier,
  });

  void deleteIngrediente(BuildContext context, int id) async {
    final database = Provider.of<AppDatabase>(context, listen: false);
    try {
      await database.deleteIngrediente(id);
      if (!context.mounted) return;
      NotificacionSnackBar.mostrarSnackBar(context, 'Ingrediente eliminado exitosamente (ID: $id)');
    } catch (e) {
      if (!context.mounted) return;
      NotificacionSnackBar.mostrarSnackBar(context, 'Error al eliminar ingrediente: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ingredientes.isEmpty) {
        return const Center(child: Text('No se encontraron ingredientes.'));
    }

    // 🔴 QUITAMOS EL EXPANDED: Ya no es necesario porque el padre tiene scroll.
    return ListView.builder(
      // 🟢 IMPORTANTE: Estas dos líneas permiten que la lista viva dentro de otro scroll
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: ingredientes.length,
      itemBuilder: (context, index) {
        final ing = ingredientes[index];
        return Card(
          color: const Color.fromARGB(255, 23, 69, 150),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ), 
          child: ListTile(
            onTap: () {
              notifier.loadIngredienteForEditing(ing);
              visibilityNotifier.showForm();
            },
            title: Text(
              ing.nombre, 
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 248, 246, 246),
              ),
            ),
            subtitle: Text(
              'Id: ${ing.id} | Stock: ${ing.cantidad} | Precio: \$${ing.costoUnitario.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color.fromARGB(255, 248, 246, 246),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: DeleteButton(
              ingredienteId: ing.id,
              onDelete: deleteIngrediente,
            ),
          ),
        ); 
      },
    );
  }
}