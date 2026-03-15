import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart'; 
import 'package:recetas_app/widgets/shared/text_form_fields.dart'; 

class InventarioFormFields extends StatelessWidget {
  final InventarioFormNotifier inventarioNotifier;
  
  const InventarioFormFields({
    required this.inventarioNotifier, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Nombre (Fuera del Consumer para estabilidad total)
        CustomTextFormField(
          controller: inventarioNotifier.nombreController,
          hintText: 'Nombre del ingrediente',
          prefixIcon: Icons.dinner_dining,
        ),
        const SizedBox(height: 15),

        const Text(
          "Unidad de medida:",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 8),
        
        // 🟢 El Consumer se encarga del cambio entre gramos, litros o unidades
        Consumer<InventarioFormNotifier>(
          builder: (context, notifier, child) {
            final unidadActual = notifier.unidadMedida;
            
            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    style: SegmentedButton.styleFrom(
                      backgroundColor: Colors.black26,
                      selectedBackgroundColor: const Color.fromARGB(255, 45, 85, 216),
                      selectedForegroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact, 
                    ),
                    segments: const [
                      ButtonSegment(value: 'g', label: Text('Gramos'), icon: Icon(Icons.scale, size: 18)),
                      ButtonSegment(value: 'ml', label: Text('Milis'), icon: Icon(Icons.water_drop, size: 18)),
                      ButtonSegment(value: 'und', label: Text('Unid.'), icon: Icon(Icons.numbers, size: 18)),
                    ],
                    selected: {unidadActual},
                    onSelectionChanged: (Set<String> newSelection) {
                      notifier.updateUnidad(newSelection.first);
                    },
                  ),
                ),
                const SizedBox(height: 15),

                // 3. Cantidad (Reactivo al HintText)
                CustomTextFormField(
                  controller: notifier.cantidadController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  hintText: unidadActual == 'und' 
                      ? '¿Cuántas unidades vienen?' 
                      : 'Cantidad total (GR o ML)',
                  prefixIcon: Icons.confirmation_number_rounded,
                ),
                const SizedBox(height: 15),
                
                // 4. Precio (Reactivo al HintText)
                CustomTextFormField(
                  controller: notifier.precioController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  hintText: unidadActual == 'und' 
                      ? 'Precio total por todas las unidades' 
                      : 'Precio por KG o LT', 
                  prefixIcon: Icons.price_change_sharp,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}