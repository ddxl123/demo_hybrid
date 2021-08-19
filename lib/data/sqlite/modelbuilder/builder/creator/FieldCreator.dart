import '../Type.dart';
import 'ForeignKeyCreator.dart';

/// [foreignKey] 该字段所指向的外表字段。
///   - 必须为以下可能：
///     - 完全匹配该字段：id/aiid/uuid
///     - 后缀匹配该字段：_id/_aiid/_uuid
/// [isDeleteFollowForeignKey]：删除外键对应的 row 后是否需要同时删除当前 row。
abstract class FieldCreator {
  FieldCreator({
    required this.fieldName,
    required this.dartType,
    required this.sqliteTypes,
    required this.foreignKey,
  }) {
    /// 外键名规范检查。以及识别外键是 aiid/uuid 还是 id。
    if (foreignKey != null) {
      // 外键名必然是 _aiid/_uuid/_id 后缀。
      // 外键名不能让他固定成使用外键对应的表字段，因为会存在A表有多个外键关联相同外表。
      // 外键所指向的外表字段名必然是 aiid/uuid/id。

      if (fieldName.endsWith('_aiid') || fieldName.endsWith('_uuid')) {
        // 去掉外键名的后缀（_aiid/_uuid）
        fieldNameNoSuffix = fieldName.substring(0, fieldName.length - 5);
        foreignKey!.isTwo = true;
      } else if (fieldName.endsWith('_id')) {
        // 去掉外键名的后缀（_id）
        fieldNameNoSuffix = fieldName.substring(0, fieldName.length - 3);
        foreignKey!.isTwo = false;
      } else {
        throw '外键名或外键所指向的外表字段名不符合规范！';
      }
    }
  }

  String fieldName;
  String dartType;
  List<String> sqliteTypes;
  ForeignKeyCreator? foreignKey;
  String fieldNameNoSuffix = '';
}

class AnyField extends FieldCreator {
  AnyField({
    required String fieldName,
    required String dartType,
    required List<String> sqliteFieldTypes,
    required ForeignKeyCreator? foreignKey,
  }) : super(
          fieldName: fieldName,
          sqliteTypes: sqliteFieldTypes,
          dartType: dartType,
          foreignKey: foreignKey,
        );
}

class NormalField extends FieldCreator {
  NormalField({
    required String fieldName,
    required List<String> sqliteTypes,
    required String dartType,
  }) : super(
          fieldName: fieldName,
          sqliteTypes: sqliteTypes,
          dartType: dartType,
          foreignKey: null,
        );
}

class ForeignKeyAiidField extends FieldCreator {
  ForeignKeyAiidField({
    required String fieldName,
    required ForeignKeyCreator? foreignKey,
  }) : super(
          fieldName: fieldName,
          sqliteTypes: <String>[SqliteType.INTEGER],
          dartType: DartType.INT,
          foreignKey: foreignKey,
        );
}

class ForeignKeyUuidField extends FieldCreator {
  ForeignKeyUuidField({
    required String fieldName,
    required ForeignKeyCreator? foreignKey,
  }) : super(
          fieldName: fieldName,
          sqliteTypes: <String>[SqliteType.TEXT],
          dartType: DartType.STRING,
          foreignKey: foreignKey,
        );
}

class AnyInteger extends FieldCreator {
  AnyInteger({
    required String fieldName,
    required ForeignKeyCreator? foreignKey,
  }) : super(
          fieldName: fieldName,
          sqliteTypes: <String>[SqliteType.INTEGER],
          dartType: DartType.INT,
          foreignKey: foreignKey,
        );
}

class AnyText extends FieldCreator {
  AnyText({
    required String fieldName,
    required ForeignKeyCreator? foreignKey,
  }) : super(
          fieldName: fieldName,
          sqliteTypes: <String>[SqliteType.TEXT],
          dartType: DartType.STRING,
          foreignKey: foreignKey,
        );
}
