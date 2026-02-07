class RecipeIngredientModel {
  final int ingredienteId; 
  final String nombre; 
  final double precioUnitario; // El precio registrado en inventario (ej: $6.0)
  final double cantidadNecesaria; // Lo que pide la receta (ej: 2.0 huevos)
  
  // 🟢 NUEVOS CAMPOS:
  final double stockInventario; // Cuánto venía por ese precio (ej: 30.0 piezas)
  final String unidadMedida;    // 'g', 'ml' o 'und'

  RecipeIngredientModel({
    required this.ingredienteId,
    required this.nombre,
    required this.precioUnitario,
    required this.cantidadNecesaria,
    required this.stockInventario,
    required this.unidadMedida,
  });

  // 🟢 LÓGICA CORREGIDA PARA EL CÁLCULO
  double get costoSubtotal {
    // Caso 1: Si el ingrediente se maneja por UNIDADES (como los huevos)
    if (unidadMedida == 'und') {
      // Fórmula: (Precio Total / Cantidad del empaque) * Unidades usadas
      // Ejemplo: ($6.0 / 30) * 2 = $0.40
      return (precioUnitario / stockInventario) * cantidadNecesaria;
    } 
    
    // Caso 2: Si el ingrediente se maneja por PESO o VOLUMEN (Gramos o Mililitros)
    else {
      // Fórmula: (Precio por KG o LT / 1000) * Cantidad usada
      // Ejemplo Harina: ($2.0 / 1000) * 500g = $1.0
      return (precioUnitario / 1000) * cantidadNecesaria;
    }
  }
}