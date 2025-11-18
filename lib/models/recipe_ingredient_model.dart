class RecipeIngredientModel {
  // ID del Ingrediente existente en la tabla 'Ingredientes'
  final int ingredienteId; 
  // Nombre del ingrediente (para mostrar en la UI)
  final String nombre; 
  // Precio por unidad de inventario 
  final double precioUnitario; 
  // Cantidad necesaria de este ingrediente para UNA unidad de la receta
  final double cantidadNecesaria; 

  RecipeIngredientModel({
    required this.ingredienteId,
    required this.nombre,
    required this.precioUnitario,
    required this.cantidadNecesaria,
  });

  // Getter para calcular el costo de este ingrediente dentro de la receta (Subtotal)
  double get costoSubtotal => precioUnitario * cantidadNecesaria;
}