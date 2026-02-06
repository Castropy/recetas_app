import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart'; 
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/icon_button_custom.dart'; // Asumo que aquí está el DeleteButton
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
      NotificacionSnackBar.mostrarSnackBar(context, 'Ingrediente eliminado exitosamente');
    } catch (e) {
      if (!context.mounted) return;
      NotificacionSnackBar.mostrarSnackBar(context, 'Error al eliminar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ingredientes.isEmpty) {
        return const Center(child: Text('No se encontraron ingredientes.'));
    }

    return ListView.builder(
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: ingredientes.length,
      itemBuilder: (context, index) {
        final ing = ingredientes[index];
        
        return Card(
          color: const Color.fromARGB(255, 246, 248, 252),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ), 
          child: ListTile(
            // 🟢 ELIMINAMOS onTap para evitar ediciones accidentales
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: const Color.fromARGB(58, 176, 238, 230),
              child: Text(
                '${ing.id}',
                style: const TextStyle(color: Color.fromARGB(255, 7, 7, 7), fontSize: 12),
              ),
            ),
            title: Text(
              ing.nombre, 
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 10, 10, 10),
              ),
            ),
            subtitle: Text(
              'Stock: ${ing.cantidad} | Precio: \$${ing.costoUnitario.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color.fromARGB(179, 7, 7, 7),
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            ),
            // 🟢 NUEVO: Trailing con fila de botones (Edición + Eliminación)
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botón de Editar (Igual que en Recetas)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    notifier.loadIngredienteForEditing(ing);
                    visibilityNotifier.showForm();
                    // Opcional: Hacer scroll al inicio para ver el formulario
                  },
                ),
                // Botón de Eliminar existente
                DeleteButton(
                  ingredienteId: ing.id,
                  onDelete: deleteIngrediente,
                ),
              ],
            ),
          ),
        ); 
      },
    );
  }
}