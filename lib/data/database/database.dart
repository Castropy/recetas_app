import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart'; 



LazyDatabase _openConnection() { 
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite')); 
    return NativeDatabase(file);
  });
}

class Ingredientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 40)();
  IntColumn get cantidad => integer()();
  RealColumn get precio => real()();
  DateTimeColumn get fechaCreacion => dateTime().withDefault(currentDateAndTime)();
}

class Recetas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 40)();
  RealColumn get costoTotal => real()();
  DateTimeColumn get fechaCreacion => dateTime().withDefault(currentDateAndTime)();
}
//Tabla de union entre recetas e ingredientes (relacion muchos a muchos)
class RecetaIngredientes extends Table {
  // Clave de la tabla recetas
  IntColumn get recetaId => integer().references(Recetas, #id)();
  // Clave de la tabla ingredientes
  IntColumn get ingredienteId => integer().references(Ingredientes, #id)();
  // Cantidad de este ingrediente necesaria para UNA unidad de la receta
  RealColumn get cantidadNecesaria => real()();
  @override
  Set<Column> get primaryKey => {recetaId, ingredienteId};
  
}
 

@DriftDatabase(tables: [Ingredientes, Recetas, RecetaIngredientes])
class AppDatabase extends _$AppDatabase { 
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  // ... (Queries)
  Future<List<Ingrediente>> getAllIngredientes() => select(ingredientes).get();
  
  Future<int> insertIngrediente(IngredientesCompanion ingrediente) {
    return into(ingredientes).insert(ingrediente);
  }

  Future<bool> updateIngrediente(Ingrediente ingrediente) {
    return update(ingredientes).replace(ingrediente);
  }

  Future<int> deleteIngrediente(int id) {
    return (delete(ingredientes)..where((tbl) => tbl.id.equals(id))).go();
  } 
  
  Future<void> saveRecetaTransaction(
      RecetasCompanion receta, 
      List<RecetaIngredientesCompanion> ingredientes) async {
    
    // Inicia una transacción
    await transaction(() async {
      // 1. Insertar la Receta principal. Esto devuelve el ID autogenerado (INT).
      final int recetaId = await into(recetas).insert(receta);

      // 2. Preparar los compañeros de Ingredientes para la inserción.
      final List<RecetaIngredientesCompanion> listToInsert = [];

      for (var item in ingredientes) {
        // 🟢 CLAVE: Creamos una COPIA del Companion, inyectando el ID real de la receta.
        final RecetaIngredientesCompanion updatedCompanion = item.copyWith(
          recetaId: Value(recetaId), // Inyectamos el ID de la receta que acabamos de crear
        );
        listToInsert.add(updatedCompanion);
      }
      await batch((batch) {
        batch.insertAll(recetaIngredientes, listToInsert);
      });
      
      return recetaId;
    });
  }

  // Obtener todas las recetas (para listar en ScreenRecetas)
  Stream<List<Receta>> watchAllRecetas() => select(recetas).watch();

  Future<Map<Receta, List<RecetaIngrediente>>> getRecetaDetails(int id) async {
  // 1. Obtener la Receta principal
  final receta = await (select(recetas)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  if (receta == null) {
    return {};
  }

  // 2. Obtener los ingredientes relacionados.
  // Es una consulta simple a la tabla de unión filtrada por el ID.
  final ingredientes = await (select(recetaIngredientes)
    ..where((tbl) => tbl.recetaId.equals(id))
  ).get();
  
  // 3. Devolvemos un Map con la Receta como clave y la lista de sus ingredientes como valor.
  return {receta: ingredientes};
}

  // Stream para la lista de Ingredientes de Inventario (usado en el selector de recetas)
  Stream<List<Ingrediente>> watchInventarioIngredientes() => select(ingredientes).watch();

  Future<Ingrediente?> getIngredienteById(int id) {
  return (select(ingredientes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
}

// Método transaccional para eliminar la receta y sus ingredientes asociados
Future<void> deleteRecetaTransaction(int recetaId) async {
  await transaction(() async {
    // 1. Eliminar todos los ingredientes relacionados en la tabla de unión
    await (delete(recetaIngredientes)
          ..where((tbl) => tbl.recetaId.equals(recetaId)))
        .go();

    // 2. Eliminar la Receta principal
    await (delete(recetas)..where((tbl) => tbl.id.equals(recetaId))).go();
  });
}

  
} 