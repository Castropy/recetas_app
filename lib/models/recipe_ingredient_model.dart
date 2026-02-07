class RecipeIngredientModel {
  final int ingredienteId; 
  final String nombre; 
  
  // 🟢 Este precio ya es el costo de 1 gramo, 1 ml o 1 huevo.
  final double precioUnitario; 
  
  final double cantidadNecesaria; 
  final double stockInventario; 
  final String unidadMedida;

  RecipeIngredientModel({
    required this.ingredienteId,
    required this.nombre,
    required this.precioUnitario,
    required this.cantidadNecesaria,
    required this.stockInventario,
    required this.unidadMedida,
  });

  // 🟢 CÁLCULO DIRECTO:
  // Al multiplicar la cantidad por el precio de 1 unidad, el resultado es exacto.
  double get costoSubtotal => precioUnitario * cantidadNecesaria;

  String get costoFormateado => costoSubtotal.toStringAsFixed(2);
}