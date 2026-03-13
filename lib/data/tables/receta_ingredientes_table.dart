import 'package:drift/drift.dart';
import 'ingredientes_table.dart';
import 'recetas_table.dart';

class RecetaIngredientes extends Table {
  IntColumn get recetaId => integer().references(Recetas, #id)();
  IntColumn get ingredienteId => integer().references(Ingredientes, #id)();
  RealColumn get cantidadNecesaria => real()();

  @override
  Set<Column> get primaryKey => {recetaId, ingredienteId};
}