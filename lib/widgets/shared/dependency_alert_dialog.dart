import 'package:flutter/material.dart';

class DependencyAlertDialog extends StatelessWidget {
  final String mensaje;

  const DependencyAlertDialog({
    super.key,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
          SizedBox(width: 10),
          Text(
            'Acción Restringida',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        mensaje,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'ENTENDIDO',
            style: TextStyle(
              color: Color.fromARGB(255, 130, 156, 243), // El color de tu marca
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}