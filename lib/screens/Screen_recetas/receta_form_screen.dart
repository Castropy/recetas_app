//import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/models/recipe_ingredient_model.dart';
import 'package:recetas_app/providers/receta_form_notifier.dart';

import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';

// Pantalla principal para crear o editar una receta
class RecetaFormScreen extends StatelessWidget {
  static const String routeName = 'receta_form';
  
  const RecetaFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
  // 🟢 1. Obtener el ID de la ruta (si existe, estamos en modo edición)
  final int? recetaId = ModalRoute.of(context)?.settings.arguments as int?;

  // Escucha el Notifier que maneja la lógica del formulario
  final notifier = Provider.of<RecetaFormNotifier>(context);
  final theme = Theme.of(context);

  // 🟢 2. Si hay un ID, cargar los datos
  if (recetaId != null) {
    // Usamos Future.microtask o un initState wrapper si fuera Statefull.
    // Para Stateless y evitar llamadas redundantes:
    Future.microtask(() => notifier.loadRecetaToEdit(recetaId));
  } else {
    // 🟢 3. Si no hay ID, asegurar que el formulario esté limpio para creación
    // Esto es vital si se navega de vuelta a "crear" sin reiniciar la app.
    if (notifier.idReceta != null) {
      Future.microtask(() => notifier.clearForm());
    }
  }

  return Scaffold(
    appBar: AppBar(
      // 🟢 4. Cambiar el título según el modo
      title: Text(recetaId == null ? 'Crear Receta' : 'Editar Receta'
        , style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 30,
          color: Color.fromARGB(255, 45, 85, 216),
        ),
      ),
    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Campo de Nombre de la Receta
            _NombreRecetaField(notifier: notifier),
            
            const SizedBox(height: 20),
            
            // 2. Título de Ingredientes
            Text('Ingredientes Necesarios', style: theme.textTheme.titleMedium),
            const Divider(),
            
            // 3. Selector de Ingredientes del Inventario
            _IngredienteSelector(notifier: notifier),
            
            const SizedBox(height: 10),
            
            // 4. Lista de Ingredientes Seleccionados
            _ListaIngredientesSeleccionados(notifier: notifier),

            const SizedBox(height: 100),

            
          ],
        ),
      ),
      bottomNavigationBar: Padding(
      padding: EdgeInsets.only(
        left: 16.0, 
        right: 16.0, 
        // 4. Importante para iOS y Android: padding para la zona segura (safe area)
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: _CostoTotalSection(notifier: notifier),
    ),
    );
  }
}

// ----------------------------------------------------
// WIDGETS DE LA PANTALLA
// ----------------------------------------------------

class _NombreRecetaField extends StatelessWidget {
  final RecetaFormNotifier notifier;
  
  const _NombreRecetaField({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: notifier.nombre,
      decoration: const InputDecoration(
        labelText: 'Nombre de la Receta',
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
      onChanged: notifier.updateNombre,
    );
  }
}

class _IngredienteSelector extends StatelessWidget {
  final RecetaFormNotifier notifier;
  
  const _IngredienteSelector({required this.notifier});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder para obtener la lista de ingredientes del inventario
    return StreamBuilder<List<Ingrediente>>(
      stream: notifier.watchInventarioIngredientes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Si no hay ingredientes, muestra un mensaje
          return const Center(child: Text('No hay ingredientes en el inventario.'));
        }
        
        final ingredientes = snapshot.data!;
        
