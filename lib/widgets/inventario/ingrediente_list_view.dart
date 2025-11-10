import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Asegúrate de que esta ruta sea correcta para tu base de datos
import 'package:recetas_app/data/database/database.dart'; 

class IngredienteListView extends StatelessWidget {
  const IngredienteListView({super.key});

  @override
  Widget build(BuildContext context) {
    // El widget Listview necesita estar envuelto en algo flexible como Expanded
    return Expanded(
      child: StreamBuilder<List<Ingrediente>>(
        // Accede a la instancia de la DB a través del Provider
        // Nota: Provider.of<AppDatabase>(context) se usa dentro de StreamBuilder,
        // por lo que 'listen: true' es implícito y necesario para acceder al stream.
        stream: Provider.of<AppDatabase>(context).select(
          Provider.of<AppDatabase>(context).ingredientes
        ).watch(), 
        
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay ingredientes guardados.'));
          }

          final ingredientes = snapshot.data!;
          return ListView.builder(
            itemCount: ingredientes.length,
            itemBuilder: (context, index) {
              final ing = ingredientes[index];
              return ListTile(
                title: Text(
                  ing.nombre, 
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Id: ${ing.id} | Cant: ${ing.cantidad} | Precio: \$${ing.precio.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 2, 2, 2),
                    fontSize: 16,
                  ),
                ),
                // Aquí podrías añadir un trailing para editar o borrar
              );
            },
          );
        },
      ),
    );
  }
}