import 'dart:convert';
import 'package:drift/drift.dart';

// Importamos la base de datos y el unificador de tablas
import '../database/database.dart';
import '../tables/tables.dart'; 
import 'package:recetas_app/providers/search_notifier.dart';

part 'recetas_dao.g.dart';

@DriftAccessor(tables: [Recetas, Ingredientes, RecetaIngredientes, Transacciones])
class RecetasDao extends DatabaseAccessor<AppDatabase> with _$RecetasDaoMixin {
  RecetasDao(super.db);

  // Getter para facilitar el acceso a tablas desde el DAO
  // (Esto ayuda a resolver los errores de "Undefined name")
  $RecetasTable get recetas => db.recetas;
  $IngredientesTable get ingredientes => db.ingredientes;
  $RecetaIngredientesTable get recetaIngredientes => db.recetaIngredientes;
  $TransaccionesTable get transacciones => db.transacciones;

  Stream<List<Receta>> watchAllRecetas() => select(recetas).watch();

  Future<Map<Receta, List<RecetaIngrediente>>> getRecetaDetails(int id) async {
    final receta = await (select(recetas)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (receta == null) return {};
    
    final ingredientesList = await (select(recetaIngredientes)
      ..where((tbl) => tbl.recetaId.equals(id))
    ).get();
    
    return {receta: ingredientesList};
  }

  Future<void> saveRecetaTransaction(
      RecetasCompanion receta, 
      List<RecetaIngredientesCompanion> ingredientesItems) async {
    await transaction(() async {
      final int recetaId = await into(recetas).insert(receta);
      final List<RecetaIngredientesCompanion> listToInsert = ingredientesItems.map((item) => 
        item.copyWith(recetaId: Value(recetaId))
      ).toList();

      await batch((batch) => batch.insertAll(recetaIngredientes, listToInsert));
      
      await db.transaccionesDao.insertTransaccion(TransaccionesCompanion.insert(
        tipo: 'Alta',
        entidad: 'Receta',
        entidadId: Value(recetaId),
        detalles: '{"nombre": "${receta.nombre.value}", "costo": ${receta.costoTotal.value}}',
      ));
    });
  }

  Future<void> deleteRecetaTransaction(int recetaId) async {
    final recetaAEliminar = await (select(recetas)..where((tbl) => tbl.id.equals(recetaId))).getSingleOrNull();

    await transaction(() async {
      await (delete(recetaIngredientes)..where((tbl) => tbl.recetaId.equals(recetaId))).go();
      await (delete(recetas)..where((tbl) => tbl.id.equals(recetaId))).go();
      
      final String detallesJson = recetaAEliminar == null ? 
          'Receta no encontrada' : 
          '{"nombre": "${recetaAEliminar.nombre}", "costo": ${recetaAEliminar.costoTotal.toStringAsFixed(2)}}';

      await db.transaccionesDao.insertTransaccion(TransaccionesCompanion.insert(
        tipo: 'Eliminado',
        entidad: 'Receta',
        entidadId: Value(recetaId),
        detalles: detallesJson,
      ));
    });
  }

  Future<void> venderRecetaTransaction(int recetaId) async {
    final ingredientesDeReceta = await (select(recetaIngredientes).join([
      innerJoin(ingredientes, recetaIngredientes.ingredienteId.equalsExp(ingredientes.id))
    ])..where(recetaIngredientes.recetaId.equals(recetaId))).map((row) {
      return _RecetaVentaInfo(
        ingrediente: row.readTable(ingredientes),
        cantidadNecesaria: row.readTable(recetaIngredientes).cantidadNecesaria,
      );
    }).get();

    final recetaVendida = await (select(recetas)..where((tbl) => tbl.id.equals(recetaId))).getSingleOrNull();
    final List<Map<String, dynamic>> consumoFinal = []; 

    await transaction(() async {
      for (final info in ingredientesDeReceta) {
        if (info.ingrediente.cantidad < info.cantidadNecesaria) {
          throw InsufficientStockException(info.ingrediente.nombre, info.cantidadNecesaria, info.ingrediente.cantidad);
        }
      }

      for (final info in ingredientesDeReceta) {
        final double nuevoStock = info.ingrediente.cantidad - info.cantidadNecesaria;
        consumoFinal.add({
           'ingrediente': info.ingrediente.nombre,
           'requerido': info.cantidadNecesaria,
           'stock_antes': info.ingrediente.cantidad,
           'stock_despues': nuevoStock,
        });

        await (update(ingredientes)..where((t) => t.id.equals(info.ingrediente.id)))
            .write(IngredientesCompanion(cantidad: Value(nuevoStock)));
      }
      
      await db.transaccionesDao.insertTransaccion(TransaccionesCompanion.insert(
        tipo: 'Venta',
        entidad: 'Receta',
        entidadId: Value(recetaId),
        detalles: jsonEncode({
          "receta": recetaVendida?.nombre ?? 'Desconocida',
          "costo_produccion": recetaVendida?.costoTotal.toStringAsFixed(2),
          "consumo_inventario": consumoFinal,
        }),
      ));
    });
  }

  Future<void> updateRecetaTransaction(
      Receta receta, 
      List<RecetaIngredientesCompanion> nuevosIngredientes) async {
    
    // 🔔 Obtener el estado 'antes' para el JSON de detalles
    final Receta? recetaAntes = await (select(recetas)..where((tbl) => tbl.id.equals(receta.id))).getSingleOrNull();

    await transaction(() async {
      // 1. Actualizar los datos de la receta
      await update(recetas).replace(receta); 

      // 2. Limpiar ingredientes anteriores
      await (delete(recetaIngredientes)
          ..where((tbl) => tbl.recetaId.equals(receta.id)))
        .go();

      // 3. Insertar los nuevos ingredientes
      await batch((batch) {
        batch.insertAll(recetaIngredientes, nuevosIngredientes);
      });
      
      // 🟢 REGISTRO DE HISTORIAL (Edición de Receta)
      final String detallesJson = '''{
          "antes": {"nombre": "${recetaAntes?.nombre}", "costo": ${recetaAntes?.costoTotal.toStringAsFixed(2)}},
          "despues": {"nombre": "${receta.nombre}", "costo": ${receta.costoTotal.toStringAsFixed(2)}}
      }''';

      // Llamamos al DAO de transacciones a través de la instancia de la DB
      await db.transaccionesDao.insertTransaccion(TransaccionesCompanion.insert(
        tipo: 'Edición',
        entidad: 'Receta',
        entidadId: Value(receta.id),
        detalles: detallesJson,
      ));
    });
  }

  Stream<List<Receta>> watchAllRecetasFiltered(String query, SearchFilter filter) {
    final baseQuery = select(recetas);
    if (query.isEmpty) return baseQuery.watch();

    final normalizedQuery = '%${query.toLowerCase()}%';
    Expression<bool> whereClause;

    switch (filter) {
      case SearchFilter.nombre:
        whereClause = recetas.nombre.lower().like(normalizedQuery);
        break;
      case SearchFilter.id:
        whereClause = recetas.id.equals(int.tryParse(query) ?? -1);
        break;
      case SearchFilter.precio:
        whereClause = recetas.costoTotal.isBiggerOrEqual(Constant(double.tryParse(query) ?? -1.0));
        break;
    }
    return (baseQuery..where((_) => whereClause)).watch();
  }
}

class InsufficientStockException implements Exception {
  final String nombreIngrediente;
  final double requerido;
  final double disponible;
  InsufficientStockException(this.nombreIngrediente, this.requerido, this.disponible);
  @override
  String toString() => 'Stock insuficiente de $nombreIngrediente. Requerido: $requerido, Disponible: $disponible';
}

class _RecetaVentaInfo {
  final Ingrediente ingrediente;
  final double cantidadNecesaria;
  _RecetaVentaInfo({required this.ingrediente, required this.cantidadNecesaria});
}