import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart'; 
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/icon_button_custom.dart'; // Contiene DeleteButton
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
      NotificacionSnackBar.mostrarSnackBar(context, 'Error al eliminar ingrediente: $e');
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
          color: const Color.fromARGB(255, 201, 209, 218), // Gris claro del estilo solicitado
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ), 
          child: ListTile(
            onTap: null, 
            // 🟢 NUEVO: CircleAvatar con el ID del ingrediente
            leading: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 45, 85, 216), // Azul primario para resaltar el ID
              child: Text(
                '${ing.id}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(
              ing.nombre, 
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 5, 5),
              ),
            ),
            subtitle: Text(
              'Stock: ${ing.cantidad} | Precio: \$${ing.costoUnitario.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color.fromARGB(179, 24, 23, 23),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botón Editar con scroll automático
                IconButton(
                  icon: const Icon(Icons.edit, color: Color.fromARGB(255, 7, 7, 7), size: 20),
                  onPressed: () {
                    notifier.loadIngredienteForEditing(ing);
                    visibilityNotifier.showForm();

                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (context.mounted) {
                        Scrollable.ensureVisible(
                          context,
                          alignment: 0.0, 
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    });
                  },
                ),
                // Botón Borrar (Custom)
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