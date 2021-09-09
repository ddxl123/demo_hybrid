import '../Member.dart';
import '../Type.dart';
import 'FieldCreator.dart';

abstract class ModelCreator {
  ModelCreator() {
    modelFields.addAll(
      <String, Map<String, List<String>>>{
        currentTableName: <String, List<String>>{
          ...() {
            final Map<String, List<String>> fieldsMap = <String, List<String>>{};
            for (final FieldCreator field in defaultFields) {
              fieldsMap.addAll(setField(field));
            }

            for (final FieldCreator field in fields) {
              fieldsMap.addAll(setField(field));
            }

            return fieldsMap;
          }(),
        },
      },
    );
    modelType.addAll(<String, bool>{currentTableName: isLocal});
  }

  String get currentTableName {
    // 获取模型创建类名。
    final String className = runtimeType.toString();
    // 去掉前缀 'C' 。
    final String noC = className.substring(1, className.length);
    // 替换成下划线格式。
    final String fina = noC.replaceAllMapped(
      RegExp('[A-Z]'),
      (Match match) {
        return '_' + match.group(0)!.toLowerCase();
      },
    );
    // 去掉多余的前缀下划线。
    return fina.substring(1, fina.length);
  }

  bool get isLocal;

  List<FieldCreator> get fields;

  List<FieldCreator> get defaultFields {
    return <FieldCreator>[
      AnyField(
        fieldName: 'id',
        dartType: DartType.INT,
        sqliteFieldTypes: <String>[
          SqliteType.INTEGER,
          SqliteType.PRIMARY_KEY,
          SqliteType.AUTOINCREMENT,
        ],
        foreignKey: null,
      ),
      AnyField(
        fieldName: 'aiid',
        dartType: DartType.INT,
        sqliteFieldTypes: <String>[SqliteType.INTEGER],
        foreignKey: null,
      ),
      AnyField(
        fieldName: 'uuid',
        dartType: DartType.STRING,
        sqliteFieldTypes: <String>[SqliteType.TEXT],
        foreignKey: null,
      ),
      AnyField(
        fieldName: 'created_at',
        dartType: DartType.INT,
        sqliteFieldTypes: <String>[SqliteType.INTEGER],
        foreignKey: null,
      ),
      AnyField(
        fieldName: 'updated_at',
        dartType: DartType.INT,
        sqliteFieldTypes: <String>[SqliteType.INTEGER],
        foreignKey: null,
      ),
    ];
  }

  /// 设置单个字段
  Map<String, List<String>> setField(FieldCreator field) {
    // 如果存在外键，则执行外键相关操作。
    if (field.foreignKey != null) {
      toSetBelongsTo(field);
      toSetMany(field);
      toSetDelete(field);
    }

    return toSetFieldType(field);
  }

  /// 设置字段名和对应的 sqlite 类型、dart 类型
  Map<String, List<String>> toSetFieldType(FieldCreator field) {
    return <String, List<String>>{
      field.fieldName: <String>[...field.sqliteTypes, field.dartType]
    };
  }

  /// 设置当前表外键的指向。
  /// 能进到这个函数必然代表着该字段为外键字段，因为 [foreignKey] 不为空。
  void toSetBelongsTo(FieldCreator field) {
    Map<String, Map<String, String>> foreignKeyBelongsToObj;
    if (field.foreignKey!.isTwo) {
      foreignKeyBelongsToObj = foreignKeyBelongsToForTwo;
    } else {
      foreignKeyBelongsToObj = foreignKeyBelongsToForSingle;
    }

    if (!foreignKeyBelongsToObj.containsKey(currentTableName)) {
      foreignKeyBelongsToObj.addAll(
        <String, Map<String, String>>{currentTableName: <String, String>{}},
      );
    }
    if (!foreignKeyBelongsToObj[currentTableName]!.containsKey(field.fieldNameNoSuffix)) {
      foreignKeyBelongsToObj[currentTableName]!.addAll(
        <String, String>{
          field.fieldNameNoSuffix: field.foreignKey!.tableName,
        },
      );
    }
  }

  /// 如果该字段为外键字段时，让该键所关联的外表字段接收该指向。
  /// 能进到这个函数必然代表着该字段为外键字段，因为 [foreignKey] 不为空。
  void toSetMany(FieldCreator field) {
    Map<String, Set<String>> foreignKeyHaveManyObj;
    if (field.foreignKey!.isTwo) {
      foreignKeyHaveManyObj = foreignKeyHaveManyForTwo;
    } else {
      foreignKeyHaveManyObj = foreignKeyHaveManyForSingle;
    }

    if (!foreignKeyHaveManyObj.containsKey(field.foreignKey!.tableName)) {
      foreignKeyHaveManyObj.addAll(
        <String, Set<String>>{
          field.foreignKey!.tableName: <String>{},
        },
      );
    }
    if (!foreignKeyHaveManyObj[field.foreignKey!.tableName]!.contains('$currentTableName.${field.fieldNameNoSuffix}')) {
      foreignKeyHaveManyObj[field.foreignKey!.tableName]!.add(
        '$currentTableName.${field.fieldNameNoSuffix}',
      );
    }
  }

  /// 设置当前表被删除时，需要同时被删除的外表 row。
  /// 能进到这个函数必然代表着该字段为外键字段，因为 [foreignKey] 不为空。
  void toSetDelete(FieldCreator field) {
    if (!field.foreignKey!.isDeleteFollowForeignKey) {
      return;
    }
    Map<String, Set<String>> deleteObj;
    if (field.foreignKey!.isTwo) {
      deleteObj = deleteManyForTwo;
    } else {
      deleteObj = deleteManyForSingle;
    }

    if (!deleteObj.containsKey(field.foreignKey!.tableName)) {
      deleteObj.addAll(
        <String, Set<String>>{
          field.foreignKey!.tableName: <String>{},
        },
      );
    }
    if (!deleteObj[field.foreignKey!.tableName]!.contains('$currentTableName.${field.fieldNameNoSuffix}')) {
      deleteObj[field.foreignKey!.tableName]!.add('$currentTableName.${field.fieldNameNoSuffix}');
    }
  }
}
