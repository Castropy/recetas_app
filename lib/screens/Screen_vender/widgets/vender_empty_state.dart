import 'package:flutter/material.dart';

class VenderEmptyState extends StatelessWidget {
  const VenderEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
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
}