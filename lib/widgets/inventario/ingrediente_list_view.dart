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
          color: const Color.fromARGB(255, 23, 69, 150),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ), 
          child: ListTile(
            // 🟢 Quitamos onTap para que solo se edite con el botón de lápiz
            onTap: null, 
            title: Text(
              ing.nombre, 
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Stock: ${ing.cantidad} | Precio: \$${ing.costoUnitario.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            // 🟢 Trailing con Editar y Eliminar (Consistencia con Recetas)
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                  onPressed: () {
                    // 1. Cargar datos en los controladores
                    notifier.loadIngredienteForEditing(ing);
                    
                    // 2. Hacer visible el formulario
                    visibilityNotifier.showForm();

                    // 3. Scroll automático hacia el formulario
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (context.mounted) {
                        Scrollable.ensureVisible(
                          context,
                          alignment: 0.0, // Desplaza hasta que el item actual esté arriba
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    });
                  },
                ),
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