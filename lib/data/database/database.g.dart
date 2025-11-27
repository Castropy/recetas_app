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
  static const VerificationMeta _costoUnitarioMeta =
      const VerificationMeta('costoUnitario');
  @override
  late final GeneratedColumn<double> costoUnitario = GeneratedColumn<double>(
      'costo_unitario', aliasedName, false,
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
      [id, nombre, cantidad, costoUnitario, fechaCreacion];
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
    if (data.containsKey('costo_unitario')) {
      context.handle(
          _costoUnitarioMeta,
          costoUnitario.isAcceptableOrUnknown(
              data['costo_unitario']!, _costoUnitarioMeta));
    } else if (isInserting) {
      context.missing(_costoUnitarioMeta);
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
      costoUnitario: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}costo_unitario'])!,
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
  final double costoUnitario;
  final DateTime fechaCreacion;
  const Ingrediente(
      {required this.id,
      required this.nombre,
      required this.cantidad,
      required this.costoUnitario,
      required this.fechaCreacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['cantidad'] = Variable<int>(cantidad);
    map['costo_unitario'] = Variable<double>(costoUnitario);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    return map;
  }

  IngredientesCompanion toCompanion(bool nullToAbsent) {
    return IngredientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      cantidad: Value(cantidad),
      costoUnitario: Value(costoUnitario),
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
      costoUnitario: serializer.fromJson<double>(json['costoUnitario']),
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
      'costoUnitario': serializer.toJson<double>(costoUnitario),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
    };
  }

  Ingrediente copyWith(
          {int? id,
          String? nombre,
          int? cantidad,
          double? costoUnitario,
          DateTime? fechaCreacion}) =>
      Ingrediente(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        cantidad: cantidad ?? this.cantidad,
        costoUnitario: costoUnitario ?? this.costoUnitario,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      );
  Ingrediente copyWithCompanion(IngredientesCompanion data) {
    return Ingrediente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      costoUnitario: data.costoUnitario.present
          ? data.costoUnitario.value
          : this.costoUnitario,
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
          ..write('costoUnitario: $costoUnitario, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, cantidad, costoUnitario, fechaCreacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingrediente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.cantidad == this.cantidad &&
          other.costoUnitario == this.costoUnitario &&
          other.fechaCreacion == this.fechaCreacion);
}

class IngredientesCompanion extends UpdateCompanion<Ingrediente> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> cantidad;
  final Value<double> costoUnitario;
  final Value<DateTime> fechaCreacion;
  const IngredientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.costoUnitario = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });
  IngredientesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int cantidad,
    required double costoUnitario,
    this.fechaCreacion = const Value.absent(),
  })  : nombre = Value(nombre),
        cantidad = Value(cantidad),
        costoUnitario = Value(costoUnitario);
  static Insertable<Ingrediente> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? cantidad,
    Expression<double>? costoUnitario,
    Expression<DateTime>? fechaCreacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (cantidad != null) 'cantidad': cantidad,
      if (costoUnitario != null) 'costo_unitario': costoUnitario,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
    });
  }

  IngredientesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<int>? cantidad,
      Value<double>? costoUnitario,
      Value<DateTime>? fechaCreacion}) {
    return IngredientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      costoUnitario: costoUnitario ?? this.costoUnitario,
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
    if (costoUnitario.present) {
      map['costo_unitario'] = Variable<double>(costoUnitario.value);
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
          ..write('costoUnitario: $costoUnitario, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }
}

class $RecetasTable extends Recetas with TableInfo<$RecetasTable, Receta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecetasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _costoTotalMeta =
      const VerificationMeta('costoTotal');
  @override
  late final GeneratedColumn<double> costoTotal = GeneratedColumn<double>(
      'costo_total', aliasedName, false,
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
  List<GeneratedColumn> get $columns => [id, nombre, costoTotal, fechaCreacion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recetas';
  @override
  VerificationContext validateIntegrity(Insertable<Receta> instance,
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
    if (data.containsKey('costo_total')) {
      context.handle(
          _costoTotalMeta,
          costoTotal.isAcceptableOrUnknown(
              data['costo_total']!, _costoTotalMeta));
    } else if (isInserting) {
      context.missing(_costoTotalMeta);
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
  Receta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receta(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      costoTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}costo_total'])!,
      fechaCreacion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_creacion'])!,
    );
  }

  @override
  $RecetasTable createAlias(String alias) {
    return $RecetasTable(attachedDatabase, alias);
  }
}

class Receta extends DataClass implements Insertable<Receta> {
  final int id;
  final String nombre;
  final double costoTotal;
  final DateTime fechaCreacion;
  const Receta(
      {required this.id,
      required this.nombre,
      required this.costoTotal,
      required this.fechaCreacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['costo_total'] = Variable<double>(costoTotal);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    return map;
  }

  RecetasCompanion toCompanion(bool nullToAbsent) {
    return RecetasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      costoTotal: Value(costoTotal),
      fechaCreacion: Value(fechaCreacion),
    );
  }

  factory Receta.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receta(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      costoTotal: serializer.fromJson<double>(json['costoTotal']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'costoTotal': serializer.toJson<double>(costoTotal),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
    };
  }

  Receta copyWith(
          {int? id,
          String? nombre,
          double? costoTotal,
          DateTime? fechaCreacion}) =>
      Receta(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        costoTotal: costoTotal ?? this.costoTotal,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      );
  Receta copyWithCompanion(RecetasCompanion data) {
    return Receta(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      costoTotal:
          data.costoTotal.present ? data.costoTotal.value : this.costoTotal,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receta(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('costoTotal: $costoTotal, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, costoTotal, fechaCreacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receta &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.costoTotal == this.costoTotal &&
          other.fechaCreacion == this.fechaCreacion);
}

class RecetasCompanion extends UpdateCompanion<Receta> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<double> costoTotal;
  final Value<DateTime> fechaCreacion;
  const RecetasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.costoTotal = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
  });
  RecetasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required double costoTotal,
    this.fechaCreacion = const Value.absent(),
  })  : nombre = Value(nombre),
        costoTotal = Value(costoTotal);
  static Insertable<Receta> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<double>? costoTotal,
    Expression<DateTime>? fechaCreacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (costoTotal != null) 'costo_total': costoTotal,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
    });
  }

  RecetasCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<double>? costoTotal,
      Value<DateTime>? fechaCreacion}) {
    return RecetasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      costoTotal: costoTotal ?? this.costoTotal,
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
    if (costoTotal.present) {
      map['costo_total'] = Variable<double>(costoTotal.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecetasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('costoTotal: $costoTotal, ')
          ..write('fechaCreacion: $fechaCreacion')
          ..write(')'))
        .toString();
  }
}

