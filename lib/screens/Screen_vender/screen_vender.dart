import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/vender_notifier.dart';

// Importación única mediante el Barrel File
import 'widgets/widgets.dart';

/// Pantalla de ventas de recetas.
/// 
/// Permite seleccionar múltiples recetas para procesar una venta,
/// actualizando el inventario y calculando costos en tiempo real.
class ScreenVender extends StatelessWidget {
  const ScreenVender({super.key});

  @override
  Widget build(BuildContext context) {
    final venderNotifier = Provider.of<VenderNotifier>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vender Recetas',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: Color.fromARGB(255, 45, 85, 216),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Listado de Recetas (StreamBuilder y lógica de tarjetas encapsulados)
          Expanded(
            child: VenderRecetasList(venderNotifier: venderNotifier),
          ),
          
          // 2. Sección inferior de acción
          // Incluye sombra superior para dar profundidad sobre la lista
          Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: VenderButtonSection(venderNotifier: venderNotifier),
            ),
          ),
        ],
      ),
    );
  }
}