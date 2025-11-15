import 'package:flutter/material.dart';

// 🗑️ Widget para encapsular el IconButton de eliminar con alerta de confirmación
class DeleteButton extends StatelessWidget {
  final int ingredienteId;
  // Función que se ejecutará SOLO si el usuario confirma la eliminación.
  final Function(BuildContext context, int id) onDelete;

  const DeleteButton({
    super.key,
    required this.ingredienteId,
    required this.onDelete,
  });

  // --- Lógica del Diálogo de Confirmación ---
  Future<void> _showConfirmationDialog(BuildContext context) async {
    // Muestra el diálogo y espera a que el usuario presione un botón.
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: 
          Text
          ('¿Está seguro de que desea eliminar el ítem ID: $ingredienteId? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            // Botón de Cancelar: Devuelve 'false'
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            // Botón de Eliminar: Devuelve 'true'
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    // Si se confirmó la eliminación, llama a la función pasada por el widget padre.
    if (shouldDelete == true) {
      if (!context.mounted) return;
      onDelete(context, ingredienteId);
    }
  }
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.redAccent,
        size: 28,
      ),
      onPressed: () {
        // Al presionar, inicia el flujo de confirmación.
        _showConfirmationDialog(context);
      },
    );
  }
}

// NOTA IMPORTANTE: Para usar este widget, el código que lo contenga (el padre)
// debe proporcionar la función 'onDelete' para manejar la lógica de eliminación real.
