import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'package:recetas_app/widgets/shared/text_form_fields.dart';
//import 'package:recetas_app/widgets/shared/floating_action_buttons.dart';
//import 'package:recetas_app/widgets/shared/text_form_fields.dart';

class ScreenRecetas extends StatelessWidget {
  const ScreenRecetas({super.key});
  @override
  Widget build(BuildContext context) {
    final formNotifier = Provider.of<FormVisibilityNotifier>(context, listen: false);
    return Scaffold( 
     // El cuerpo reacciona al estado del Provider
      body: Consumer<FormVisibilityNotifier>(
        builder: (context, notifier, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Mostrar/Ocultar los campos condicionalmente
                if (notifier.isVisible) ...[
                  // --- Campos de Formulario ---
                  const  MyTextFormFields(),
                  const SizedBox(height: 10),
                  const  MyTextFormFields2(),
                  const SizedBox(height: 20),

                  // --- Botón de Cancelar ---
                  ElevatedButton.icon(
                    onPressed: formNotifier.hideForm, // Oculta el formulario al presionar
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Color para destacar el cancelar
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
                // El resto del contenido de tu pantalla iría aquí
                // ... otros widgets ...
              ],
            ),
          );
        },
      ),

      // --- Floating Action Button (FAB) ---
      floatingActionButton: FloatingActionButton(
        onPressed: formNotifier.showForm, // Muestra el formulario al presionar
        child: const Icon(Icons.add),
      ),
    );
  }
}
   

 //body: Center(
     // child: Column(
        //children: [
        //  Padding(
          //  padding: const EdgeInsets.all(12.4),
           // child: MyTextFormFields(),
        //  ),
        //  SizedBox(height: 20),
        //  Padding(
           // padding: const EdgeInsets.all(12.0),
          //  child: FloatingActionButtonVender(),
        //  ),
      //  ],
    //  ),
   // )