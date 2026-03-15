import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/vender_notifier.dart';
import 'vender_empty_state.dart';

class VenderRecetasList extends StatelessWidget {
  final VenderNotifier venderNotifier;

  const VenderRecetasList({
    super.key, 
    required this.venderNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<Receta>>(
      stream: venderNotifier.watchAllRecetas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const VenderEmptyState();
        }

        final recetas = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          itemCount: recetas.length,
          itemBuilder: (context, index) {
            final receta = recetas[index];
            final isSelected = venderNotifier.recetasSeleccionadas.contains(receta);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: isSelected ? 4 : 1,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected 
                      ? theme.colorScheme.secondary 
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                leading: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isSelected 
                      ? Icon(Icons.check_circle, key: const ValueKey('sel'), color: theme.colorScheme.secondary) 
                      : const Icon(Icons.circle_outlined, key: ValueKey('unsel'), color: Colors.grey),
                ),
                title: Text(
                  receta.nombre, 
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    );
  }
}