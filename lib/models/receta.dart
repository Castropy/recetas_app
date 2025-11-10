
class Receta {
   int id;
   String nombre;
   String descripcion;
   double costoTotal;
   List<String> ingredientes; // Lista simple de ingredientes 

  Receta({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.costoTotal,
    required this.ingredientes,
  });
} 