class $RecetaIngredientesTable extends RecetaIngredientes
    with TableInfo<$RecetaIngredientesTable, RecetaIngrediente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecetaIngredientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recetaIdMeta =
      const VerificationMeta('recetaId');
  @override
  late final GeneratedColumn<int> recetaId = GeneratedColumn<int>(
      'receta_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES recetas (id)'));
  static const VerificationMeta _ingredienteIdMeta =
      const VerificationMeta('ingredienteId');
  @override
  late final GeneratedColumn<int> ingredienteId = GeneratedColumn<int>(
      'ingrediente_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES ingredientes (id)'));
  static const VerificationMeta _cantidadNecesariaMeta =
      const VerificationMeta('cantidadNecesaria');
  @override
  late final GeneratedColumn<double> cantidadNecesaria =
      GeneratedColumn<double>('cantidad_necesaria', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [recetaId, ingredienteId, cantidadNecesaria];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receta_ingredientes';
  @override
  VerificationContext validateIntegrity(Insertable<RecetaIngrediente> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('receta_id')) {
      context.handle(_recetaIdMeta,
          recetaId.isAcceptableOrUnknown(data['receta_id']!, _recetaIdMeta));
    } else if (isInserting) {
      context.missing(_recetaIdMeta);
    }
    if (data.containsKey('ingrediente_id')) {
      context.handle(
          _ingredienteIdMeta,
          ingredienteId.isAcceptableOrUnknown(
              data['ingrediente_id']!, _ingredienteIdMeta));
    } else if (isInserting) {
      context.missing(_ingredienteIdMeta);
    }
    if (data.containsKey('cantidad_necesaria')) {
      context.handle(
          _cantidadNecesariaMeta,
          cantidadNecesaria.isAcceptableOrUnknown(
              data['cantidad_necesaria']!, _cantidadNecesariaMeta));
    } else if (isInserting) {
      context.missing(_cantidadNecesariaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recetaId, ingredienteId};
  @override
  RecetaIngrediente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecetaIngrediente(
      recetaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}receta_id'])!,
      ingredienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingrediente_id'])!,
      cantidadNecesaria: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}cantidad_necesaria'])!,
    );
  }

  @override
  $RecetaIngredientesTable createAlias(String alias) {
    return $RecetaIngredientesTable(attachedDatabase, alias);
  }
}

