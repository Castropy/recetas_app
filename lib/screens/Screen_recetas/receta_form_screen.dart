// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/models/recipe_ingredient_model.dart';
import 'package:recetas_app/providers/receta_form_notifier.dart';
//import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';

class RecetaFormScreen extends StatelessWidget {
  static const String routeName = 'receta_form';
  
  const RecetaFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int? recetaId = ModalRoute.of(context)?.settings.arguments as int?;
    final notifier = Provider.of<RecetaFormNotifier>(context);
    final theme = Theme.of(context);

    if (recetaId != null) {
      Future.microtask(() => notifier.loadRecetaToEdit(recetaId));
    } else {
      if (notifier.idReceta != null) {
        Future.microtask(() => notifier.clearForm());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recetaId == null ? 'Crear Receta' : 'Editar Receta', 
          style: const TextStyle(
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
            _NombreRecetaField(notifier: notifier),
            const SizedBox(height: 20),
            Text('Ingredientes Necesarios', style: theme.textTheme.titleMedium),
            const Divider(),
            _IngredienteSelector(notifier: notifier),
            const SizedBox(height: 10),
            _ListaIngredientesSeleccionados(notifier: notifier),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16.0, 
          right: 16.0, 
          bottom: MediaQuery.of(context).padding.bottom + 10,
        ),
        child: _CostoTotalSection(notifier: notifier),
      ),
    );
  }
}

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
    return StreamBuilder<List<Ingrediente>>(
      stream: notifier.watchInventarioIngredientes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

  void _mostrarDialogoCantidad(BuildContext context, RecetaFormNotifier notifier, Ingrediente ingrediente) {
    final TextEditingController controller = TextEditingController();
    
    final existingItem = notifier.ingredientesSeleccionados.firstWhere(
      (i) => i.ingredienteId == ingrediente.id, 
      orElse: () => RecipeIngredientModel(
        ingredienteId: ingrediente.id,
        nombre: ingrediente.nombre,
        // 🟢 CORRECCIÓN: Quitamos el "/ 1000.0". 
        // El precio ya viene estandarizado desde la DB gracias al InventarioNotifier.
        precioUnitario: ingrediente.costoUnitario, 
        cantidadNecesaria: 0,
        stockInventario: ingrediente.cantidad,
        unidadMedida: ingrediente.unidadMedida,
      )
    );
    
    controller.text = existingItem.cantidadNecesaria > 0 ? existingItem.cantidadNecesaria.toString() : '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cantidad de ${ingrediente.nombre} (${ingrediente.unidadMedida})'),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Cantidad Necesaria',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                notifier.removeIngredient(ingrediente.id);
                Navigator.of(context).pop();
              }, 
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                final double? cantidad = double.tryParse(controller.text);
                if (cantidad != null && cantidad >= 0) {
                  final newItem = RecipeIngredientModel(
                    ingredienteId: ingrediente.id,
                    nombre: ingrediente.nombre,
                    // 🟢 CORRECCIÓN: Aquí también quitamos la división.
                    precioUnitario: ingrediente.costoUnitario,
                    cantidadNecesaria: cantidad,
                    stockInventario: ingrediente.cantidad,
                    unidadMedida: ingrediente.unidadMedida,
                  );
                  notifier.addIngredient(newItem);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
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
          child: Text('Agregue ingredientes a la receta.'),
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
          color: Colors.yellow[100], // Un poco más suave que el amarillo puro
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.shopping_basket_outlined, color: Colors.indigo),
            title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item.cantidadNecesaria} ${item.unidadMedida}'),
            trailing: Text(
              '\$${item.costoSubtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              // Re-creamos el objeto ingrediente para abrir el diálogo
              final ingredienteDB = Ingrediente(
                id: item.ingredienteId, 
                nombre: item.nombre, 
                cantidad: item.stockInventario, 
                costoUnitario: item.precioUnitario,
                unidadMedida: item.unidadMedida, 
                fechaCreacion: DateTime.now()
              );
              _IngredienteSelector(notifier: notifier)._mostrarDialogoCantidad(context, notifier, ingredienteDB);
            },
          ),
        );
      },
    );
  }
}

class _CostoTotalSection extends StatelessWidget {
  final RecetaFormNotifier notifier;
  const _CostoTotalSection({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Costo Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              '\$${notifier.costoTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold, 
                color: Theme.of(context).colorScheme.secondary
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: notifier.ingredientesSeleccionados.isEmpty 
              ? null 
              : () => notifier.guardarReceta(context),
          icon: const Icon(Icons.save),
          label: const Text('Guardar Receta'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}