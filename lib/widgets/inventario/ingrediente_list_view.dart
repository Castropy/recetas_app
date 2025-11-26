import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart'; 
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/icon_button_custom.dart'; // Asumiendo que DeleteButton está aquí
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart'; 

class IngredienteListView extends StatelessWidget {
  const IngredienteListView({super.key});

// Función de eliminación
  void deleteIngrediente(BuildContext context, int id) async {
   final database = Provider.of<AppDatabase>(context, listen: false);
 
   try {
    await database.deleteIngrediente(id);
    if (!context.mounted) return;

    NotificacionSnackBar.mostrarSnackBar(context, 'Ingrediente eliminado exitosamente (ID: $id)');
   } catch (e) {
    if (!context.mounted) return;
    NotificacionSnackBar.mostrarSnackBar(context, 'Error al eliminar ingrediente: $e',);
    debugPrint('Error al eliminar ingrediente: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    // Obtenemos los notifiers para usarlos en el onTap
    final inventarioNotifier = Provider.of<InventarioFormNotifier>(context, listen: false);
    final formVisibilityNotifier = Provider.of<FormVisibilityNotifier>(context, listen: false);

   return Expanded(
    child: StreamBuilder<List<Ingrediente>>(
 // Se usa el stream de la base de datos
     stream: Provider.of<AppDatabase>(context).select(
      Provider.of<AppDatabase>(context).ingredientes).watch(), 
 
     builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
       return const Center(child: CircularProgressIndicator());
 }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
       return const Center(child: Text('No hay ingredientes guardados.'));
  }

      final ingredientes = snapshot.data!;
     return ListView.builder(
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
                  // 💡 ACCIÓN DE EDICIÓN: Tocar el elemento carga los datos
                  onTap: () {
                    // 1. Cargar los datos del ingrediente en el formulario
                    inventarioNotifier.loadIngredienteForEditing(ing);
                    // 2. Mostrar el formulario de edición (Guardar/Cancelar)
                    formVisibilityNotifier.showForm();
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
 )); 
 },
  );
 },
 ),
  );
 }
}