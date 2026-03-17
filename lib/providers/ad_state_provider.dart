import 'package:flutter/material.dart';

class AdStateProvider extends ChangeNotifier {
  int _interactionCount = 0;
  
  // Umbral de interacciones: cada 5 acciones importantes, intentaremos mostrar un anuncio.
  // Puedes subir este número si sientes que molesta mucho al usuario.
  final int _threshold = 5; 

  int get interactionCount => _interactionCount;

  /// Registra una interacción (clic en vender, guardar ingrediente, etc.)
  /// Retorna [true] si se alcanzó el límite y es momento de mostrar un anuncio.
  bool recordInteraction() {
    _interactionCount++;
    
    if (_interactionCount >= _threshold) {
      _resetCounter();
      return true;
    }
    
    notifyListeners();
    return false;
  }

  void _resetCounter() {
    _interactionCount = 0;
    notifyListeners();
  }
}