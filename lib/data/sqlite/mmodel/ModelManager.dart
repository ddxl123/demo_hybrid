    // ignore_for_file: directives_ordering
        import 'package:sqflite/sqflite.dart';
    import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
    import 'ModelBase.dart';
          import 'MAppVersionInfo.dart';
            import 'MUpload.dart';
            import 'MUser.dart';
            import 'MPnRule.dart';
            import 'MFRule.dart';
            import 'MPnComplete.dart';
            import 'MPnFragment.dart';
            import 'MFFragment.dart';
            import 'MFComplete.dart';
            import 'MPnMemory.dart';
            import 'MFMemory.dart';
      
    
    class TwoId {
  TwoId({
    required String uuidKey,
    required String aiidKey,
    required String? uuidValue,
    required int? aiidValue,
  }) {
    if (aiidValue != null && uuidValue == null) {
      whereByTwoId = '$aiidKey = ?';
      whereArgsByTwoId = <Object>[aiidValue];
    } else if (aiidValue == null && uuidValue != null) {
      whereByTwoId = '$uuidKey = ?';
      whereArgsByTwoId = <Object>[uuidValue];
    } else {
      throw 'query by aiid and uuid err';
    }
  }

  late String whereByTwoId;
  late List<Object> whereArgsByTwoId;
}
    
    class ModelManager {
          static T createEmptyModelByTableName<T extends ModelBase>(String tableName) {
      switch (tableName) {
              case 'app_version_info':
        return MAppVersionInfo() as T;
            case 'upload':
        return MUpload() as T;
            case 'user':
        return MUser() as T;
            case 'pn_rule':
        return MPnRule() as T;
            case 'f_rule':
        return MFRule() as T;
            case 'pn_complete':
        return MPnComplete() as T;
            case 'pn_fragment':
        return MPnFragment() as T;
            case 'f_fragment':
        return MFFragment() as T;
            case 'f_complete':
        return MFComplete() as T;
            case 'pn_memory':
        return MPnMemory() as T;
            case 'f_memory':
        return MFMemory() as T;
      
        default:
          throw 'unknown tableName: ' + tableName;
      }
    }
    
            /// 参数除了 connectTransaction，其他的与 db.query 相同
      static Future<List<Map<String, Object?>>> queryRowsAsJsons({
        required Transaction? connectTransaction,
        required String tableName,
        bool? distinct,
        List<String>? columns,
        String? where,
        List<Object?>? whereArgs,
        String? groupBy,
        String? having,
        String? orderBy,
        int? limit,
        int? offset,
        TwoId? byTwoId,
      }) async {
        if (connectTransaction != null) {
          return await connectTransaction.query(
            tableName,
            distinct: distinct,
            columns: columns,
            where: where ?? byTwoId?.whereByTwoId,
            whereArgs: whereArgs ?? byTwoId?.whereArgsByTwoId,
            groupBy: groupBy,
            having: having,
            orderBy: orderBy,
            limit: limit,
            offset: offset,
          );
        }
        return await db.query(
          tableName,
          distinct: distinct,
          columns: columns,
          where: where ?? byTwoId?.whereByTwoId,
          whereArgs: whereArgs ?? byTwoId?.whereArgsByTwoId,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy,
          limit: limit,
          offset: offset,
        );
      }
    
        /// [returnWhere]: 对每个 model 进行格外操作。
  static Future<List<M>> queryRowsAsModels<M extends ModelBase>({
    required Transaction? connectTransaction,
    required String tableName,
    void Function(M model)? returnWhere,
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
    TwoId? byTwoId,
  }) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(
      connectTransaction: connectTransaction,
      tableName: tableName,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      byTwoId: byTwoId,
    );

    final List<M> models = <M>[];
    for (final Map<String, Object?> row in rows) {
      final M neModel = createEmptyModelByTableName<M>(tableName);
      neModel.getRowJson.addAll(row);
      models.add(neModel);
      returnWhere?.call(neModel);
    }
    return models;
  }
    
    }
    