class RecetaIngrediente extends DataClass
    implements Insertable<RecetaIngrediente> {
  final int recetaId;
  final int ingredienteId;
  final double cantidadNecesaria;
  const RecetaIngrediente(
      {required this.recetaId,
      required this.ingredienteId,
      required this.cantidadNecesaria});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['receta_id'] = Variable<int>(recetaId);
    map['ingrediente_id'] = Variable<int>(ingredienteId);
    map['cantidad_necesaria'] = Variable<double>(cantidadNecesaria);
    return map;
  }

  RecetaIngredientesCompanion toCompanion(bool nullToAbsent) {
    return RecetaIngredientesCompanion(
      recetaId: Value(recetaId),
      ingredienteId: Value(ingredienteId),
      cantidadNecesaria: Value(cantidadNecesaria),
    );
  }

  factory RecetaIngrediente.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecetaIngrediente(
      recetaId: serializer.fromJson<int>(json['recetaId']),
      ingredienteId: serializer.fromJson<int>(json['ingredienteId']),
      cantidadNecesaria: serializer.fromJson<double>(json['cantidadNecesaria']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recetaId': serializer.toJson<int>(recetaId),
      'ingredienteId': serializer.toJson<int>(ingredienteId),
      'cantidadNecesaria': serializer.toJson<double>(cantidadNecesaria),
    };
  }

  RecetaIngrediente copyWith(
          {int? recetaId, int? ingredienteId, double? cantidadNecesaria}) =>
      RecetaIngrediente(
        recetaId: recetaId ?? this.recetaId,
        ingredienteId: ingredienteId ?? this.ingredienteId,
        cantidadNecesaria: cantidadNecesaria ?? this.cantidadNecesaria,
      );
  RecetaIngrediente copyWithCompanion(RecetaIngredientesCompanion data) {
    return RecetaIngrediente(
      recetaId: data.recetaId.present ? data.recetaId.value : this.recetaId,
      ingredienteId: data.ingredienteId.present
          ? data.ingredienteId.value
          : this.ingredienteId,
      cantidadNecesaria: data.cantidadNecesaria.present
          ? data.cantidadNecesaria.value
          : this.cantidadNecesaria,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecetaIngrediente(')
          ..write('recetaId: $recetaId, ')
          ..write('ingredienteId: $ingredienteId, ')
          ..write('cantidadNecesaria: $cantidadNecesaria')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recetaId, ingredienteId, cantidadNecesaria);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecetaIngrediente &&
          other.recetaId == this.recetaId &&
          other.ingredienteId == this.ingredienteId &&
          other.cantidadNecesaria == this.cantidadNecesaria);
}

