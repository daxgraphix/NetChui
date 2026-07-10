// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHistoryEntryCollection on Isar {
  IsarCollection<HistoryEntry> get historyEntrys => this.collection();
}

const HistoryEntrySchema = CollectionSchema(
  name: r'HistoryEntry',
  id: 2196274019059455532,
  properties: {
    r'connectionType': PropertySchema(
      id: 0,
      name: r'connectionType',
      type: IsarType.string,
    ),
    r'countryCode': PropertySchema(
      id: 1,
      name: r'countryCode',
      type: IsarType.string,
    ),
    r'downloadMbps': PropertySchema(
      id: 2,
      name: r'downloadMbps',
      type: IsarType.double,
    ),
    r'downloadPingMs': PropertySchema(
      id: 3,
      name: r'downloadPingMs',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'isp': PropertySchema(
      id: 5,
      name: r'isp',
      type: IsarType.string,
    ),
    r'jitterMs': PropertySchema(
      id: 6,
      name: r'jitterMs',
      type: IsarType.double,
    ),
    r'locationHint': PropertySchema(
      id: 7,
      name: r'locationHint',
      type: IsarType.string,
    ),
    r'pingMaxMs': PropertySchema(
      id: 8,
      name: r'pingMaxMs',
      type: IsarType.double,
    ),
    r'pingMinMs': PropertySchema(
      id: 9,
      name: r'pingMinMs',
      type: IsarType.double,
    ),
    r'pingMs': PropertySchema(
      id: 10,
      name: r'pingMs',
      type: IsarType.double,
    ),
    r'publicIp': PropertySchema(
      id: 11,
      name: r'publicIp',
      type: IsarType.string,
    ),
    r'serverId': PropertySchema(
      id: 12,
      name: r'serverId',
      type: IsarType.string,
    ),
    r'testMode': PropertySchema(
      id: 13,
      name: r'testMode',
      type: IsarType.byte,
      enumMap: _HistoryEntrytestModeEnumValueMap,
    ),
    r'testSizeName': PropertySchema(
      id: 14,
      name: r'testSizeName',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 15,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'uploadMbps': PropertySchema(
      id: 16,
      name: r'uploadMbps',
      type: IsarType.double,
    ),
    r'uploadPingMs': PropertySchema(
      id: 17,
      name: r'uploadPingMs',
      type: IsarType.double,
    )
  },
  estimateSize: _historyEntryEstimateSize,
  serialize: _historyEntrySerialize,
  deserialize: _historyEntryDeserialize,
  deserializeProp: _historyEntryDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _historyEntryGetId,
  getLinks: _historyEntryGetLinks,
  attach: _historyEntryAttach,
  version: '3.1.0+1',
);

int _historyEntryEstimateSize(
  HistoryEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.connectionType.length * 3;
  {
    final value = object.countryCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.isp;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.locationHint;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.publicIp;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.serverId.length * 3;
  bytesCount += 3 + object.testSizeName.length * 3;
  return bytesCount;
}

void _historyEntrySerialize(
  HistoryEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.connectionType);
  writer.writeString(offsets[1], object.countryCode);
  writer.writeDouble(offsets[2], object.downloadMbps);
  writer.writeDouble(offsets[3], object.downloadPingMs);
  writer.writeString(offsets[4], object.id);
  writer.writeString(offsets[5], object.isp);
  writer.writeDouble(offsets[6], object.jitterMs);
  writer.writeString(offsets[7], object.locationHint);
  writer.writeDouble(offsets[8], object.pingMaxMs);
  writer.writeDouble(offsets[9], object.pingMinMs);
  writer.writeDouble(offsets[10], object.pingMs);
  writer.writeString(offsets[11], object.publicIp);
  writer.writeString(offsets[12], object.serverId);
  writer.writeByte(offsets[13], object.testMode.index);
  writer.writeString(offsets[14], object.testSizeName);
  writer.writeDateTime(offsets[15], object.timestamp);
  writer.writeDouble(offsets[16], object.uploadMbps);
  writer.writeDouble(offsets[17], object.uploadPingMs);
}

HistoryEntry _historyEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HistoryEntry();
  object.connectionType = reader.readString(offsets[0]);
  object.countryCode = reader.readStringOrNull(offsets[1]);
  object.downloadMbps = reader.readDoubleOrNull(offsets[2]);
  object.downloadPingMs = reader.readDoubleOrNull(offsets[3]);
  object.id = reader.readString(offsets[4]);
  object.isarId = id;
  object.isp = reader.readStringOrNull(offsets[5]);
  object.jitterMs = reader.readDoubleOrNull(offsets[6]);
  object.locationHint = reader.readStringOrNull(offsets[7]);
  object.pingMaxMs = reader.readDoubleOrNull(offsets[8]);
  object.pingMinMs = reader.readDoubleOrNull(offsets[9]);
  object.pingMs = reader.readDoubleOrNull(offsets[10]);
  object.publicIp = reader.readStringOrNull(offsets[11]);
  object.serverId = reader.readString(offsets[12]);
  object.testMode =
      _HistoryEntrytestModeValueEnumMap[reader.readByteOrNull(offsets[13])] ??
          TestMode.full;
  object.testSizeName = reader.readString(offsets[14]);
  object.timestamp = reader.readDateTime(offsets[15]);
  object.uploadMbps = reader.readDoubleOrNull(offsets[16]);
  object.uploadPingMs = reader.readDoubleOrNull(offsets[17]);
  return object;
}

P _historyEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (_HistoryEntrytestModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TestMode.full) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    case 16:
      return (reader.readDoubleOrNull(offset)) as P;
    case 17:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _HistoryEntrytestModeEnumValueMap = {
  'full': 0,
  'pingOnly': 1,
  'downloadOnly': 2,
  'uploadOnly': 3,
};
const _HistoryEntrytestModeValueEnumMap = {
  0: TestMode.full,
  1: TestMode.pingOnly,
  2: TestMode.downloadOnly,
  3: TestMode.uploadOnly,
};

Id _historyEntryGetId(HistoryEntry object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _historyEntryGetLinks(HistoryEntry object) {
  return [];
}

void _historyEntryAttach(
    IsarCollection<dynamic> col, Id id, HistoryEntry object) {
  object.isarId = id;
}

extension HistoryEntryQueryWhereSort
    on QueryBuilder<HistoryEntry, HistoryEntry, QWhere> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HistoryEntryQueryWhere
    on QueryBuilder<HistoryEntry, HistoryEntry, QWhereClause> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HistoryEntryQueryFilter
    on QueryBuilder<HistoryEntry, HistoryEntry, QFilterCondition> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'connectionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'connectionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'connectionType',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      connectionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'connectionType',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'countryCode',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'countryCode',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'countryCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'countryCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'countryCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'countryCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'countryCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'countryCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'countryCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryCode',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      countryCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'countryCode',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadMbpsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloadMbps',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadMbpsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloadMbps',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadMbpsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadMbps',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadMbpsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadMbps',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadMbpsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadMbps',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadMbpsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadMbps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadPingMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloadPingMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadPingMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloadPingMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadPingMsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadPingMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadPingMsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadPingMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadPingMsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadPingMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      downloadPingMsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadPingMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> isarIdEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      isarIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      isarIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> isarIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> ispIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isp',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      ispIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isp',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> ispEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      ispGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> ispLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> ispBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> ispStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> ispEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> ispContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> ispMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isp',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> ispIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isp',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      ispIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isp',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      jitterMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jitterMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      jitterMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jitterMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      jitterMsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jitterMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      jitterMsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jitterMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      jitterMsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jitterMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      jitterMsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jitterMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'locationHint',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'locationHint',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locationHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locationHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locationHint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'locationHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'locationHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'locationHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'locationHint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationHint',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      locationHintIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'locationHint',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMaxMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pingMaxMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMaxMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pingMaxMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMaxMsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pingMaxMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMaxMsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pingMaxMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMaxMsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pingMaxMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMaxMsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pingMaxMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMinMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pingMinMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMinMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pingMinMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMinMsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pingMinMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMinMsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pingMinMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMinMsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pingMinMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMinMsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pingMinMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pingMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pingMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> pingMsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pingMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pingMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      pingMsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pingMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> pingMsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pingMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'publicIp',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'publicIp',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publicIp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'publicIp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'publicIp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'publicIp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'publicIp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'publicIp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'publicIp',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'publicIp',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publicIp',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      publicIpIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'publicIp',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      serverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serverId',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testModeEqualTo(TestMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'testMode',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testModeGreaterThan(
    TestMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'testMode',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testModeLessThan(
    TestMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'testMode',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testModeBetween(
    TestMode lower,
    TestMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'testMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'testSizeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'testSizeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'testSizeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'testSizeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'testSizeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'testSizeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'testSizeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'testSizeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'testSizeName',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      testSizeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'testSizeName',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadMbpsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'uploadMbps',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadMbpsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'uploadMbps',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadMbpsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uploadMbps',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadMbpsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uploadMbps',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadMbpsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uploadMbps',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadMbpsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uploadMbps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadPingMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'uploadPingMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadPingMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'uploadPingMs',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadPingMsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uploadPingMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadPingMsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uploadPingMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadPingMsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uploadPingMs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      uploadPingMsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uploadPingMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension HistoryEntryQueryObject
    on QueryBuilder<HistoryEntry, HistoryEntry, QFilterCondition> {}

extension HistoryEntryQueryLinks
    on QueryBuilder<HistoryEntry, HistoryEntry, QFilterCondition> {}

extension HistoryEntryQuerySortBy
    on QueryBuilder<HistoryEntry, HistoryEntry, QSortBy> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByConnectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByConnectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByCountryCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCode', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByCountryCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCode', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByDownloadMbps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadMbps', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByDownloadMbpsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadMbps', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByDownloadPingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadPingMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByDownloadPingMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadPingMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByIsp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isp', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByIspDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isp', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByJitterMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jitterMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByJitterMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jitterMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByLocationHint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationHint', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByLocationHintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationHint', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByPingMaxMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMaxMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByPingMaxMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMaxMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByPingMinMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMinMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByPingMinMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMinMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByPingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByPingMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByPublicIp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicIp', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByPublicIpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicIp', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTestMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testMode', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTestModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testMode', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTestSizeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testSizeName', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByTestSizeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testSizeName', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByUploadMbps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadMbps', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByUploadMbpsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadMbps', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByUploadPingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadPingMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByUploadPingMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadPingMs', Sort.desc);
    });
  }
}

extension HistoryEntryQuerySortThenBy
    on QueryBuilder<HistoryEntry, HistoryEntry, QSortThenBy> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByConnectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByConnectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByCountryCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCode', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByCountryCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCode', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByDownloadMbps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadMbps', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByDownloadMbpsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadMbps', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByDownloadPingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadPingMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByDownloadPingMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadPingMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByIsp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isp', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByIspDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isp', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByJitterMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jitterMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByJitterMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jitterMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByLocationHint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationHint', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByLocationHintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationHint', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByPingMaxMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMaxMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByPingMaxMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMaxMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByPingMinMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMinMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByPingMinMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMinMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByPingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByPingMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pingMs', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByPublicIp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicIp', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByPublicIpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicIp', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTestMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testMode', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTestModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testMode', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTestSizeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testSizeName', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByTestSizeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'testSizeName', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByUploadMbps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadMbps', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByUploadMbpsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadMbps', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByUploadPingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadPingMs', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByUploadPingMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadPingMs', Sort.desc);
    });
  }
}

