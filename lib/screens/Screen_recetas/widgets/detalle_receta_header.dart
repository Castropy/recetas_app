import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';

/// Encabezado de la pantalla de detalle.
/// 
/// Muestra el nombre de la receta con énfasis visual y el costo 
/// total de producción resaltado con el color primario del tema.
class DetalleRecetaHeader extends StatelessWidget {
  final Receta receta;

  const DetalleRecetaHeader({
    super.key, 
    required this.receta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre de la receta en grande y negrita
        Text(
          receta.nombre,
          style: theme.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Fila de costo de producción
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Costo de Producción:', 
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '\$${receta.costoTotal.toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}