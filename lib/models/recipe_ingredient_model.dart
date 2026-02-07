class RecipeIngredientModel {
  // ID del Ingrediente existente en la tabla 'Ingredientes'
  final int ingredienteId; 
  
  // Nombre del ingrediente (para mostrar en la UI)
  final String nombre; 
  
  // 🟢 IMPORTANTE: Este precio ya viene "masticado" desde la DB.
  // Es el costo de 1 sola unidad (1g, 1ml o 1 huevo).
  final double precioUnitario; 
  
  // Cantidad necesaria para la receta (Ej: 5.0 huevos o 500.0 gramos)
  final double cantidadNecesaria; 

  // Cantidad total disponible en el inventario
  final double stockInventario; 

  // Unidad de medida ('g', 'ml', 'und')
  final String unidadMedida;

  RecipeIngredientModel({
    required this.ingredienteId,
    required this.nombre,
    required this.precioUnitario,
    required this.cantidadNecesaria,
    required this.stockInventario,
    required this.unidadMedida,
  });

  // 🟢 CÁLCULO DIRECTO Y SIN ERRORES:
  // Como precioUnitario es el costo de UNA unidad, simplemente multiplicamos.
  // Ejemplo Huevo: 5 (cantidad) * 0.20 (precio base) = $1.00
  // Ejemplo Harina: 500 (gramos) * 0.00122 (precio base) = $0.61
  double get costoSubtotal => precioUnitario * cantidadNecesaria;

  // Getter para mostrar el costo con 2 decimales en la UI
  String get costoFormateado => costoSubtotal.toStringAsFixed(2);
}