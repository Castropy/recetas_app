import 'package:flutter/material.dart';
import 'package:recetas_app/models/receta.dart';

class RecetasProvider extends ChangeNotifier {
  // Lista inicial de recetas (puedes cargarla desde una base de datos o API)
 final List<Receta> _recetas = [
    Receta(
      id: 1,
      nombre: 'Tarta de Manzana Clásica',
      descripcion: 'Receta fácil de tarta de manzana con canela.',
      costoTotal: 8.50,
      ingredientes: ['Manzanas', 'Harina', 'Azúcar', 'Canela'],
    ),
    Receta(
      id: 2,
      nombre: 'Pizza Margarita',
      descripcion: 'La auténtica pizza napolitana.',
      costoTotal: 12.30,
      ingredientes: ['Masa', 'Tomate', 'Mozzarella', 'Albahaca'],
    ),
  ];

  List<Receta> get recetas =>_recetas; // Getter para acceder a la lista

  // Método para agregar nuevas recetas (lo usarás desde tu formulario)
  void agregarReceta(Receta nuevaReceta) {
    _recetas.add(nuevaReceta);
    notifyListeners(); // Notifica a todos los Consumers que la lista cambió
  }
} 