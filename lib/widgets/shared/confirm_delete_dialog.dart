// lib/widgets/shared/confirm_delete_dialog.dart

import 'package:flutter/material.dart';

// Definimos una función simple que devuelve un Future<bool?>
// El valor de retorno indica si el usuario confirmó (true) o canceló (null).
Future<bool?> showConfirmDeleteDialog(
  BuildContext context, {
  required String itemName, // El nombre del elemento a eliminar
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "$itemName"? Esta acción es irreversible.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(false); // Retorna falso si cancela
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Eliminar'),
            onPressed: () {
              Navigator.of(context).pop(true); // Retorna verdadero si confirma
            },
          ),
        ],
      );
    },
  );
}