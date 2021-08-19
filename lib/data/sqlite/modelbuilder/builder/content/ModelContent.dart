import '../Member.dart';
import '../Util.dart';

class ModelContent {
  ModelContent({
    required this.folderPath,
    required this.tableName,
    required this.fields,
  });

  final String folderPath;
  final String tableName;
  final Map<String, List<Object>> fields;

  String content() {
    return '''
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: annotate_overrides
${importContent()}
class M${toCamelCase(tableName)} implements ModelBase{
${createModelContent()}
${tableNameContent()}
${fieldNamesContent()}
${rowJsonContent()}
${getContent()}
${getDeleteManyForTwoContent()}
${getDeleteManyForSingleContent()}
${insertDbContent()}
}
''';
  }

  // ============================================================================
  String importContent() {
    return '''
    import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
    import 'ModelBase.dart';
    ''';
  }

  // ============================================================================
  String tableNameContent() {
    return '''
    String get tableName => '$tableName';
    ''';
  }

  // ============================================================================
  String fieldNamesContent() {
    String all = '';
    for (int i = 0; i < fields.length; i++) {
      all += '''
      String get ${fields.keys.elementAt(i)} => '${fields.keys.elementAt(i)}';
      ''';
    }
    return all;
  }

  // ============================================================================
  String rowJsonContent() {
    return '''
  final Map<String, Object?> _rowJson = <String, Object?>{};
  
  @override
  Map<String, Object?> get getRowJson => _rowJson;
    ''';
  }

  // ============================================================================
  String getContent() {
    String all = '';
    for (int i = 0; i < fields.length; i++) {
      all += '''
      ${fields.values.elementAt(i).last}? get get_${fields.keys.elementAt(i)} => _rowJson['${fields.keys.elementAt(i)}'] as ${fields.values.elementAt(i).last}?;
      ''';
    }
    return all;
  }

  // ============================================================================
  String createModelContent() {
    String input = '';
    String out = '';

    for (int i = 0; i < fields.length; i++) {
      input += '''
        required ${fields.values.elementAt(i).last}? ${fields.keys.elementAt(i)},
        ''';
      out += '''
        '${fields.keys.elementAt(i)}': ${fields.keys.elementAt(i)},
      ''';
    }

    return '''
  M${toCamelCase(tableName)}();
  M${toCamelCase(tableName)}.createModel({
  $input
  }) {
    _rowJson.addAll(
      <String, Object?>{
        $out
      },
    );
  }
  ''';
  }

  // ============================================================================
  String getDeleteManyForTwoContent() {
    String all = '';

    if (deleteManyForTwo.containsKey(tableName)) {
      for (int i = 0; i < deleteManyForTwo[tableName]!.length; i++) {
        all += '''
        '${deleteManyForTwo[tableName]!.elementAt(i)}',
        ''';
      }
    }
    return '''
    Set<String> getDeleteManyForTwo() => <String>{
      $all
    };    
    ''';
  }

  // ============================================================================
  String getDeleteManyForSingleContent() {
    String all = '';

    if (deleteManyForSingle.containsKey(tableName)) {
      for (int i = 0; i < deleteManyForSingle[tableName]!.length; i++) {
        all += '''
        '${deleteManyForSingle[tableName]!.elementAt(i)}',
        ''';
      }
    }
    return '''
    Set<String> getDeleteManyForSingle() => <String>{
      $all
    };    
    ''';
  }

  // ============================================================================
  String insertDbContent() {
    return '''
  Future<int> insertDb() async {
    return await db.insert(tableName, _rowJson);
  }
    ''';
  }
}
