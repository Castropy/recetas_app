import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/vender_notifier.dart';
import 'package:recetas_app/screens/Screen_vender/widgets/vender_button_section.dart';

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
          // Listado de Recetas
          Expanded(
            child: StreamBuilder<List<Receta>>(
              stream: venderNotifier.watchAllRecetas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sell_outlined, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          const Text(
                            'No hay recetas disponibles para vender.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final recetas = snapshot.data!;
                return ListView.builder(
                  // Agregamos padding inferior para que la lista no choque con el botón de vender
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  itemCount: recetas.length,
                  itemBuilder: (context, index) {
                    final receta = recetas[index];
                    final isSelected = venderNotifier.recetasSeleccionadas.contains(receta);
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      elevation: isSelected ? 4 : 1, // Elevación dinámica según selección
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected 
                              ? theme.colorScheme.secondary 
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        // Usamos un padding interno para evitar que el texto pegue con los bordes curvos del StadiumBorder
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        leading: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isSelected 
                              ? Icon(Icons.check_circle, key: const ValueKey('sel'), color: theme.colorScheme.secondary) 
                              : const Icon(Icons.circle_outlined, key:  ValueKey('unsel'), color: Colors.grey),
                        ),
                        title: Text(
                          receta.nombre, 
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Previene errores con nombres largos
                        ),
                        subtitle: Text(
                          'Costo: \$${receta.costoTotal.toStringAsFixed(2)}',
                          maxLines: 1,
                        ),
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
          
          // Sección inferior del Botón (Suele contener el total y el botón)
          // Usamos un Material decorado para que se sienta como una barra de herramientas firme
          Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              top: false, // El SafeArea solo se preocupa por la parte de abajo (notch/gestos)
              child: VenderButtonSection(venderNotifier: venderNotifier),
            ),
          ),
        ],
      ),
    );
  }
}