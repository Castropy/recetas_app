import 'package:flutter/material.dart';
// Asegúrate de importar el modelo Ingrediente si no está ya en scope
// import 'package:recetas_app/data/database/database.dart'; 
import 'package:recetas_app/widgets/shared/icon_button_custom.dart'; // Asumo que este es el botón de eliminar encapsulado

// Asumo que tienes una clase Ingrediente (generada por drift/moor) en tu proyecto
class Ingrediente {
  final int id;
  final String nombre;
  final int cantidad;
  final double precio;
  Ingrediente({required this.id, required this.nombre, required this.cantidad, required this.precio});
}

class IngredienteCard extends StatelessWidget {
  final Ingrediente ingrediente;
  final Function(BuildContext context, int id) onDelete;

  const IngredienteCard({
    super.key,
    required this.ingrediente,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        // Agregamos una elevación y un borde redondeado atractivo
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            // Un degradado sutil puede mejorar la apariencia
            gradient: const LinearGradient(
              colors: [Color(0xFFE8F5E9), Colors.white], // Verde claro a blanco
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icono decorativo a la izquierda
                const Icon(
                  Icons.local_grocery_store,
                  color: Color(0xFF4CAF50), // Verde primario
                  size: 30,
                ),
                const SizedBox(width: 16),
                
                // Columna de detalles del ingrediente
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingrediente.nombre,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20), // Verde oscuro
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cantidad: ${ingrediente.cantidad}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Precio: \$${ingrediente.precio.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'ID: ${ingrediente.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Botón de eliminar (encapsulado)
                DeleteButton(
                  ingredienteId: ingrediente.id,
                  onDelete: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}