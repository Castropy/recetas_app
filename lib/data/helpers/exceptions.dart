/// Excepción lanzada cuando existe una restricción de integridad referencial.
class IngredienteVinculadoException implements Exception {
  final String mensaje;
  
  IngredienteVinculadoException([
    this.mensaje = 'Restricción de integridad: El ingrediente está vinculado a una receta activa. Desvincúlelo de la receta para permitir la eliminación.'
  ]);

  @override
  String toString() => 'IngredienteVinculadoException: $mensaje';
}