extension HistoryEntryQueryWhereDistinct
    on QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> {
  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByConnectionType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'connectionType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByCountryCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByDownloadMbps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadMbps');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct>
      distinctByDownloadPingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadPingMs');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByIsp(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isp', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByJitterMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jitterMs');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByLocationHint(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationHint', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByPingMaxMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pingMaxMs');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByPingMinMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pingMinMs');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByPingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pingMs');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByPublicIp(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publicIp', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByServerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByTestMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'testMode');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByTestSizeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'testSizeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByUploadMbps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uploadMbps');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByUploadPingMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uploadPingMs');
    });
  }
}

extension HistoryEntryQueryProperty
    on QueryBuilder<HistoryEntry, HistoryEntry, QQueryProperty> {
  QueryBuilder<HistoryEntry, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<HistoryEntry, String, QQueryOperations>
      connectionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'connectionType');
    });
  }

  QueryBuilder<HistoryEntry, String?, QQueryOperations> countryCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryCode');
    });
  }

  QueryBuilder<HistoryEntry, double?, QQueryOperations> downloadMbpsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadMbps');
    });
  }

  QueryBuilder<HistoryEntry, double?, QQueryOperations>
      downloadPingMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadPingMs');
    });
  }

  QueryBuilder<HistoryEntry, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HistoryEntry, String?, QQueryOperations> ispProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isp');
    });
  }

  QueryBuilder<HistoryEntry, double?, QQueryOperations> jitterMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jitterMs');
    });
  }

  QueryBuilder<HistoryEntry, String?, QQueryOperations> locationHintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationHint');
    });
  }

  QueryBuilder<HistoryEntry, double?, QQueryOperations> pingMaxMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pingMaxMs');
    });
  }

  QueryBuilder<HistoryEntry, double?, QQueryOperations> pingMinMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pingMinMs');
    });
  }

  QueryBuilder<HistoryEntry, double?, QQueryOperations> pingMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pingMs');
    });
  }

  QueryBuilder<HistoryEntry, String?, QQueryOperations> publicIpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publicIp');
    });
  }

  QueryBuilder<HistoryEntry, String, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<HistoryEntry, TestMode, QQueryOperations> testModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'testMode');
    });
  }

  QueryBuilder<HistoryEntry, String, QQueryOperations> testSizeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'testSizeName');
    });
  }

  QueryBuilder<HistoryEntry, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<HistoryEntry, double?, QQueryOperations> uploadMbpsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uploadMbps');
    });
  }

  QueryBuilder<HistoryEntry, double?, QQueryOperations> uploadPingMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uploadPingMs');
    });
  }
}
