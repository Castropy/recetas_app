import 'package:flutter/material.dart'; 

class BottonNavigationBar extends StatelessWidget {
  const BottonNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color.fromARGB(255, 247, 247, 248),

      // Establece el color de ícono y label cuando NO está seleccionado
      unselectedItemColor: const Color.fromARGB(197, 192, 189, 189),
      backgroundColor: const Color.fromARGB(148, 10, 6, 243),
      items: const <BottomNavigationBarItem>[
        // Primer Ítem
        BottomNavigationBarItem(
          icon: Icon(
            Icons.food_bank_sharp,
            color: Colors.white,
          ),
          label: 'Recetas',
        ),
        // Segundo Ítem
        BottomNavigationBarItem(
          icon: Icon(
            Icons.sell_rounded,
            color: Colors.white,
          ),
          label: 'Nueva Venta',
        ),
        // Tercer Ítem
        BottomNavigationBarItem(
          icon: Icon(
            Icons.inventory_rounded,
            color: Colors.white,
          ),
          label: 'Inventario',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.file_present,
            color: Colors.white,
          ),
          label: 'Reportes',
        ),
      ],
    );
  }
}