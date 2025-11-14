import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';



class FloatingActionButtonCrear extends StatelessWidget {
  const FloatingActionButtonCrear({super.key});

  @override
  Widget build(BuildContext context) {
    final formNotifier = Provider.of<FormVisibilityNotifier>(context, listen: false);
    return FloatingActionButton.extended(
    onPressed: () {
    // Lógica al presionar el botón
   return formNotifier.showForm(); 
   
  },
  label: const Text(
    'Crear Receta', 
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      ),
    ), // 👈texto
  icon: const Icon(
    Icons.add_card,
    size: 15,
    ),        // 👈 icono
  backgroundColor: Color.fromARGB(255, 45, 85, 216), // para darle un color
  foregroundColor: Colors.white,

    );
  }
} 

class FloatingActionButtonCancelar extends StatelessWidget {
  const FloatingActionButtonCancelar({super.key});

  @override
  Widget build(BuildContext context) {
    final formNotifier = Provider.of<FormVisibilityNotifier>(context, listen: false);
    return FloatingActionButton.extended(
    onPressed: () {
    // Lógica al presionar el botón
    return formNotifier.hideForm(); 
  },
  label: const Text(
    'Cancelar',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  ), // 👈texto
  icon: const Icon(
    Icons.cancel_sharp,
    size: 14,
    ), 
  backgroundColor: Color.fromARGB(255, 250, 12, 12), // para darle un color
  foregroundColor: Colors.white,
    );
  }
}

class FloatingActionButtonGuardar extends StatelessWidget {
  final VoidCallback onPressed;
  const FloatingActionButtonGuardar({
    super.key, 
    required this.onPressed, // Debe ser requerido
  });

  @override
  Widget build(BuildContext context) {
    
    return FloatingActionButton.extended(
    onPressed: onPressed,
    // Lógica al presionar el botón
    
  
  label: const Text(
    'Guardar',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      ),
    ), // 👈texto
  icon: const Icon(
    Icons.save_rounded,
    size: 14,
    ),        // 👈 icono
  backgroundColor: Color.fromARGB(186, 2, 206, 30), // para darle un color
  foregroundColor: Colors.white,
    );
  }
}

class FloatingActionButtonAgregar extends StatelessWidget {
  const FloatingActionButtonAgregar({super.key});

  @override
  Widget build(BuildContext context) {
    final formNotifier = Provider.of<FormVisibilityNotifier>(context, listen: false);
    return FloatingActionButton.extended(
    onPressed: () {
    // Lógica al presionar el botón
   return formNotifier.showForm(); 
   
  },
  label: const Text(
    'Agregar', 
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      ),
    ), // 👈texto
  icon: const Icon(
    Icons.add_card,
    size: 14,
    ),        // 👈 icono
  backgroundColor: Color.fromARGB(255, 45, 85, 216), // para darle un color
  foregroundColor: Colors.white,

    );
  }
} 

class FloatingActionButtonEditar extends StatelessWidget {
  const FloatingActionButtonEditar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
    onPressed: () {
    // Lógica al presionar el botón
  },
  label: const Text(
    'Editar', 
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      ),
    ), // 👈texto
  icon: const Icon(
    Icons.edit,
    size: 14,
    ),        // 👈 icono
  backgroundColor: Color.fromARGB(255, 45, 85, 216), // para darle un color
  foregroundColor: Colors.white,

    );
  }
} 

class FloatingActionButtonEliminar extends StatelessWidget {
  const FloatingActionButtonEliminar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
    onPressed: () {
    // Lógica al presionar el botón
  },
  label: const Text(
    'Eliminar', 
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      ),
    ), // 👈texto
  icon: const Icon(
    Icons.edit,
    size: 14,
    ),        // 👈 icono
  backgroundColor: Color.fromARGB(255, 250, 12, 12), // para darle un color
  foregroundColor: Colors.white,

    );
  }
} 