class RecetaIngredientesCompanion extends UpdateCompanion<RecetaIngrediente> {
  final Value<int> recetaId;
  final Value<int> ingredienteId;
  final Value<double> cantidadNecesaria;
  final Value<int> rowid;
  const RecetaIngredientesCompanion({
    this.recetaId = const Value.absent(),
    this.ingredienteId = const Value.absent(),
    this.cantidadNecesaria = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecetaIngredientesCompanion.insert({
    required int recetaId,
    required int ingredienteId,
    required double cantidadNecesaria,
    this.rowid = const Value.absent(),
  })  : recetaId = Value(recetaId),
        ingredienteId = Value(ingredienteId),
        cantidadNecesaria = Value(cantidadNecesaria);
  static Insertable<RecetaIngrediente> custom({
    Expression<int>? recetaId,
    Expression<int>? ingredienteId,
    Expression<double>? cantidadNecesaria,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recetaId != null) 'receta_id': recetaId,
      if (ingredienteId != null) 'ingrediente_id': ingredienteId,
      if (cantidadNecesaria != null) 'cantidad_necesaria': cantidadNecesaria,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecetaIngredientesCompanion copyWith(
      {Value<int>? recetaId,
      Value<int>? ingredienteId,
      Value<double>? cantidadNecesaria,
      Value<int>? rowid}) {
    return RecetaIngredientesCompanion(
      recetaId: recetaId ?? this.recetaId,
      ingredienteId: ingredienteId ?? this.ingredienteId,
      cantidadNecesaria: cantidadNecesaria ?? this.cantidadNecesaria,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recetaId.present) {
      map['receta_id'] = Variable<int>(recetaId.value);
    }
    if (ingredienteId.present) {
      map['ingrediente_id'] = Variable<int>(ingredienteId.value);
    }
    if (cantidadNecesaria.present) {
      map['cantidad_necesaria'] = Variable<double>(cantidadNecesaria.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecetaIngredientesCompanion(')
          ..write('recetaId: $recetaId, ')
          ..write('ingredienteId: $ingredienteId, ')
          ..write('cantidadNecesaria: $cantidadNecesaria, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransaccionesTable extends Transacciones
    with TableInfo<$TransaccionesTable, Transaccione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransaccionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fechaHoraMeta =
      const VerificationMeta('fechaHora');
  @override
  late final GeneratedColumn<DateTime> fechaHora = GeneratedColumn<DateTime>(
      'fecha_hora', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entidadMeta =
      const VerificationMeta('entidad');
  @override
  late final GeneratedColumn<String> entidad = GeneratedColumn<String>(
      'entidad', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entidadIdMeta =
      const VerificationMeta('entidadId');
  @override
  late final GeneratedColumn<int> entidadId = GeneratedColumn<int>(
      'entidad_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _detallesMeta =
      const VerificationMeta('detalles');
  @override
  late final GeneratedColumn<String> detalles = GeneratedColumn<String>(
      'detalles', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fechaHora, tipo, entidad, entidadId, detalles];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transacciones';
  @override
  VerificationContext validateIntegrity(Insertable<Transaccione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha_hora')) {
      context.handle(_fechaHoraMeta,
          fechaHora.isAcceptableOrUnknown(data['fecha_hora']!, _fechaHoraMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('entidad')) {
      context.handle(_entidadMeta,
          entidad.isAcceptableOrUnknown(data['entidad']!, _entidadMeta));
    } else if (isInserting) {
      context.missing(_entidadMeta);
    }
    if (data.containsKey('entidad_id')) {
      context.handle(_entidadIdMeta,
          entidadId.isAcceptableOrUnknown(data['entidad_id']!, _entidadIdMeta));
    }
    if (data.containsKey('detalles')) {
      context.handle(_detallesMeta,
          detalles.isAcceptableOrUnknown(data['detalles']!, _detallesMeta));
    } else if (isInserting) {
      context.missing(_detallesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaccione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaccione(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fechaHora: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_hora'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      entidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidad'])!,
      entidadId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entidad_id']),
      detalles: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}detalles'])!,
    );
  }

  @override
  $TransaccionesTable createAlias(String alias) {
    return $TransaccionesTable(attachedDatabase, alias);
  }
}

class Transaccione extends DataClass implements Insertable<Transaccione> {
  final int id;
  final DateTime fechaHora;
  final String tipo;
  final String entidad;
  final int? entidadId;
  final String detalles;
  const Transaccione(
      {required this.id,
      required this.fechaHora,
      required this.tipo,
      required this.entidad,
      this.entidadId,
      required this.detalles});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha_hora'] = Variable<DateTime>(fechaHora);
    map['tipo'] = Variable<String>(tipo);
    map['entidad'] = Variable<String>(entidad);
    if (!nullToAbsent || entidadId != null) {
      map['entidad_id'] = Variable<int>(entidadId);
    }
    map['detalles'] = Variable<String>(detalles);
    return map;
  }

  TransaccionesCompanion toCompanion(bool nullToAbsent) {
    return TransaccionesCompanion(
      id: Value(id),
      fechaHora: Value(fechaHora),
      tipo: Value(tipo),
      entidad: Value(entidad),
      entidadId: entidadId == null && nullToAbsent
          ? const Value.absent()
          : Value(entidadId),
      detalles: Value(detalles),
    );
  }

  factory Transaccione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaccione(
      id: serializer.fromJson<int>(json['id']),
      fechaHora: serializer.fromJson<DateTime>(json['fechaHora']),
      tipo: serializer.fromJson<String>(json['tipo']),
      entidad: serializer.fromJson<String>(json['entidad']),
      entidadId: serializer.fromJson<int?>(json['entidadId']),
      detalles: serializer.fromJson<String>(json['detalles']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fechaHora': serializer.toJson<DateTime>(fechaHora),
      'tipo': serializer.toJson<String>(tipo),
      'entidad': serializer.toJson<String>(entidad),
      'entidadId': serializer.toJson<int?>(entidadId),
      'detalles': serializer.toJson<String>(detalles),
    };
  }

  Transaccione copyWith(
          {int? id,
          DateTime? fechaHora,
          String? tipo,
          String? entidad,
          Value<int?> entidadId = const Value.absent(),
          String? detalles}) =>
      Transaccione(
        id: id ?? this.id,
        fechaHora: fechaHora ?? this.fechaHora,
        tipo: tipo ?? this.tipo,
        entidad: entidad ?? this.entidad,
        entidadId: entidadId.present ? entidadId.value : this.entidadId,
        detalles: detalles ?? this.detalles,
      );
  Transaccione copyWithCompanion(TransaccionesCompanion data) {
    return Transaccione(
      id: data.id.present ? data.id.value : this.id,
      fechaHora: data.fechaHora.present ? data.fechaHora.value : this.fechaHora,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      entidad: data.entidad.present ? data.entidad.value : this.entidad,
      entidadId: data.entidadId.present ? data.entidadId.value : this.entidadId,
      detalles: data.detalles.present ? data.detalles.value : this.detalles,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaccione(')
          ..write('id: $id, ')
          ..write('fechaHora: $fechaHora, ')
          ..write('tipo: $tipo, ')
          ..write('entidad: $entidad, ')
          ..write('entidadId: $entidadId, ')
          ..write('detalles: $detalles')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fechaHora, tipo, entidad, entidadId, detalles);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaccione &&
          other.id == this.id &&
          other.fechaHora == this.fechaHora &&
          other.tipo == this.tipo &&
          other.entidad == this.entidad &&
          other.entidadId == this.entidadId &&
          other.detalles == this.detalles);
}

class TransaccionesCompanion extends UpdateCompanion<Transaccione> {
  final Value<int> id;
  final Value<DateTime> fechaHora;
  final Value<String> tipo;
  final Value<String> entidad;
  final Value<int?> entidadId;
  final Value<String> detalles;
  const TransaccionesCompanion({
    this.id = const Value.absent(),
    this.fechaHora = const Value.absent(),
    this.tipo = const Value.absent(),
    this.entidad = const Value.absent(),
    this.entidadId = const Value.absent(),
    this.detalles = const Value.absent(),
  });
  TransaccionesCompanion.insert({
    this.id = const Value.absent(),
    this.fechaHora = const Value.absent(),
    required String tipo,
    required String entidad,
    this.entidadId = const Value.absent(),
    required String detalles,
  })  : tipo = Value(tipo),
        entidad = Value(entidad),
        detalles = Value(detalles);
  static Insertable<Transaccione> custom({
    Expression<int>? id,
    Expression<DateTime>? fechaHora,
    Expression<String>? tipo,
    Expression<String>? entidad,
    Expression<int>? entidadId,
    Expression<String>? detalles,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fechaHora != null) 'fecha_hora': fechaHora,
      if (tipo != null) 'tipo': tipo,
      if (entidad != null) 'entidad': entidad,
      if (entidadId != null) 'entidad_id': entidadId,
      if (detalles != null) 'detalles': detalles,
    });
  }

  TransaccionesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? fechaHora,
      Value<String>? tipo,
      Value<String>? entidad,
      Value<int?>? entidadId,
      Value<String>? detalles}) {
    return TransaccionesCompanion(
      id: id ?? this.id,
      fechaHora: fechaHora ?? this.fechaHora,
      tipo: tipo ?? this.tipo,
      entidad: entidad ?? this.entidad,
      entidadId: entidadId ?? this.entidadId,
      detalles: detalles ?? this.detalles,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fechaHora.present) {
      map['fecha_hora'] = Variable<DateTime>(fechaHora.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (entidad.present) {
      map['entidad'] = Variable<String>(entidad.value);
    }
    if (entidadId.present) {
      map['entidad_id'] = Variable<int>(entidadId.value);
    }
    if (detalles.present) {
      map['detalles'] = Variable<String>(detalles.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransaccionesCompanion(')
          ..write('id: $id, ')
          ..write('fechaHora: $fechaHora, ')
          ..write('tipo: $tipo, ')
          ..write('entidad: $entidad, ')
          ..write('entidadId: $entidadId, ')
          ..write('detalles: $detalles')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IngredientesTable ingredientes = $IngredientesTable(this);
  late final $RecetasTable recetas = $RecetasTable(this);
  late final $RecetaIngredientesTable recetaIngredientes =
      $RecetaIngredientesTable(this);
  late final $TransaccionesTable transacciones = $TransaccionesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [ingredientes, recetas, recetaIngredientes, transacciones];
}

typedef $$IngredientesTableCreateCompanionBuilder = IngredientesCompanion
    Function({
  Value<int> id,
  required String nombre,
  required int cantidad,
  required double costoUnitario,
  Value<DateTime> fechaCreacion,
});
typedef $$IngredientesTableUpdateCompanionBuilder = IngredientesCompanion
    Function({
  Value<int> id,
  Value<String> nombre,
  Value<int> cantidad,
  Value<double> costoUnitario,
  Value<DateTime> fechaCreacion,
});

final class $$IngredientesTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientesTable, Ingrediente> {
  $$IngredientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecetaIngredientesTable, List<RecetaIngrediente>>
      _recetaIngredientesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recetaIngredientes,
              aliasName: $_aliasNameGenerator(
                  db.ingredientes.id, db.recetaIngredientes.ingredienteId));

  $$RecetaIngredientesTableProcessedTableManager get recetaIngredientesRefs {
    final manager = $$RecetaIngredientesTableTableManager(
            $_db, $_db.recetaIngredientes)
        .filter((f) => f.ingredienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recetaIngredientesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

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

  ColumnFilters<double> get costoUnitario => $composableBuilder(
      column: $table.costoUnitario, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  Expression<bool> recetaIngredientesRefs(
      Expression<bool> Function($$RecetaIngredientesTableFilterComposer f) f) {
    final $$RecetaIngredientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recetaIngredientes,
        getReferencedColumn: (t) => t.ingredienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecetaIngredientesTableFilterComposer(
              $db: $db,
              $table: $db.recetaIngredientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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

  ColumnOrderings<double> get costoUnitario => $composableBuilder(
      column: $table.costoUnitario,
      builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<double> get costoUnitario => $composableBuilder(
      column: $table.costoUnitario, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  Expression<T> recetaIngredientesRefs<T extends Object>(
      Expression<T> Function($$RecetaIngredientesTableAnnotationComposer a) f) {
    final $$RecetaIngredientesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recetaIngredientes,
            getReferencedColumn: (t) => t.ingredienteId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecetaIngredientesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recetaIngredientes,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
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
    (Ingrediente, $$IngredientesTableReferences),
    Ingrediente,
    PrefetchHooks Function({bool recetaIngredientesRefs})> {
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
            Value<double> costoUnitario = const Value.absent(),
            Value<DateTime> fechaCreacion = const Value.absent(),
          }) =>
              IngredientesCompanion(
            id: id,
            nombre: nombre,
            cantidad: cantidad,
            costoUnitario: costoUnitario,
            fechaCreacion: fechaCreacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            required int cantidad,
            required double costoUnitario,
            Value<DateTime> fechaCreacion = const Value.absent(),
          }) =>
              IngredientesCompanion.insert(
            id: id,
            nombre: nombre,
            cantidad: cantidad,
            costoUnitario: costoUnitario,
            fechaCreacion: fechaCreacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IngredientesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recetaIngredientesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recetaIngredientesRefs) db.recetaIngredientes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recetaIngredientesRefs)
                    await $_getPrefetchedData<Ingrediente, $IngredientesTable,
                            RecetaIngrediente>(
                        currentTable: table,
                        referencedTable: $$IngredientesTableReferences
                            ._recetaIngredientesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IngredientesTableReferences(db, table, p0)
                                .recetaIngredientesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ingredienteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
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
    (Ingrediente, $$IngredientesTableReferences),
    Ingrediente,
    PrefetchHooks Function({bool recetaIngredientesRefs})>;
typedef $$RecetasTableCreateCompanionBuilder = RecetasCompanion Function({
  Value<int> id,
  required String nombre,
  required double costoTotal,
  Value<DateTime> fechaCreacion,
});
typedef $$RecetasTableUpdateCompanionBuilder = RecetasCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<double> costoTotal,
  Value<DateTime> fechaCreacion,
});

final class $$RecetasTableReferences
    extends BaseReferences<_$AppDatabase, $RecetasTable, Receta> {
  $$RecetasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecetaIngredientesTable, List<RecetaIngrediente>>
      _recetaIngredientesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recetaIngredientes,
              aliasName: $_aliasNameGenerator(
                  db.recetas.id, db.recetaIngredientes.recetaId));

  $$RecetaIngredientesTableProcessedTableManager get recetaIngredientesRefs {
    final manager =
        $$RecetaIngredientesTableTableManager($_db, $_db.recetaIngredientes)
            .filter((f) => f.recetaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recetaIngredientesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecetasTableFilterComposer
    extends Composer<_$AppDatabase, $RecetasTable> {
  $$RecetasTableFilterComposer({
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

  ColumnFilters<double> get costoTotal => $composableBuilder(
      column: $table.costoTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  Expression<bool> recetaIngredientesRefs(
      Expression<bool> Function($$RecetaIngredientesTableFilterComposer f) f) {
    final $$RecetaIngredientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recetaIngredientes,
        getReferencedColumn: (t) => t.recetaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecetaIngredientesTableFilterComposer(
              $db: $db,
              $table: $db.recetaIngredientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecetasTableOrderingComposer
    extends Composer<_$AppDatabase, $RecetasTable> {
  $$RecetasTableOrderingComposer({
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

  ColumnOrderings<double> get costoTotal => $composableBuilder(
      column: $table.costoTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));
}

class $$RecetasTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecetasTable> {
  $$RecetasTableAnnotationComposer({
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

  GeneratedColumn<double> get costoTotal => $composableBuilder(
      column: $table.costoTotal, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  Expression<T> recetaIngredientesRefs<T extends Object>(
      Expression<T> Function($$RecetaIngredientesTableAnnotationComposer a) f) {
    final $$RecetaIngredientesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recetaIngredientes,
            getReferencedColumn: (t) => t.recetaId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecetaIngredientesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recetaIngredientes,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RecetasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecetasTable,
    Receta,
    $$RecetasTableFilterComposer,
    $$RecetasTableOrderingComposer,
    $$RecetasTableAnnotationComposer,
    $$RecetasTableCreateCompanionBuilder,
    $$RecetasTableUpdateCompanionBuilder,
    (Receta, $$RecetasTableReferences),
    Receta,
    PrefetchHooks Function({bool recetaIngredientesRefs})> {
  $$RecetasTableTableManager(_$AppDatabase db, $RecetasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecetasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecetasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecetasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<double> costoTotal = const Value.absent(),
            Value<DateTime> fechaCreacion = const Value.absent(),
          }) =>
              RecetasCompanion(
            id: id,
            nombre: nombre,
            costoTotal: costoTotal,
            fechaCreacion: fechaCreacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            required double costoTotal,
            Value<DateTime> fechaCreacion = const Value.absent(),
          }) =>
              RecetasCompanion.insert(
            id: id,
            nombre: nombre,
            costoTotal: costoTotal,
            fechaCreacion: fechaCreacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RecetasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({recetaIngredientesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recetaIngredientesRefs) db.recetaIngredientes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recetaIngredientesRefs)
                    await $_getPrefetchedData<Receta, $RecetasTable,
                            RecetaIngrediente>(
                        currentTable: table,
                        referencedTable: $$RecetasTableReferences
                            ._recetaIngredientesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecetasTableReferences(db, table, p0)
                                .recetaIngredientesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recetaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RecetasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecetasTable,
    Receta,
    $$RecetasTableFilterComposer,
    $$RecetasTableOrderingComposer,
    $$RecetasTableAnnotationComposer,
    $$RecetasTableCreateCompanionBuilder,
    $$RecetasTableUpdateCompanionBuilder,
    (Receta, $$RecetasTableReferences),
    Receta,
    PrefetchHooks Function({bool recetaIngredientesRefs})>;
typedef $$RecetaIngredientesTableCreateCompanionBuilder
    = RecetaIngredientesCompanion Function({
  required int recetaId,
  required int ingredienteId,
  required double cantidadNecesaria,
  Value<int> rowid,
});
typedef $$RecetaIngredientesTableUpdateCompanionBuilder
    = RecetaIngredientesCompanion Function({
  Value<int> recetaId,
  Value<int> ingredienteId,
  Value<double> cantidadNecesaria,
  Value<int> rowid,
});

final class $$RecetaIngredientesTableReferences extends BaseReferences<
    _$AppDatabase, $RecetaIngredientesTable, RecetaIngrediente> {
  $$RecetaIngredientesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RecetasTable _recetaIdTable(_$AppDatabase db) =>
      db.recetas.createAlias(
          $_aliasNameGenerator(db.recetaIngredientes.recetaId, db.recetas.id));

  $$RecetasTableProcessedTableManager get recetaId {
    final $_column = $_itemColumn<int>('receta_id')!;

    final manager = $$RecetasTableTableManager($_db, $_db.recetas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recetaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IngredientesTable _ingredienteIdTable(_$AppDatabase db) =>
      db.ingredientes.createAlias($_aliasNameGenerator(
          db.recetaIngredientes.ingredienteId, db.ingredientes.id));

  $$IngredientesTableProcessedTableManager get ingredienteId {
    final $_column = $_itemColumn<int>('ingrediente_id')!;

    final manager = $$IngredientesTableTableManager($_db, $_db.ingredientes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RecetaIngredientesTableFilterComposer
    extends Composer<_$AppDatabase, $RecetaIngredientesTable> {
  $$RecetaIngredientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get cantidadNecesaria => $composableBuilder(
      column: $table.cantidadNecesaria,
      builder: (column) => ColumnFilters(column));

  $$RecetasTableFilterComposer get recetaId {
    final $$RecetasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recetaId,
        referencedTable: $db.recetas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecetasTableFilterComposer(
              $db: $db,
              $table: $db.recetas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientesTableFilterComposer get ingredienteId {
    final $$IngredientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredienteId,
        referencedTable: $db.ingredientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientesTableFilterComposer(
              $db: $db,
              $table: $db.ingredientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecetaIngredientesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecetaIngredientesTable> {
  $$RecetaIngredientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get cantidadNecesaria => $composableBuilder(
      column: $table.cantidadNecesaria,
      builder: (column) => ColumnOrderings(column));

  $$RecetasTableOrderingComposer get recetaId {
    final $$RecetasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recetaId,
        referencedTable: $db.recetas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecetasTableOrderingComposer(
              $db: $db,
              $table: $db.recetas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientesTableOrderingComposer get ingredienteId {
    final $$IngredientesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredienteId,
        referencedTable: $db.ingredientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientesTableOrderingComposer(
              $db: $db,
              $table: $db.ingredientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecetaIngredientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecetaIngredientesTable> {
  $$RecetaIngredientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get cantidadNecesaria => $composableBuilder(
      column: $table.cantidadNecesaria, builder: (column) => column);

  $$RecetasTableAnnotationComposer get recetaId {
    final $$RecetasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recetaId,
        referencedTable: $db.recetas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecetasTableAnnotationComposer(
              $db: $db,
              $table: $db.recetas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientesTableAnnotationComposer get ingredienteId {
    final $$IngredientesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredienteId,
        referencedTable: $db.ingredientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientesTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecetaIngredientesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecetaIngredientesTable,
    RecetaIngrediente,
    $$RecetaIngredientesTableFilterComposer,
    $$RecetaIngredientesTableOrderingComposer,
    $$RecetaIngredientesTableAnnotationComposer,
    $$RecetaIngredientesTableCreateCompanionBuilder,
    $$RecetaIngredientesTableUpdateCompanionBuilder,
    (RecetaIngrediente, $$RecetaIngredientesTableReferences),
    RecetaIngrediente,
    PrefetchHooks Function({bool recetaId, bool ingredienteId})> {
  $$RecetaIngredientesTableTableManager(
      _$AppDatabase db, $RecetaIngredientesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecetaIngredientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecetaIngredientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecetaIngredientesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> recetaId = const Value.absent(),
            Value<int> ingredienteId = const Value.absent(),
            Value<double> cantidadNecesaria = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecetaIngredientesCompanion(
            recetaId: recetaId,
            ingredienteId: ingredienteId,
            cantidadNecesaria: cantidadNecesaria,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int recetaId,
            required int ingredienteId,
            required double cantidadNecesaria,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecetaIngredientesCompanion.insert(
            recetaId: recetaId,
            ingredienteId: ingredienteId,
            cantidadNecesaria: cantidadNecesaria,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecetaIngredientesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recetaId = false, ingredienteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (recetaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recetaId,
                    referencedTable:
                        $$RecetaIngredientesTableReferences._recetaIdTable(db),
                    referencedColumn: $$RecetaIngredientesTableReferences
                        ._recetaIdTable(db)
                        .id,
                  ) as T;
                }
                if (ingredienteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ingredienteId,
                    referencedTable: $$RecetaIngredientesTableReferences
                        ._ingredienteIdTable(db),
                    referencedColumn: $$RecetaIngredientesTableReferences
                        ._ingredienteIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RecetaIngredientesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecetaIngredientesTable,
    RecetaIngrediente,
    $$RecetaIngredientesTableFilterComposer,
    $$RecetaIngredientesTableOrderingComposer,
    $$RecetaIngredientesTableAnnotationComposer,
    $$RecetaIngredientesTableCreateCompanionBuilder,
    $$RecetaIngredientesTableUpdateCompanionBuilder,
    (RecetaIngrediente, $$RecetaIngredientesTableReferences),
    RecetaIngrediente,
    PrefetchHooks Function({bool recetaId, bool ingredienteId})>;
typedef $$TransaccionesTableCreateCompanionBuilder = TransaccionesCompanion
    Function({
  Value<int> id,
  Value<DateTime> fechaHora,
  required String tipo,
  required String entidad,
  Value<int?> entidadId,
  required String detalles,
});
typedef $$TransaccionesTableUpdateCompanionBuilder = TransaccionesCompanion
    Function({
  Value<int> id,
  Value<DateTime> fechaHora,
  Value<String> tipo,
  Value<String> entidad,
  Value<int?> entidadId,
  Value<String> detalles,
});

class $$TransaccionesTableFilterComposer
    extends Composer<_$AppDatabase, $TransaccionesTable> {
  $$TransaccionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaHora => $composableBuilder(
      column: $table.fechaHora, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entidad => $composableBuilder(
      column: $table.entidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entidadId => $composableBuilder(
      column: $table.entidadId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detalles => $composableBuilder(
      column: $table.detalles, builder: (column) => ColumnFilters(column));
}

class $$TransaccionesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransaccionesTable> {
  $$TransaccionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaHora => $composableBuilder(
      column: $table.fechaHora, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entidad => $composableBuilder(
      column: $table.entidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entidadId => $composableBuilder(
      column: $table.entidadId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detalles => $composableBuilder(
      column: $table.detalles, builder: (column) => ColumnOrderings(column));
}

class $$TransaccionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransaccionesTable> {
  $$TransaccionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaHora =>
      $composableBuilder(column: $table.fechaHora, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get entidad =>
      $composableBuilder(column: $table.entidad, builder: (column) => column);

  GeneratedColumn<int> get entidadId =>
      $composableBuilder(column: $table.entidadId, builder: (column) => column);

  GeneratedColumn<String> get detalles =>
      $composableBuilder(column: $table.detalles, builder: (column) => column);
}

class $$TransaccionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransaccionesTable,
    Transaccione,
    $$TransaccionesTableFilterComposer,
    $$TransaccionesTableOrderingComposer,
    $$TransaccionesTableAnnotationComposer,
    $$TransaccionesTableCreateCompanionBuilder,
    $$TransaccionesTableUpdateCompanionBuilder,
    (
      Transaccione,
      BaseReferences<_$AppDatabase, $TransaccionesTable, Transaccione>
    ),
    Transaccione,
    PrefetchHooks Function()> {
  $$TransaccionesTableTableManager(_$AppDatabase db, $TransaccionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransaccionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransaccionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransaccionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> fechaHora = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<String> entidad = const Value.absent(),
            Value<int?> entidadId = const Value.absent(),
            Value<String> detalles = const Value.absent(),
          }) =>
              TransaccionesCompanion(
            id: id,
            fechaHora: fechaHora,
            tipo: tipo,
            entidad: entidad,
            entidadId: entidadId,
            detalles: detalles,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> fechaHora = const Value.absent(),
            required String tipo,
            required String entidad,
            Value<int?> entidadId = const Value.absent(),
            required String detalles,
          }) =>
              TransaccionesCompanion.insert(
            id: id,
            fechaHora: fechaHora,
            tipo: tipo,
            entidad: entidad,
            entidadId: entidadId,
            detalles: detalles,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransaccionesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransaccionesTable,
    Transaccione,
    $$TransaccionesTableFilterComposer,
    $$TransaccionesTableOrderingComposer,
    $$TransaccionesTableAnnotationComposer,
    $$TransaccionesTableCreateCompanionBuilder,
    $$TransaccionesTableUpdateCompanionBuilder,
    (
      Transaccione,
      BaseReferences<_$AppDatabase, $TransaccionesTable, Transaccione>
    ),
    Transaccione,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IngredientesTableTableManager get ingredientes =>
      $$IngredientesTableTableManager(_db, _db.ingredientes);
  $$RecetasTableTableManager get recetas =>
      $$RecetasTableTableManager(_db, _db.recetas);
  $$RecetaIngredientesTableTableManager get recetaIngredientes =>
      $$RecetaIngredientesTableTableManager(_db, _db.recetaIngredientes);
  $$TransaccionesTableTableManager get transacciones =>
      $$TransaccionesTableTableManager(_db, _db.transacciones);
}
