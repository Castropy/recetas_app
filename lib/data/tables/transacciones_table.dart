import 'package:drift/drift.dart';

class Transacciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get fechaHora => dateTime().withDefault(currentDateAndTime)();
  TextColumn get tipo => text().withLength(max: 15)();
  TextColumn get entidad => text().withLength(max: 15)(); 
  IntColumn get entidadId => integer().nullable()(); 
  TextColumn get detalles => text()(); 
}