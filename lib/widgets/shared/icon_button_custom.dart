import 'package:flutter/material.dart';

// Widget simple para encapsular el IconButton de eliminar
class DeleteButton extends StatelessWidget {
  final int ingredienteId;
  final Function(BuildContext context, int id) onDelete;

  const DeleteButton({
    super.key,
    required this.ingredienteId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.red,
        size: 25,
      ),
      onPressed: () {
        // Llama a la función de eliminación proporcionada por el padre
        onDelete(context, ingredienteId);
      },
    );
  }
}