        return DropdownButtonFormField<Ingrediente>(
          decoration: const InputDecoration(
            labelText: 'Seleccionar Ingrediente',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          hint: const Text('Elige un ingrediente...'),
          isExpanded: true,
          items: ingredientes.map((ingrediente) {
            return DropdownMenuItem<Ingrediente>(
              value: ingrediente,
              child: Text(ingrediente.nombre),
            );
          }).toList(),
          onChanged: (ingrediente) {
            if (ingrediente != null) {
              _mostrarDialogoCantidad(context, notifier, ingrediente);
            }
          },
        );
      },
    );
  }

  // Muestra un diálogo para pedir la cantidad necesaria de este ingrediente
  void _mostrarDialogoCantidad(BuildContext context, RecetaFormNotifier notifier, Ingrediente ingrediente) {
    final TextEditingController controller = TextEditingController();
    
    // Obtener la cantidad ya seleccionada si existe
    final existingItem = notifier.ingredientesSeleccionados.firstWhere(
      (i) => i.ingredienteId == ingrediente.id, 
      orElse: () => RecipeIngredientModel(
        ingredienteId: ingrediente.id,
        nombre: ingrediente.nombre,
        // Evitamos división por cero al calcular el precio unitario
        precioUnitario: ingrediente.cantidad > 0 ? (ingrediente.precio / ingrediente.cantidad) : 0.0,
        cantidadNecesaria: 0,
      )
    );
    
    controller.text = existingItem.cantidadNecesaria > 0 ? existingItem.cantidadNecesaria.toString() : '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cantidad de ${ingrediente.nombre}'),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cantidad Necesaria',
              hintText: 'Ej: 0.5, 2, 100',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Si el usuario cancela o quiere eliminar
                notifier.removeIngredient(ingrediente.id);
                Navigator.of(context).pop();
              }, 
              child: const Text('Eliminar/Cancelar', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                final double? cantidad = double.tryParse(controller.text);
                if (cantidad != null && cantidad >= 0) {
                  final newItem = RecipeIngredientModel(
                    ingredienteId: ingrediente.id,
                    nombre: ingrediente.nombre,
                    // Calculamos el costo unitario del inventario: Precio Total / Cantidad en stock
                    precioUnitario: ingrediente.cantidad > 0 ? (ingrediente.precio / ingrediente.cantidad) : 0.0,
                    cantidadNecesaria: cantidad,
                  );
                  notifier.addIngredient(newItem);
                  Navigator.of(context).pop();
                } else if (cantidad != null && cantidad < 0){
                   NotificacionSnackBar.mostrarSnackBar(context, 'La cantidad debe ser mayor o igual a cero.');
                }
              },
              child: const Text('Guardar', 
              style: TextStyle(fontWeight: FontWeight.bold,
              ),
              
              )
            ),
          ],
        );
      }
    );
  }
}

class _ListaIngredientesSeleccionados extends StatelessWidget {
  final RecetaFormNotifier notifier;
  
  const _ListaIngredientesSeleccionados({required this.notifier});

  @override
  Widget build(BuildContext context) {
    if (notifier.ingredientesSeleccionados.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text('Agregue ingredientes a la receta desde el selector.'),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifier.ingredientesSeleccionados.length,
      itemBuilder: (context, index) {
        final item = notifier.ingredientesSeleccionados[index];
        
        return Card( 
          color: Colors.yellow,  
          shape: StadiumBorder(),      
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.shopping_basket_outlined, color: Colors.indigo),
            title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Cantidad: ${item.cantidadNecesaria.toStringAsFixed(2)}',
             style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(
              'Costo: \$${item.costoSubtotal.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.black, 
              fontWeight: FontWeight.bold,
              fontSize: 16),
            ),
            onTap: () {
              // Permite editar la cantidad haciendo click en la lista
              final ingredienteDB = Ingrediente(
                id: item.ingredienteId, 
                nombre: item.nombre, 
                // Estos valores son simulados, solo se necesita el ID y nombre para el diálogo
                cantidad: 1, 
                precio: item.precioUnitario, 
                fechaCreacion: DateTime.now()
              );
              
              // Usamos el mismo método del selector para editar
              _IngredienteSelector(notifier: notifier)._mostrarDialogoCantidad(context, notifier, ingredienteDB);
            },
          ),
        );
      },
    );
  }
}

// receta_form_screen.dart - Clase _CostoTotalSection

class _CostoTotalSection extends StatelessWidget {
  final RecetaFormNotifier notifier;
  
  const _CostoTotalSection({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Esto es clave en un Column dentro de bottomNavigationBar
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Costo Total de la Receta:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              '\$${notifier.costoTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: Theme.of(context).colorScheme.secondary
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 10), // Reducimos el espacio a 10 (era 20)
        
        ElevatedButton.icon(
          onPressed: notifier.ingredientesSeleccionados.isEmpty 
              ? null // Deshabilitado si no hay ingredientes
              : () => notifier.guardarReceta(context),
          icon: const Icon(Icons.save),
          label: const Text('Guardar Receta', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
          ),
        ),
        // ⚠️ Eliminamos el SizedBox(height: 40) que estaba aquí
      ],
    );
  }
}