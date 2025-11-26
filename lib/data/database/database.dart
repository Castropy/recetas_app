import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
part 'database.g.dart'; 



LazyDatabase _openConnection() { 
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite')); 
    return NativeDatabase(file);
  });
}

class Ingredientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 40)();
  IntColumn get cantidad => integer()();
 // 🟢 CAMBIO CLAVE: Precio Total se convierte en Costo Unitario
  RealColumn get costoUnitario => real()(); 
 DateTimeColumn get fechaCreacion => dateTime().withDefault(currentDateAndTime)();
}

class Recetas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 40)();
  RealColumn get costoTotal => real()();
  DateTimeColumn get fechaCreacion => dateTime().withDefault(currentDateAndTime)();
}
//Tabla de union entre recetas e ingredientes (relacion muchos a muchos)
class RecetaIngredientes extends Table {
  // Clave de la tabla recetas
  IntColumn get recetaId => integer().references(Recetas, #id)();
  // Clave de la tabla ingredientes
  IntColumn get ingredienteId => integer().references(Ingredientes, #id)();
  // Cantidad de este ingrediente necesaria para UNA unidad de la receta
  RealColumn get cantidadNecesaria => real()();
  @override
  Set<Column> get primaryKey => {recetaId, ingredienteId};
  
}

class Transacciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Fecha y hora del evento
  DateTimeColumn get fechaHora => dateTime().withDefault(currentDateAndTime)();
  // 'Venta', 'Edicion', 'Eliminado', 'Alta'
  TextColumn get tipo => text().withLength(max: 15)();
  // 'Ingrediente', 'Receta'
  TextColumn get entidad => text().withLength(max: 15)(); 
  // ID del objeto afectado (Ingrediente ID o Receta ID)
  IntColumn get entidadId => integer().nullable()(); 
  // Almacena un JSON con los detalles del cambio (ej: antes/después de la edición, ingredientes consumidos en la venta)
  TextColumn get detalles => text()(); 
}

class InsufficientStockException implements Exception {
  final String nombreIngrediente;
  final double requerido;
  final double disponible;
  InsufficientStockException(this.nombreIngrediente, this.requerido, this.disponible);
  
  @override
  String toString() => 'Stock insuficiente de $nombreIngrediente. Requerido: ${requerido.toStringAsFixed(2)}, Disponible: ${disponible.toStringAsFixed(2)}';
}

// Clase auxiliar para la transacción
class _RecetaVentaInfo {
  final Ingrediente ingrediente; // Contiene el stock actual
  final double cantidadNecesaria; // Cantidad requerida por la receta
  _RecetaVentaInfo({required this.ingrediente, required this.cantidadNecesaria});
}
 

@DriftDatabase(tables: [Ingredientes, Recetas, RecetaIngredientes])
class AppDatabase extends _$AppDatabase { 
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  // ... (Queries)
  Future<List<Ingrediente>> getAllIngredientes() => select(ingredientes).get();
  
  Future<int> insertIngrediente(IngredientesCompanion ingrediente) {
    return into(ingredientes).insert(ingrediente);
  }

  Future<bool> updateIngrediente(Ingrediente ingrediente) {
    return update(ingredientes).replace(ingrediente);
  }

  Future<int> deleteIngrediente(int id) {
    return (delete(ingredientes)..where((tbl) => tbl.id.equals(id))).go();
  } 
  
  Future<void> saveRecetaTransaction(
      RecetasCompanion receta, 
      List<RecetaIngredientesCompanion> ingredientes) async {
    
    // Inicia una transacción
    await transaction(() async {
      // 1. Insertar la Receta principal. Esto devuelve el ID autogenerado (INT).
      final int recetaId = await into(recetas).insert(receta);

      // 2. Preparar los compañeros de Ingredientes para la inserción.
      final List<RecetaIngredientesCompanion> listToInsert = [];

      for (var item in ingredientes) {
        // 🟢 CLAVE: Creamos una COPIA del Companion, inyectando el ID real de la receta.
        final RecetaIngredientesCompanion updatedCompanion = item.copyWith(
          recetaId: Value(recetaId), // Inyectamos el ID de la receta que acabamos de crear
        );
        listToInsert.add(updatedCompanion);
      }
      await batch((batch) {
        batch.insertAll(recetaIngredientes, listToInsert);
      });
      
      return recetaId;
    });
  }

  // Obtener todas las recetas (para listar en ScreenRecetas)
  Stream<List<Receta>> watchAllRecetas() => select(recetas).watch();

