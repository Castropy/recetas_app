import 'package:drift/drift.dart';
import '../database/database.dart';
// Quitamos el import de tables.dart momentáneamente para evitar el conflicto de nombres
// mientras database.dart no esté limpio.

part 'ingredientes_dao.g.dart';

@DriftAccessor(tables: [Ingredientes]) 
class IngredientesDao extends DatabaseAccessor<AppDatabase> with _$IngredientesDaoMixin {
  // Usamos 'super' parameters (Flutter moderno) para limpiar el warning de severidad 2
  IngredientesDao(super.db);
}