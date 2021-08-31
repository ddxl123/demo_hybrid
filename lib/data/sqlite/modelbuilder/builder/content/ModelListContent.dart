import 'dart:io';

class ModelListContent {
  String content() {
    return '''
    ${importContent()}
    ${modelCreatorsContent()}
    ''';
  }

  String importContent() {
    return '''
    import './creator/ModelCreator.dart';
    ''';
  }

  String modelCreatorsContent() {
    // 获取 modelmain.dart 所在的文件夹的绝对 path。
    final String modelbuilderPath = (Platform.script.pathSegments.toList()..removeLast()).join('/');

    // 获取 model 文件夹绝对 path。
    final String modelPath = modelbuilderPath + '/cmodel';

    // 自定义的标准绝对 model path。
    final String standardModelPath = Uri(path: modelPath).pathSegments.join('/');

    // 获取 model 文件中的全绝对 path，会格外包含有子文件的文件夹的这个'文件夹'的路径。
    final List<FileSystemEntity> fileSystemEntities = Directory.fromUri(Uri(path: modelPath)).listSync(recursive: true);

    // 相对 [ModelList.dart] 文件的 model.dart 文件路径。
    final List<String> importPaths = <String>[];

    // 例子: AA() --- 去掉了前缀 'C'。
    final List<String> classObj = <String>[];

    for (final FileSystemEntity fileSystemEntity in fileSystemEntities) {
      final String last = fileSystemEntity.uri.pathSegments.last;
      if (last != '') {
        // 自定义的标准 .dart 文件的绝对 path。
        final String standardFilePath = Uri(path: fileSystemEntity.uri.path).pathSegments.join('/');
        // 相对 model 的 .dart 文件的 path，(不含 'model')。
        final String importPathForModel = standardFilePath.substring(standardModelPath.length, standardFilePath.length);
        // 相对 [ModelList.dart] 文件的 model 路径。
        final String importPath = '../cmodel' + importPathForModel;

        importPaths.add(importPath);
        classObj.add(last.split('.').first + '()');
      }
    }

    String importContent = '';
    for (final String ip in importPaths) {
      importContent += '''
      import '$ip';
      ''';
    }
    String classObjContent = '';
    for (final String co in classObj) {
      classObjContent += '''
      $co,
      ''';
    }

    return '''
    $importContent
    class ModelList{
      List<ModelCreator> modelCreators = <ModelCreator>[
      $classObjContent
      ];
    }
''';
  }
}
