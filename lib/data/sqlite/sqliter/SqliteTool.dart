
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'OpenSqlite.dart';

/// 通用工具
class SqliteTool {
  ///

  /// 获取全部的表, 不包含 android_metadata
  Future<List<String>> getAllTableNames() async {
    final List<String> tableNames = (await db.query(
      'sqlite_master',
      where: 'type = ?',
      whereArgs: <Object?>['table'],
    ))
        .map((Map<String, Object?> row) => row['name']! as String)
        .toList();
    tableNames.remove('android_metadata');
    tableNames.remove('sqlite_sequence');
    return tableNames;
  }

  /// 移除指定表。
  Future<void> dropTable(String tableName) async {
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  /// 移除全部表。
  Future<void> dropAllTable() async {
    final List<String> tablesBefore = await getAllTableNames();

    SbLogger(
      code: null,
      viewMessage: null,
      data: null,
      description: Description('移除前的表：$tablesBefore'),
      exception: null,
      stackTrace: null,
    );

    // 将存在的表全部移除。
    for (int i = 0; i < tablesBefore.length; i++) {
      await dropTable(tablesBefore[i]);
    }

    final List<String> tablesAfter = await getAllTableNames();

    SbLogger(
      code: null,
      viewMessage: null,
      data: null,
      description: Description('移除后的表：$tablesAfter'),
      exception: null,
      stackTrace: null,
    );
  }

  /// 创建全部需要的表
  Future<void> createAllTables(Map<String, String> sqls) async {
    for (int i = 0; i < sqls.length; i++) {
      await db.execute(sqls.values.elementAt(i));
    }
    final List<String> result = await SqliteTool().getAllTableNames();
    SbLogger(
      code: null,
      viewMessage: null,
      data: null,
      description: Description('创建全部需要的表完成：$result'),
      exception: null,
      stackTrace: null,
    );
  }

  /// 获取某表的全部字段名称。
  Future<List<String>> getAllFieldBy(String tableName) async {
    final List<Map<String, Object?>> result = await db.rawQuery('PRAGMA table_info($tableName)');
    final List<String> fieldNames = <String>[];
    for (int i = 0; i < result.length; i++) {
      fieldNames.add(result[i]['name']! as String);
    }
    return fieldNames;
  }
}
