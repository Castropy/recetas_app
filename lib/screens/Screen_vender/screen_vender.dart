import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
// 🆕 IMPORTA EL NUEVO NOTIFIER
import 'package:recetas_app/providers/vender_notifier.dart';
import 'package:recetas_app/widgets/vender_button_section.dart';

class ScreenVender extends StatelessWidget {
  const ScreenVender({super.key});
 
  @override
  Widget build(BuildContext context) {
    // 🟢 Escucha al Notifier para reaccionar a la selección
    final venderNotifier = Provider.of<VenderNotifier>(context);
    final theme = Theme.of(context);

   return Scaffold(
        appBar: AppBar(
            title:  const Text(
                'Vender Recetas',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color:  Color.fromARGB(255, 45, 85, 216),
                ),
            ),
            centerTitle: true,
        ),
        body: Column(
            children: [
                // Listado de Recetas (Punto 1: Selección)
                Expanded(
                    child: StreamBuilder<List<Receta>>(
                        stream: venderNotifier.watchAllRecetas(),
                        builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text('No hay recetas disponibles.'));
                            }

                            final recetas = snapshot.data!;
                            return ListView.builder(
                                itemCount: recetas.length,
                                itemBuilder: (context, index) {
                                    final receta = recetas[index];
                                    // Comprueba si la receta está seleccionada
                                    final isSelected = venderNotifier.recetasSeleccionadas.contains(receta);
                                    
                                    return Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                        elevation: 3,
                                        shape: StadiumBorder(
                                            side: BorderSide(
                                                color: isSelected 
                                                    ? theme.colorScheme.secondary 
                                                    : Colors.grey.shade300,
                                                width: 2,
                                            ),
                                        ),
                                        child: ListTile(
                                            // Icono de selección
                                            leading: isSelected 
                                                ? Icon(Icons.check_circle, color: theme.colorScheme.secondary) 
                                                : const Icon(Icons.circle_outlined, color: Colors.grey),
                                            title: Text(receta.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                                            subtitle: Text('Costo: \$${receta.costoTotal.toStringAsFixed(2)}'),
                                            // Al tocar, alterna la selección (Punto 1)
                                            onTap: () {
                                                venderNotifier.toggleRecetaSelection(receta);
                                            },
                                        ),
                                    );
                                },
                            );
                        },
                    ),
                ),
                
                // Botón de Venta
                VenderButtonSection(venderNotifier: venderNotifier),
            ],
        ),
  );
  }
}