  Future<Map<Receta, List<RecetaIngrediente>>> getRecetaDetails(int id) async {
  // 1. Obtener la Receta principal
  final receta = await (select(recetas)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  if (receta == null) {
    return {};
  }
 
  // 2. Obtener los ingredientes relacionados.
  // Es una consulta simple a la tabla de unión filtrada por el ID.
  final ingredientes = await (select(recetaIngredientes)
    ..where((tbl) => tbl.recetaId.equals(id))
  ).get();
  
  // 3. Devolvemos un Map con la Receta como clave y la lista de sus ingredientes como valor.
  return {receta: ingredientes};
}

  // Stream para la lista de Ingredientes de Inventario (usado en el selector de recetas)
  Stream<List<Ingrediente>> watchInventarioIngredientes() => select(ingredientes).watch();

  Future<Ingrediente?> getIngredienteById(int id) {
  return (select(ingredientes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
}

// Método transaccional para eliminar la receta y sus ingredientes asociados
Future<void> deleteRecetaTransaction(int recetaId) async {
  await transaction(() async {
    // 1. Eliminar todos los ingredientes relacionados en la tabla de unión
    await (delete(recetaIngredientes)
          ..where((tbl) => tbl.recetaId.equals(recetaId)))
        .go();

    // 2. Eliminar la Receta principal
    await (delete(recetas)..where((tbl) => tbl.id.equals(recetaId))).go();
  });
}

// 🟢 Nuevo: Actualización transaccional de Receta y sus ingredientes
Future<void> updateRecetaTransaction(
      Receta receta, 
      List<RecetaIngredientesCompanion> nuevosIngredientes) async {
    
    await transaction(() async {
      // 1. Actualizar la Receta principal
      await update(recetas).replace(receta); 

      // 2. Eliminar todas las entradas antiguas en RecetaIngredientes para esta Receta
      await (delete(recetaIngredientes)
            ..where((tbl) => tbl.recetaId.equals(receta.id)))
          .go();

      // 3. Insertar todas las nuevas entradas de RecetaIngredientes
      await batch((batch) {
        batch.insertAll(recetaIngredientes, nuevosIngredientes);
      });
    });
  }

  Future<List<Ingrediente>> getIngredientesByIds(List<int> ids) {
  // Utilizamos la cláusula .isIn() de Drift para seleccionar todos los ingredientes
  // cuyos IDs están contenidos en la lista 'ids' proporcionada.
  return (select(ingredientes)..where((tbl) => tbl.id.isIn(ids))).get();
}

// Método de Transacción para Vender Receta
Future<void> venderRecetaTransaction(int recetaId) async {
  // ... (código de obtención de ingredientes sin cambios)
  final ingredientesDeReceta = await (select(recetaIngredientes).join([
    innerJoin(ingredientes, recetaIngredientes.ingredienteId.equalsExp(ingredientes.id))
  ])
      ..where(recetaIngredientes.recetaId.equals(recetaId)))
      .map((row) {
    // Mapeamos los datos de las dos tablas
    final ing = row.readTable(ingredientes);
    final recIng = row.readTable(recetaIngredientes);
    return _RecetaVentaInfo(
      ingrediente: ing,
      cantidadNecesaria: recIng.cantidadNecesaria,
    );
  }).get();

  // Ejecutar la lógica de venta dentro de una transacción para asegurar atomicidad
  await transaction(() async {
    // 🟢 3. Condicional: Verificar Inventario antes de la venta
    for (final info in ingredientesDeReceta) {
      // **CORRECCIÓN 1: Convertir stock a double para la comparación**
      final double stockActual = info.ingrediente.cantidad.toDouble(); 
      final double cantidadRequerida = info.cantidadNecesaria;

      if (stockActual < cantidadRequerida) {
        // ... (código de excepción sin cambios)
        throw InsufficientStockException(
            info.ingrediente.nombre, cantidadRequerida, stockActual);
      }
    }

    // 🟢 2. Logica de Venta: Descontar los ingredientes del inventario
    for (final info in ingredientesDeReceta) {
      // **CORRECCIÓN 2: Realizar la resta usando double y convertir el resultado de nuevo a int**
      final double stockActualDouble = info.ingrediente.cantidad.toDouble();
      final double nuevoStockDouble = stockActualDouble - info.cantidadNecesaria;
      
      // Convertir el resultado a entero (int) antes de escribirlo en la DB, 
      // usando .round() si permites decimales en el inventario, o .toInt() si solo manejas unidades enteras. 
      // Como tu columna es INT, usaremos .round() para manejar decimales en la resta.
      final int nuevoStock = nuevoStockDouble.round(); // O .toInt() si no quieres redondear

      // Actualizar la cantidad del ingrediente en la tabla 'Ingredientes'
      await (update(ingredientes)..where((t) => t.id.equals(info.ingrediente.id)))
          .write(IngredientesCompanion(
            // El error de tipo está aquí (línea 218)
            cantidad: Value(nuevoStock),
          ));
    }
  });
}

  
} 