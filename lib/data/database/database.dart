import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Importamos nuestros archivos unificadores (barrel files)
import '../tables/tables.dart';
import '../daos/daos.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [
    Ingredientes, 
    Recetas, 
    RecetaIngredientes, 
    Transacciones
  ],
  daos: [
    IngredientesDao, 
    RecetasDao, 
    TransaccionesDao
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Versión 1 a 2: Crear tabla de transacciones
        if (from < 2) {
          await m.createTable(transacciones);
        }
        
        // Versión 2 a 3: Nueva columna de unidad de medida
        if (from < 3) {
          await m.addColumn(ingredientes, ingredientes.unidadMedida);
        }
        // Versión 3 a 4: Ampliar límite de caracteres en 'nombre'
        if (from < 4) {
          await m.alterTable(TableMigration(ingredientes));
        }
      },
      beforeOpen: (details) async {
        // Activar llaves foráneas siempre es buena práctica
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}