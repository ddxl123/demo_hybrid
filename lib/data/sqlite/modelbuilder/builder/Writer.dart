// ignore_for_file: non_constant_identifier_names

import 'dart:io';


import 'Member.dart';
import 'ModelList.dart';
import 'Util.dart';
import 'content/ModelBaseContent.dart';
import 'content/ModelContent.dart';
import 'content/ModelListContent.dart';
import 'content/ModelManagerContent.dart';
import 'content/ParseIntoSqlsContent.dart';

class Writer {
  Writer({
    required this.outModelFolderPath,
  }) {
    writer();
  }

  /// 要输出的文件夹的 [绝对路径]。
  String outModelFolderPath;

  /// 主函数所在文件夹下的绝对路径。
  String get mainFolderPath => (Platform.script.pathSegments.toList()..removeLast()).join('/') + '/';

  String get outModelListPath => mainFolderPath + 'builder/ModelList.dart';

  Future<void> writer() async {
    await setModelPath();
    await runWriteModelList();
    await runWriteModels();
    await runWriteModelBase();
    await runWriteModelManager();
    await runParseIntoSqls();
  }

  Future<void> setModelPath() async {
    // ignore: avoid_slow_async_io
    if (await Directory(outModelFolderPath).exists()) {
      throw '文件夹已存在！';
    } else {
      await Directory(outModelFolderPath).create();
    }
  }

  Future<void> runWriteModelList() async {
    // 写入对象。
    await File(outModelListPath).writeAsString(ModelListContent().content());
    print('ModelList file is created successfully!');
    // 创建写入的对象来执行任务。
    ModelList();
  }

  Future<void> runWriteModels() async {
    for (int i = 0; i < modelFields.length; i++) {
      final String tableName = modelFields.keys.elementAt(i);
      final Map<String, List<Object>> fields = modelFields[tableName]!;

      // 注意加上前缀 'M'。
      await File('$outModelFolderPath/M${toCamelCase(tableName)}.dart')
          .writeAsString(ModelContent(folderPath: outModelFolderPath, tableName: tableName, fields: fields).content());
      print("Named '$tableName''s model file is created successfully!");
    }
  }

  Future<void> runWriteModelBase() async {
    await File('$outModelFolderPath/ModelBase.dart').writeAsString(ModelBaseContent(folderPath: outModelFolderPath).content());
    print("'ModelBase' file is created successfully!");
  }

  Future<void> runWriteModelManager() async {
    await File('$outModelFolderPath/ModelManager.dart').writeAsString(ModelManagerContent(folderPath: outModelFolderPath).content());
    print("'ModelManager' file is created successfully!");
  }

  Future<void> runParseIntoSqls() async {
    final Map<String, String> rawSqls = <String, String>{};
    modelFields.forEach(
      (String tableName, Map<String, List<String>> fieldTypes) {
        String rawFieldsSql = ''; // 最终: "CREATE TABLE table_name (username TEXT UNIQUE,password TEXT,),"
        fieldTypes.forEach(
          (String fieldName, List<String> fieldTypes) {
            String rawFieldSql = fieldName;
            final List<String> newFieldTypes = fieldTypes.sublist(0, fieldTypes.length - 1);
            for (final String fieldType in newFieldTypes) {
              rawFieldSql += ' ' + fieldType; // 形成 "username TEXT UNIQUE,"
            }
            rawFieldsSql += '$rawFieldSql,'; // 形成 "username TEXT UNIQUE,password TEXT,"
          },
        );
        rawFieldsSql = rawFieldsSql.replaceAll(RegExp(r',$'), ''); // 去掉结尾逗号
        rawSqls.addAll(
            <String, String>{tableName: 'CREATE TABLE $tableName ($rawFieldsSql)'}); // 形成 "CREATE TABLE table_name (username TEXT UNIQUE,password TEXT,),"
      },
    );

    await File('$outModelFolderPath/ParseIntoSqls.dart').writeAsString(ParseIntoSqlsContent(rawSqls: rawSqls).parseIntoSqlsContent());
    print("'ParseIntoSqls' file is created successfully!");
  }
}
