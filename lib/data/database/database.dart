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
 

@DriftDatabase(tables: [Ingredientes, Recetas, RecetaIngredientes, Transacciones])
class AppDatabase extends _$AppDatabase { 
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 2;
  @override
MigrationStrategy get migration { // 🟢 CAMBIO CLAVE: Usar MigrationStrategy
  return MigrationStrategy(
   onCreate: (Migrator m) async { // 🟢 ¡Añade 'async' aquí!
  // El método onCreate, por convención de Drift, es asíncrono.
  // Drift se encarga de llamar a m.createAll() implícitamente,
  // pero si quieres que sea explícito (buena práctica), podrías añadir:
  await m.createAll();
},
    onUpgrade: (Migrator m, int from, int to) async {
      // Esta es la lógica que se ejecuta al pasar de una versión anterior a una nueva.
      if (from < 2) {
        // La versión anterior era 1, solo necesitamos crear la nueva tabla.
        await m.createTable(transacciones);
      }
    },
    // Otras opciones si las necesitas:
    // beforeOpen: (details) async {...} 
  );
}

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
  
  await transaction(() async {
    final int recetaId = await into(recetas).insert(receta);

    final List<RecetaIngredientesCompanion> listToInsert = [];

    for (var item in ingredientes) {
      final RecetaIngredientesCompanion updatedCompanion = item.copyWith(
        recetaId: Value(recetaId), 
      );
      listToInsert.add(updatedCompanion);
    }
    await batch((batch) {
      batch.insertAll(recetaIngredientes, listToInsert);
    });
    
    // 🟢 REGISTRO DE HISTORIAL (Creación de Receta)
    await insertTransaccion(TransaccionesCompanion.insert(
      tipo: 'Alta',
      entidad: 'Receta',
      entidadId: Value(recetaId),
      detalles: '{"nombre": "${receta.nombre.value}", "costo": ${receta.costoTotal.value}}',
    ));
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
  // 🔔 Opcional: Obtener detalles 'antes' de eliminar
  final Receta? recetaAEliminar = await (select(recetas)..where((tbl) => tbl.id.equals(recetaId))).getSingleOrNull();

  await transaction(() async {
    await (delete(recetaIngredientes)
        ..where((tbl) => tbl.recetaId.equals(recetaId)))
      .go();

    await (delete(recetas)..where((tbl) => tbl.id.equals(recetaId))).go();
    
    // 🟢 REGISTRO DE HISTORIAL (Eliminación de Receta)
    final String detallesJson = recetaAEliminar == null ? 
        'Receta no encontrada' : 
        '{"nombre": "${recetaAEliminar.nombre}", "costo": ${recetaAEliminar.costoTotal.toStringAsFixed(2)}}';

    await insertTransaccion(TransaccionesCompanion.insert(
      tipo: 'Eliminado',
      entidad: 'Receta',
      entidadId: Value(recetaId),
      detalles: detallesJson,
    ));
  });
}

// 🟢 Nuevo: Actualización transaccional de Receta y sus ingredientes
Future<void> updateRecetaTransaction(
      Receta receta, 
      List<RecetaIngredientesCompanion> nuevosIngredientes) async {
    
    // 🔔 Opcional: Obtener el estado 'antes' para el JSON de detalles
    final Receta? recetaAntes = await (select(recetas)..where((tbl) => tbl.id.equals(receta.id))).getSingleOrNull();

    await transaction(() async {
      // ... (Pasos 1, 2 y 3 de la actualización: update, delete, insert)
      await update(recetas).replace(receta); 

      await (delete(recetaIngredientes)
          ..where((tbl) => tbl.recetaId.equals(receta.id)))
        .go();

      await batch((batch) {
        batch.insertAll(recetaIngredientes, nuevosIngredientes);
      });
      
      // 🟢 REGISTRO DE HISTORIAL (Edición de Receta)
      final String detallesJson = '''{
          "antes": {"nombre": "${recetaAntes?.nombre}", "costo": ${recetaAntes?.costoTotal.toStringAsFixed(2)}},
          "despues": {"nombre": "${receta.nombre}", "costo": ${receta.costoTotal.toStringAsFixed(2)}}
      }''';

      await insertTransaccion(TransaccionesCompanion.insert(
        tipo: 'Edición',
        entidad: 'Receta',
        entidadId: Value(receta.id),
        detalles: detallesJson,
      ));
    });
  }

  Future<List<Ingrediente>> getIngredientesByIds(List<int> ids) {
  // Utilizamos la cláusula .isIn() de Drift para seleccionar todos los ingredientes
  // cuyos IDs están contenidos en la lista 'ids' proporcionada.
  return (select(ingredientes)..where((tbl) => tbl.id.isIn(ids))).get();
}

// Método de Transacción para Vender Receta
Future<void> venderRecetaTransaction(int recetaId) async {
  // 🟢 Bloque de obtención de ingredientesDeReceta DEBE estar aquí (Solución 1 de la revisión anterior)
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
  // -----------------------------------------------------------------------------------

  // Opcional: Obtener el nombre de la receta antes de la venta
  final Receta? recetaVendida = await (select(recetas)..where((tbl) => tbl.id.equals(recetaId))).getSingleOrNull();

  // 🔔 NUEVO: Lista para almacenar el consumo con los stocks finales correctos
  final List<Map<String, dynamic>> consumoFinal = []; 

  await transaction(() async {
    // 1. Condicional: Verificar Inventario (Lanza InsufficientStockException si falla)
    for (final info in ingredientesDeReceta) {
      final double stockActual = info.ingrediente.cantidad.toDouble(); 
      final double cantidadRequerida = info.cantidadNecesaria;
      if (stockActual < cantidadRequerida) {
        throw InsufficientStockException(
            info.ingrediente.nombre, cantidadRequerida, stockActual);
      }
    }

    // 2. Logica de Venta: Descontar y Construir el Historial dentro del bucle
    for (final info in ingredientesDeReceta) {
      final double stockActualDouble = info.ingrediente.cantidad.toDouble();
      final double nuevoStockDouble = stockActualDouble - info.cantidadNecesaria;
      final int nuevoStock = nuevoStockDouble.round();

      // 🟢 CLAVE: Registrar el consumo ANTES de la actualización
      consumoFinal.add({
         'ingrediente': info.ingrediente.nombre,
         'requerido': info.cantidadNecesaria,
         'stock_antes': info.ingrediente.cantidad,
         'stock_despues': nuevoStock, // Usamos el valor calculado
      });

      // Actualizar la cantidad del ingrediente en la tabla 'Ingredientes'
      await (update(ingredientes)..where((t) => t.id.equals(info.ingrediente.id)))
          .write(IngredientesCompanion(
             cantidad: Value(nuevoStock),
          ));
    }
    
    // 🟢 REGISTRO DE HISTORIAL (Venta de Receta) - Usando la lista consumoFinal
    final String detallesJson = jsonEncode({
        "receta": recetaVendida?.nombre ?? 'Desconocida',
        "costo_produccion": recetaVendida?.costoTotal.toStringAsFixed(2),
        "consumo_inventario": consumoFinal, // <--- USAMOS LA LISTA CORRECTA
    });
    
    await insertTransaccion(TransaccionesCompanion.insert(
      tipo: 'Venta',
      entidad: 'Receta',
      entidadId: Value(recetaId),
      detalles: detallesJson,
    ));
  });
}

// 1. Inserción de una Transacción
Future<int> insertTransaccion(TransaccionesCompanion transaccion) {
  return into(transacciones).insert(transaccion);
}

Stream<List<Transaccione>> watchAllTransacciones() {
  return (select(transacciones)
        ..orderBy([(t) => OrderingTerm(expression: t.fechaHora, mode: OrderingMode.desc)]))
      .watch();
      }


} 