import 'package:drift/drift.dart';
import '../database/database.dart';

part 'transacciones_dao.g.dart';

@DriftAccessor(tables: [Transacciones])
class TransaccionesDao extends DatabaseAccessor<AppDatabase> with _$TransaccionesDaoMixin {
  TransaccionesDao(super.db);

  // Inserción de una Transacción
  Future<int> insertTransaccion(TransaccionesCompanion transaccion) {
    return into(transacciones).insert(transaccion);
  }

  // Stream para observar el historial de transacciones ordenado por fecha
  Stream<List<Transaccione>> watchAllTransacciones() {
    return (select(transacciones)
          ..orderBy([(t) => OrderingTerm(expression: t.fechaHora, mode: OrderingMode.desc)]))
        .watch();
  }
}