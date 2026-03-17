import 'package:drift/drift.dart';
import '../database/database.dart';
import '../tables/tables.dart'; // Importante para reconocer la clase Transacciones

part 'transacciones_dao.g.dart';

@DriftAccessor(tables: [Transacciones])
class TransaccionesDao extends DatabaseAccessor<AppDatabase> with _$TransaccionesDaoMixin {
  TransaccionesDao(super.db);
  @override
  // Getter explícito para resolver el error de "Undefined name 'transacciones'"
  $TransaccionesTable get transacciones => db.transacciones;
  
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