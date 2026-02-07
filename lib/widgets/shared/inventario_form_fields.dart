import 'package:flutter/material.dart';
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
    final String unidadActual = inventarioNotifier.unidadMedida;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Campo Nombre
        CustomTextFormField(
          controller: inventarioNotifier.nombreController,
          onChanged: inventarioNotifier.updateNombre,
          hintText: 'Nombre del ingrediente',
          prefixIcon: Icons.dinner_dining,
        ),
        const SizedBox(height: 15),

        // 🟢 2. Selector de Unidad de Medida (Mejorado visualmente)
        const Text(
          "Unidad de medida:",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity, // Forzamos a que use todo el ancho disponible
          child: SegmentedButton<String>(
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.black26, // Fondo un poco más oscuro para contraste
              selectedBackgroundColor: const Color.fromARGB(255, 45, 85, 216),
              selectedForegroundColor: Colors.white,
              foregroundColor: Colors.white, // 🟢 Texto blanco sólido para los no seleccionados
              side: const BorderSide(color: Colors.white24),
              // 🟢 Esto hace que los botones sean más compactos y quepan en la pantalla
              visualDensity: VisualDensity.compact, 
              padding: const EdgeInsets.symmetric(horizontal: 5), 
              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            segments: const [
              ButtonSegment(value: 'g', label: Text('Gramos'), icon: Icon(Icons.scale, size: 18)),
              ButtonSegment(value: 'ml', label: Text('Milis'), icon: Icon(Icons.water_drop, size: 18)),
              ButtonSegment(value: 'und', label: Text('Unid.'), icon: Icon(Icons.numbers, size: 18)),
            ],
            selected: {unidadActual},
            onSelectionChanged: (Set<String> newSelection) {
              inventarioNotifier.updateUnidad(newSelection.first);
            },
          ),
        ),
        const SizedBox(height: 15),

        // 3. Campo Cantidad
        CustomTextFormField(
          controller: inventarioNotifier.cantidadController,
          onChanged: inventarioNotifier.updateCantidad,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: unidadActual == 'und' 
              ? '¿Cuántas unidades vienen?' 
              : 'Cantidad total (GR o ML)',
          prefixIcon: Icons.confirmation_number_rounded,
        ),
        const SizedBox(height: 15),
        
        // 4. Campo Precio
        CustomTextFormField(
          controller: inventarioNotifier.precioController,
          onChanged: inventarioNotifier.updatePrecio,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: unidadActual == 'und' 
              ? 'Precio total por todas las unidades' 
              : 'Precio por KG o LT', 
          prefixIcon: Icons.price_change_sharp,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}