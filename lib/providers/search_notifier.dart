import 'package:flutter/material.dart';

// Definimos los tipos de filtro disponibles
enum SearchFilter { nombre, id, precio }

class SearchNotifier extends ChangeNotifier {
  // 🟢 Estado de la Búsqueda
  String _query = '';
  SearchFilter _filter = SearchFilter.nombre;

  String get query => _query;
  SearchFilter get filter => _filter;

  // 🟢 Método para actualizar la consulta y el filtro
  void updateSearch(String newQuery, SearchFilter newFilter) {
    if (_query != newQuery || _filter != newFilter) {
      _query = newQuery.trim();
      _filter = newFilter;
      notifyListeners();
    }
  }

  // 🟢 Método para limpiar la búsqueda
  void clearSearch() {
    if (_query.isNotEmpty || _filter != SearchFilter.nombre) {
      _query = '';
      _filter = SearchFilter.nombre;
      notifyListeners();
    }
  }
}