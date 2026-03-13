import 'package:drift/drift.dart';
import '../database/database.dart';

part 'recetas_dao.g.dart';

@DriftAccessor(tables: [Recetas, Ingredientes, RecetaIngredientes, Transacciones])
class RecetasDao extends DatabaseAccessor<AppDatabase> with _$RecetasDaoMixin {
  RecetasDao(super.db);
}