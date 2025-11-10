// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $IngredientesTable extends Ingredientes
    with TableInfo<$IngredientesTable, Ingrediente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 40),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
      'precio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>('fecha_creacion', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nombre, cantidad, precio, fechaCreacion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredientes';
  @override
  VerificationContext validateIntegrity(Insertable<Ingrediente> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(_precioMeta,
          precio.isAcceptableOrUnknown(data['precio']!, _precioMeta));
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingrediente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingrediente(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cantidad'])!,
      precio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio'])!,
      fechaCreacion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_creacion'])!,
    );
  }

  @override
  $IngredientesTable createAlias(String alias) {
    return $IngredientesTable(attachedDatabase, alias);
  }
}

class Ingrediente extends DataClass implements Insertable<Ingrediente> {
  final int id;
  final String nombre;
  final int cantidad;
  final double precio;
  final DateTime fechaCreacion;
  const Ingrediente(
      {required this.id,
      required this.nombre,
      required this.cantidad,
      required this.precio,
      required this.fechaCreacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio'] = Variable<double>(precio);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    return map;
  }

  IngredientesCompanion toCompanion(bool nullToAbsent) {
    return IngredientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      cantidad: Value(cantidad),
      precio: Value(precio),
      fechaCreacion: Value(fechaCreacion),
    );
  }

  factory Ingrediente.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingrediente(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precio: serializer.fromJson<double>(json['precio']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'cantidad': serializer.toJson<int>(cantidad),
      'precio': serializer.toJson<double>(precio),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
    };
  }

  Ingrediente copyWith(
          {int? id,
          String? nombre,
          int? cantidad,
          double? precio,
          DateTime? fechaCreacion}) =>
      Ingrediente(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        cantidad: cantidad ?? this.cantidad,
        precio: precio ?? this.precio,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      );
  Ingrediente copyWithCompanion(IngredientesCompanion data) {
    return Ingrediente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precio: data.precio.present ? data.precio.value : this.precio,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingrediente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('precio: $precio, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, cantidad, precio, fechaCreacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingrediente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.cantidad == this.cantidad &&
          other.precio == this.precio &&
          other.fechaCreacion == this.fechaCreacion);
}

class IngredientesCompanion extends UpdateCompanion<Ingrediente> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> cantidad;
  final Value<double> precio;
  final Value<DateTime> fechaCreacion;
  const IngredientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precio = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });
  IngredientesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int cantidad,
    required double precio,
    this.fechaCreacion = const Value.absent(),
  })  : nombre = Value(nombre),
        cantidad = Value(cantidad),
        precio = Value(precio);
  static Insertable<Ingrediente> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? cantidad,
    Expression<double>? precio,
    Expression<DateTime>? fechaCreacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (cantidad != null) 'cantidad': cantidad,
      if (precio != null) 'precio': precio,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
    });
  }

  IngredientesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<int>? cantidad,
      Value<double>? precio,
      Value<DateTime>? fechaCreacion}) {
    return IngredientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      precio: precio ?? this.precio,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('precio: $precio, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IngredientesTable ingredientes = $IngredientesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [ingredientes];
}

typedef $$IngredientesTableCreateCompanionBuilder = IngredientesCompanion
    Function({
  Value<int> id,
  required String nombre,
  required int cantidad,
  required double precio,
  Value<DateTime> fechaCreacion,
});
typedef $$IngredientesTableUpdateCompanionBuilder = IngredientesCompanion
    Function({
  Value<int> id,
  Value<String> nombre,
  Value<int> cantidad,
  Value<double> precio,
  Value<DateTime> fechaCreacion,
});

class $$IngredientesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientesTable> {
  $$IngredientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));
}

class $$IngredientesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientesTable> {
  $$IngredientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));
}

class $$IngredientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientesTable> {
  $$IngredientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);
}

class $$IngredientesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IngredientesTable,
    Ingrediente,
    $$IngredientesTableFilterComposer,
    $$IngredientesTableOrderingComposer,
    $$IngredientesTableAnnotationComposer,
    $$IngredientesTableCreateCompanionBuilder,
    $$IngredientesTableUpdateCompanionBuilder,
    (
      Ingrediente,
      BaseReferences<_$AppDatabase, $IngredientesTable, Ingrediente>
    ),
    Ingrediente,
    PrefetchHooks Function()> {
  $$IngredientesTableTableManager(_$AppDatabase db, $IngredientesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<int> cantidad = const Value.absent(),
            Value<double> precio = const Value.absent(),
            Value<DateTime> fechaCreacion = const Value.absent(),
          }) =>
              IngredientesCompanion(
            id: id,
            nombre: nombre,
            cantidad: cantidad,
            precio: precio,
            fechaCreacion: fechaCreacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            required int cantidad,
            required double precio,
            Value<DateTime> fechaCreacion = const Value.absent(),
          }) =>
              IngredientesCompanion.insert(
            id: id,
            nombre: nombre,
            cantidad: cantidad,
            precio: precio,
            fechaCreacion: fechaCreacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IngredientesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IngredientesTable,
    Ingrediente,
    $$IngredientesTableFilterComposer,
    $$IngredientesTableOrderingComposer,
    $$IngredientesTableAnnotationComposer,
    $$IngredientesTableCreateCompanionBuilder,
    $$IngredientesTableUpdateCompanionBuilder,
    (
      Ingrediente,
      BaseReferences<_$AppDatabase, $IngredientesTable, Ingrediente>
    ),
    Ingrediente,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IngredientesTableTableManager get ingredientes =>
      $$IngredientesTableTableManager(_db, _db.ingredientes);
}
