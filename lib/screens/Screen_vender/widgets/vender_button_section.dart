import 'package:flutter/material.dart';
import 'package:recetas_app/providers/vender_notifier.dart';


class VenderButtonSection extends StatelessWidget {
  final VenderNotifier venderNotifier;
  const VenderButtonSection({super.key, required this.venderNotifier});

  @override
  Widget build(BuildContext context) {
  // El botón solo se habilita si hay recetas seleccionadas
   final isEnabled = venderNotifier.recetasSeleccionadas.isNotEmpty;
    final totalSeleccionadas = venderNotifier.recetasSeleccionadas.length;

   return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ElevatedButton.icon(
  // Llama a la lógica de venta del Notifier (Punto 2 y 3)
     onPressed: isEnabled ? () => venderNotifier.venderRecetas(context) : null,
      icon: const Icon(Icons.point_of_sale),
      label: Text(
            'Vender ($totalSeleccionadas receta${totalSeleccionadas != 1 ? 's' : ''})', 
            style: const TextStyle(fontSize: 18)
        ),
     style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: const Size(double.infinity, 50),
      elevation: 5,
  ),
  ),
  );
  }
}