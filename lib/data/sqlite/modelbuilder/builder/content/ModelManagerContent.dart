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
    class ModelManager {
      ${createEmptyModelByTableNameContent()}
      ${modelTypesContent()}
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
    import 'ModelBase.dart';
    $all
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
  String modelTypesContent() {
    String typeContent = '';
    for (int i = 0; i < modelType.length; i++) {
      typeContent += '''
      case '${modelType.keys.elementAt(i)}':
        return ${modelType.values.elementAt(i)};
      ''';
    }
    return '''
  static bool isLocal(String tableName) {
    switch (tableName) {
$typeContent
      default:
        throw 'unknown tableName: ' + tableName;
    }
  }
    ''';
  }
}
