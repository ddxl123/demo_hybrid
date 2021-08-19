import 'OpenSqlite.dart';
import 'SqliteTool.dart';

/// 诊断工具
class SqliteDiag {
  ///

  /// 检查当前 sqlite 文件表是否与当前应用表是否完全一致。
  Future<bool> isTableConsistent(Map<String, String> sqls) async {
    final List<String> sqliteTableNames = await SqliteTool().getAllTableNames();
    if (sqls.length != sqliteTableNames.length) {
      return false;
    }

    for (int i = 0; i < sqliteTableNames.length; i++) {
      final List<Map<String, Object?>> result = await db.query(
        'sqlite_master',
        columns: <String>['sql'],
        where: 'type = ? AND name = ?',
        whereArgs: <Object>['table', sqliteTableNames[i]],
      );
      if (result.isEmpty) {
        return false;
      }
      // 当前 sqlite 文件表的 sql 语句是否与当前应用 sql 完全一致。
      if (result.first['sql'] != sqls[sqliteTableNames[i]]) {
        return false;
      }
    }
    return true;
  }

  Future<bool> isTableExist(String tableName) async {
    final List<String> allTableName = await SqliteTool().getAllTableNames();
    return allTableName.contains(tableName);
  }

  ///
}
