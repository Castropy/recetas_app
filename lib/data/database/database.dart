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
  
  Future<int> createReceta(RecetasCompanion receta, List<RecetaIngredientesCompanion> ingredientesReceta) async {
    return transaction(() async {
      // 1. Insertar la Receta principal
      final recetaId = await into(recetas).insert(receta);
      
      // 2. Insertar los ingredientes asociados a esa Receta (usando el ID recién creado)
      final itemsToInsert = ingredientesReceta.map((i) => 
        i.copyWith(recetaId: Value(recetaId))
      ).toList();

      await batch((batch) {
        batch.insertAll(recetaIngredientes, itemsToInsert);
      });
      
      return recetaId;
    });
  }

  // Obtener todas las recetas (para listar en ScreenRecetas)
  Stream<List<Receta>> watchAllRecetas() => select(recetas).watch();

  // Stream para la lista de Ingredientes de Inventario (usado en el selector de recetas)
  Stream<List<Ingrediente>> watchInventarioIngredientes() => select(ingredientes).watch();

  
} 