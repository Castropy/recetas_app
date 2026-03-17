import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importante para el context.read
import 'package:recetas_app/providers/receta_form_notifier.dart';
import 'package:recetas_app/providers/ad_state_provider.dart'; // Nuevo
import 'package:recetas_app/helpers/ad_helper.dart'; // Nuevo

class CostoTotalSection extends StatelessWidget {
  final RecetaFormNotifier notifier;

  const CostoTotalSection({
    super.key, 
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, 
            blurRadius: 4, 
            offset: Offset(0, -2),
          )
        ],
      ),
      padding: EdgeInsets.only(
        left: 16.0, 
        right: 16.0, 
        top: 10,
        bottom: bottomPadding + 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Costo de Producción:', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                '\$${notifier.costoTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.w900, 
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: notifier.ingredientesSeleccionados.isEmpty 
                ? null 
                : () async {
                    // 1. Ejecutamos el guardado de la receta
                    await notifier.guardarReceta(context);

                    // 2. Lógica de Anuncios:
                    // Registramos la interacción y lanzamos si llegamos al límite
                    if (context.mounted) {
                      final adProvider = context.read<AdStateProvider>();
                      if (adProvider.recordInteraction()) {
                        AdHelper.showInterstitialAd();
                      }
                    }
                  },
            icon: const Icon(Icons.save_rounded),
            label: const Text(
              'GUARDAR RECETA', 
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}