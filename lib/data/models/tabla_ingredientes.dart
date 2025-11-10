import 'package:drift/drift.dart';
// Aqui se define la tabla de ingredientes
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 40)();
  RealColumn get precio => real()();
  DateTimeColumn get fechaCreacion => dateTime().withDefault(currentDateAndTime)();
  
}