import 'package:drift/drift.dart';
import '../database/database.dart';
import '../tables/tables.dart'; // Aseguramos el acceso a la clase Ingredientes

part 'ingredientes_dao.g.dart';

@DriftAccessor(tables: [Ingredientes])
class IngredientesDao extends DatabaseAccessor<AppDatabase> with _$IngredientesDaoMixin {
  IngredientesDao(super.db);
  @override 
  // Getter explícito para resolver el error de "Undefined name 'ingredientes'"
  $IngredientesTable get ingredientes => db.ingredientes;

  // Obtener todos los ingredientes
  Future<List<Ingrediente>> getAllIngredientes() => select(ingredientes).get();
  
  // Insertar nuevo ingrediente
  Future<int> insertIngrediente(IngredientesCompanion ingrediente) {
    return into(ingredientes).insert(ingrediente);
  }

  // Actualizar un ingrediente existente (reemplaza toda la fila)
  Future<bool> updateIngrediente(Ingrediente ingrediente) {
    return update(ingredientes).replace(ingrediente);
  }

  // Eliminar ingrediente por ID
  Future<int> deleteIngrediente(int id) {
    return (delete(ingredientes)..where((tbl) => tbl.id.equals(id))).go();
  } 

  // Stream para observar el inventario en tiempo real (UI reactiva)
  Stream<List<Ingrediente>> watchInventarioIngredientes() => select(ingredientes).watch();

  // Buscar un ingrediente específico por su ID
  Future<Ingrediente?> getIngredienteById(int id) {
    return (select(ingredientes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Obtener una lista de ingredientes basada en una lista de IDs
  Future<List<Ingrediente>> getIngredientesByIds(List<int> ids) {
    return (select(ingredientes)..where((tbl) => tbl.id.isIn(ids))).get();
  }
}