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

}
