import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'package:recetas_app/widgets/shared/floating_action_buttons.dart';
import 'package:recetas_app/widgets/shared/inventario_form_fields.dart';


class ScreenInventario extends StatelessWidget {
  const ScreenInventario({super.key});

  @override
  Widget build(BuildContext context) {
    final inventarioNotifier = Provider.of<InventarioFormNotifier>(context, listen: false);
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
                InventarioFormFields(inventarioNotifier: inventarioNotifier),
                Expanded(
  child: StreamBuilder<List<Ingrediente>>(
    // Accede a la instancia de la DB a través del Provider
    stream: Provider.of<AppDatabase>(context).select(
      Provider.of<AppDatabase>(context).ingredientes
    ).watch(), 
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
          return ListTile(
            title: Text(ing.nombre, 
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
            subtitle: Text(
              'Id: ${ing.id} | Cant: ${ing.cantidad} | Precio: \$${ing.precio.toStringAsFixed(2)}',
              style: TextStyle(
                color: const Color.fromARGB(255, 2, 2, 2),
                fontSize: 16,
                
              ),
              ),
          );
        },
      );
    },
  ),
),
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
                          },
                        ),
               
        ],
      ),
      
    );
  }
}