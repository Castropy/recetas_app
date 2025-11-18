import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'package:recetas_app/widgets/shared/floating_action_buttons.dart';
import 'package:recetas_app/widgets/shared/text_form_fields.dart';


// Esta es la pantalla de recetas donde se mostraran las recetas y el formulario para crear nuevas recetas
class ScreenRecetas extends StatelessWidget {
  const ScreenRecetas({super.key});
  @override
  Widget build(BuildContext context) {
    //final recetasProvider = context.watch<RecetasProvider>();
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
                   const  CustomTextFormField(
                    hintText: 'Nombre',
                    prefixIcon: Icons.food_bank_rounded,),
                  const SizedBox(height: 10),
                  const  CustomTextFormField(
                    hintText: 'ejemplo',
                    prefixIcon: Icons.emoji_food_beverage,),
                 const SizedBox(height: 20),

                  // --- Botón de Cancelar ---
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButtonCancelar(
                          onPressed: () {
                            // Lógica para cancelar la creación de receta
                            notifier.hideForm();
                          },
                        ),                  
                        const SizedBox(width: 10),
                        FloatingActionButtonGuardar(
                          onPressed: () {
                            // Lógica para guardar receta
                            notifier.hideForm();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                
                ],
                // El resto del contenido de la pantalla iría aquí
                // ... otros widgets ...
              ],
              
            ),
          );
        },
      ),

      
       
      // --- Floating Action Button (FAB) ---
      floatingActionButton: FloatingActionButtonCrear(), 
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      
    );
  }
} 
    
  