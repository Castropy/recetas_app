// lib/widgets/recipe_card_widget.dart

import 'package:flutter/material.dart';
import 'package:recetas_app/models/receta.dart';

class RecipeCardWidget extends StatelessWidget {
  final Receta receta;

  const RecipeCardWidget({
    super.key,
    required this.receta,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3, // Sombra suave
      child: ListTile(
        leading: const Icon(Icons.restaurant_menu, color: Colors.blue), // Icono a la izquierda
        title: Text(
          receta.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            'Ingredientes: ${receta.ingredientes.join(', ')}\n${receta.descripcion}'),
        trailing: Text(
          '\$${receta.costoTotal.toStringAsFixed(2)}', // Mostrar costo con 2 decimales
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 16,
          ),
        ),
        isThreeLine: true, // Permite que el subtítulo use más de dos líneas
        onTap: () {
          
          // Lógica para navegar a la vista de detalle de la receta
        },
      ),
    );
  }
}