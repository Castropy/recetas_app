import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/vender_notifier.dart';
import 'package:recetas_app/providers/ad_state_provider.dart'; // Nuevo
import 'package:recetas_app/helpers/ad_helper.dart'; // Nuevo

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
        onPressed: isEnabled 
            ? () async {
                // 1. Ejecutar la lógica de venta (Drift + Notifier)
                await venderNotifier.venderRecetas(context);

                // 2. Lógica de Anuncios:
                // Registramos la interacción tras la venta exitosa
                if (context.mounted) {
                  final adProvider = context.read<AdStateProvider>();
                  if (adProvider.recordInteraction()) {
                    AdHelper.showInterstitialAd();
                  }
                }
              } 
            : null,
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