import 'package:drift/drift.dart';
//  tabla de ingredientes 
class Ingredientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 40)();
  RealColumn get precio => real()();
  DateTimeColumn get fechaCreacion => dateTime().withDefault(currentDateAndTime)();
}
