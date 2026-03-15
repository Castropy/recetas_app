import 'package:flutter/material.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/screens/Screen_recetas/detalle_receta_screen.dart';
import 'package:recetas_app/screens/Screen_recetas/receta_form_screen.dart';
import 'package:recetas_app/widgets/shared/confirm_delete_dialog.dart';
import 'package:recetas_app/widgets/shared/notificacion_snack_bar.dart';

class RecetaListCard extends StatelessWidget {
  final Receta receta;
  final AppDatabase db;

  const RecetaListCard({super.key, required this.receta, required this.db});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('${receta.id}', style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
        title: Text(
          receta.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('Costo: \$${receta.costoTotal.toStringAsFixed(2)}'),
        trailing: Wrap(
          spacing: -8,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blueGrey),
              onPressed: () => Navigator.pushNamed(
                context, DetalleRecetaScreen.routeName, arguments: receta.id
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => Navigator.pushNamed(
                context, RecetaFormScreen.routeName, arguments: receta.id
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _handleDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      itemName: receta.nombre,
    );
    if (confirmed == true) {
      await db.recetasDao.deleteRecetaTransaction(receta.id);
      if (context.mounted) {
        NotificacionSnackBar.mostrarSnackBar(
          context, 'Receta "${receta.nombre}" eliminada.'
        );
      }
    }
  }
}