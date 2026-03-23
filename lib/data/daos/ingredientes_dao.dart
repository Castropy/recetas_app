import 'package:drift/drift.dart';
import 'package:recetas_app/data/helpers/exceptions.dart';
import '../database/database.dart';
import '../tables/tables.dart'; // Aseguramos el acceso a la clase Ingredientes
import 'package:drift/native.dart'; 

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
  Future<void> deleteIngrediente(int id) async {
    try {
      final rowsDeleted = await (delete(ingredientes)..where((tbl) => tbl.id.equals(id))).go();
      
      // Opcional: Si quieres ser extra robusto, podrías validar si se borró algo
      if (rowsDeleted == 0) {
        throw Exception('No se encontró el ingrediente');
      }
    } catch (e) {
      // Capturamos específicamente el error de Foreign Key (787)
      if (e is SqliteException && (e.extendedResultCode == 787 || e.resultCode == 19)) {
        throw IngredienteVinculadoException();
      }
      
      // Si es otro error (disco lleno, db bloqueada, etc), lo lanzamos para depurar
      rethrow;
    }
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