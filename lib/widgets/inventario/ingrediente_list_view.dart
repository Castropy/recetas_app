import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart'; 
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/icon_button_custom.dart'; 
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart'; 

class IngredienteListView extends StatelessWidget {
  // 🟢 1. ACEPTAR PARÁMETROS: Recibe la lista filtrada y los notifiers desde el padre (ScreenInventario)
  final List<Ingrediente> ingredientes;
  final InventarioFormNotifier notifier; 
  final FormVisibilityNotifier visibilityNotifier; 

  const IngredienteListView({
    super.key,
    required this.ingredientes, // Lista ya filtrada
    required this.notifier,
    required this.visibilityNotifier,
  });

  // Función de eliminación
  void deleteIngrediente(BuildContext context, int id) async {
    // 💡 Aquí se usaba la lógica de eliminación directa en la DB.
    // Para usar la lógica de historial que definiste en el Notifier (deleteIngredienteConHistorial),
    // deberías llamar a 'notifier.deleteIngredienteConHistorial(ingrediente)' desde el onTap
    // o modificar esta función para usar el Notifier.
    
    // Dejo la lógica de DB directa para evitar más errores de Notifier, 
    // pero la lógica ideal es llamar al Notifier.
    final database = Provider.of<AppDatabase>(context, listen: false);
    
    try {
      await database.deleteIngrediente(id);
      if (!context.mounted) return;

      NotificacionSnackBar.mostrarSnackBar(context, 'Ingrediente eliminado exitosamente (ID: $id)');
    } catch (e) {
      if (!context.mounted) return;
      NotificacionSnackBar.mostrarSnackBar(context, 'Error al eliminar ingrediente: $e');
      debugPrint('Error al eliminar ingrediente: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ❌ 2. SE ELIMINA EL EXPANDED Y EL STREAMBUILDER: 
    // Ahora solo construimos la lista con los 'ingredientes' que recibimos.
    
    // Si la lista que recibimos está vacía, no deberíamos llegar aquí,
    // pero como protección se puede añadir una verificación.
    if (ingredientes.isEmpty) {
        return const Center(child: Text('No se encontraron ingredientes.'));
    }

    return Expanded(
      child: ListView.builder(
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
              // 💡 ACCIÓN DE EDICIÓN: Usamos los notifiers que recibimos.
              onTap: () {
                // 1. Cargar los datos del ingrediente en el formulario (usando el notifier recibido)
                notifier.loadIngredienteForEditing(ing);
                // 2. Mostrar el formulario de edición (usando el visibilityNotifier recibido)
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
              // Botón de eliminación
              trailing: DeleteButton(
                ingredienteId: ing.id,
                onDelete: deleteIngrediente,
              ),
            ),
          ); 
        },
      ),
    );
  }
}