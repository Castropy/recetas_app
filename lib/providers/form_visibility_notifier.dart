import 'package:flutter/material.dart';

class FormVisibilityNotifier extends ChangeNotifier {
  // Estado que determina si los TextFormFields son visibles
  bool _isVisible = false; 

  bool get isVisible => _isVisible;

  // Método para mostrar los campos
  void showForm() {
    _isVisible = true;
    notifyListeners(); // Notifica a los widgets que el estado ha cambiado
  }

  // Método para ocultar los campos
  void hideForm() {
    _isVisible = false;
    notifyListeners();
  }
} 