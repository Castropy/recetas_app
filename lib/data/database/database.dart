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

 

@DriftDatabase(tables: [Ingredientes])
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

  
}