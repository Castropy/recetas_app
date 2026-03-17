import 'package:drift/drift.dart';

class Ingredientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  RealColumn get cantidad => real()();
  RealColumn get costoUnitario => real()();
  TextColumn get unidadMedida => text().withDefault(const Constant('g'))();
  DateTimeColumn get fechaCreacion => dateTime().withDefault(currentDateAndTime)();
}