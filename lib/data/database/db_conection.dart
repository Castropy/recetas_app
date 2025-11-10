import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Obtiene el directorio para almacenar los archivos de la aplicación
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite')); 
    
    // Retorna la conexión nativa
    return NativeDatabase(file);
  });
}