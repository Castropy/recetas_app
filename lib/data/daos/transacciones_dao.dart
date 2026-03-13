import 'package:drift/drift.dart';
import '../database/database.dart';

part 'transacciones_dao.g.dart';

@DriftAccessor(tables: [Transacciones])
class TransaccionesDao extends DatabaseAccessor<AppDatabase> with _$TransaccionesDaoMixin {
  TransaccionesDao(super.db);
}