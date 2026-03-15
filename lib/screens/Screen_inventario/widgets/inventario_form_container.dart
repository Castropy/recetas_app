import 'package:flutter/material.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'inventario_form_fields.dart';

class InventarioFormContainer extends StatelessWidget {
  final FormVisibilityNotifier visibilityNotifier;
  final InventarioFormNotifier inventarioNotifier;

  const InventarioFormContainer({
    super.key,
    required this.visibilityNotifier,
    required this.inventarioNotifier,
  });

  @override
  Widget build(BuildContext context) {
    if (!visibilityNotifier.isVisible) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: InventarioFormFields(inventarioNotifier: inventarioNotifier),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}