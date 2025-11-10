import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'package:recetas_app/widgets/inventario/ingrediente_list_view.dart';
import 'package:recetas_app/widgets/shared/floating_action_buttons.dart';
import 'package:recetas_app/widgets/shared/inventario_form_fields.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';


class ScreenInventario extends StatelessWidget {
  const ScreenInventario({super.key});

  @override
  Widget build(BuildContext context) {
    // Acceder a los notifiers necesarios
    final inventarioNotifier = Provider.of<InventarioFormNotifier>(context, listen: false);
    // Acceder al notifier de visibilidad del formulario
    final formVisibilityNotifier = Provider.of<FormVisibilityNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title:  const Text(
            'Inventario',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30,
              color:  Color.fromARGB(255, 45, 85, 216),
              ),
            ),
        centerTitle: true,
        
      ), 
      //  Consumidor para reconstruir cuando cambie la visibilidad del formulario
      body: Consumer<FormVisibilityNotifier>(
        builder: (context, notifier, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Mostrar/Ocultar los campos condicionalmente
                if (notifier.isVisible) 
                // Formulario de Inventario (campos de texto)
                InventarioFormFields(inventarioNotifier: inventarioNotifier),
                
                // Lista de ingredientes con StreamBuilder
                const IngredienteListView(),
                // El resto del contenido de la pantalla iría aquí
                // ... otros widgets ...
              ],
              
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButtonAgregar(),
          const SizedBox(height: 10),
          FloatingActionButtonEditar(),
          const SizedBox(height: 10),
          FloatingActionButtonCancelar(),                  
          const SizedBox(height: 10),
          FloatingActionButtonGuardar(
            onPressed: () {
               inventarioNotifier.guardarDatos();              
              formVisibilityNotifier.hideForm();
              NotificacionSnackBar.mostrarSnackBar(
               context, 
                '¡Ingrediente guardado con éxito!',
                           );
                          },
                        ),
               
        ],
      ),
      
    );
  }
}