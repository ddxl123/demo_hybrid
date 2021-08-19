import '../Member.dart';
import '../Util.dart';

class ModelManagerContent {
  ModelManagerContent({required this.folderPath});

  final String folderPath;

  // ============================================================================
  String content() {
    return '''
    // ignore_for_file: directives_ordering
    ${importContent()}
    ${twoId()}
    class ModelManager {
      ${createEmptyModelByTableNameContent()}
      ${queryRowsAsJsonsContent()}
      ${queryRowsAsModelsContent()}
    }
    ''';
  }

  String importContent() {
    String all = '';
    for (int i = 0; i < modelFields.length; i++) {
      all += '''
      import 'M${toCamelCase(modelFields.keys.elementAt(i))}.dart';
      ''';
    }
    return '''
    import 'package:sqflite/sqflite.dart';
    import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
    import 'ModelBase.dart';
    $all
    ''';
  }

  // ============================================================================
  String twoId() {
    return r'''
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
    ''';
  }

  // ============================================================================
  String createEmptyModelByTableNameContent() {
    String all = '';
    for (int i = 0; i < modelFields.length; i++) {
      all += '''
      case '${modelFields.keys.elementAt(i)}':
        return M${toCamelCase(modelFields.keys.elementAt(i))}() as T;
      ''';
    }
    return '''
    static T createEmptyModelByTableName<T extends ModelBase>(String tableName) {
      switch (tableName) {
        $all
        default:
          throw 'unknown tableName: ' + tableName;
      }
    }
    ''';
  }

  // ============================================================================
  String queryRowsAsJsonsContent() {
    return '''
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
    ''';
  }

// ============================================================================
  String queryRowsAsModelsContent() {
    return '''
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
    ''';
  }
}
