import 'package:flutter/material.dart';


class FloatingActionButtonVender extends StatelessWidget {
  const FloatingActionButtonVender({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
    onPressed: () {
    // Lógica al presionar el botón
    
  },
  label: const Text('Vender'), // 👈texto
  icon: const Icon(Icons.add_card),        // 👈 icono
  backgroundColor: Color.fromARGB(255, 45, 85, 216), // para darle un color
  foregroundColor: Colors.white,
    );
  }
}

class FloatingActionButtonCancelar extends StatelessWidget {
  const FloatingActionButtonCancelar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
    onPressed: () {
    // Lógica al presionar el botón
  },
  label: const Text('Cancelar'), // 👈texto
  icon: const Icon(Icons.cancel_sharp),        // 👈 icono
  backgroundColor: Color.fromARGB(255, 250, 12, 12), // para darle un color
  foregroundColor: Colors.white,
    );
  }
}

class FloatingActionButtonGuardar extends StatelessWidget {
  const FloatingActionButtonGuardar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
    onPressed: () {
    // Lógica al presionar el botón
  },
  label: const Text('Guardar'), // 👈texto
  icon: const Icon(Icons.save_rounded),        // 👈 icono
  backgroundColor: Color.fromARGB(186, 2, 206, 30), // para darle un color
  foregroundColor: Colors.white,
    );
  }
}