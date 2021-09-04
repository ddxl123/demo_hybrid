import 'dart:io';

void main() {
  handle(
    writeDirectory: Directory(r'D:\project\hybrid\android\app\src\main\kotlin\com\example\hybrid\engine\constant'),
    writePackage: 'com.example.hybrid.engine.constant',
  );
}

/// [writeDirectory] 要写入的文件夹路径。
///
/// [writePackage] 要写入的项目包名。
void handle({required Directory writeDirectory, required String writePackage}) {
  // 读取的文件夹路径。
  final String readFilePath = (Platform.script.pathSegments.toList()..removeLast()).join('/');

  final List<FileSystemEntity> readFiles = Directory(readFilePath).listSync();

  if (writeDirectory.existsSync()) {
    throw Exception('constant 文件夹已存在！请手动删除！');
  }
  Directory.fromUri(writeDirectory.uri).createSync();

  for (final FileSystemEntity file in readFiles) {
    // 读取文件名。
    final String readFileName = file.uri.pathSegments.last.split('.dart').first;

    // 读取文件内容。
    final String readFileContent = File.fromUri(file.uri).readAsStringSync();

    if (readFileName == 'EngineEntryName') {
      // 读取的常量名。
      final List<String> readConstantContent = readFileContent.split('\'')..removeWhere((String element) => element.contains(RegExp('=|{|}|;')));

      // 写入的常量内容。
      String writeConstantContext = '';
      for (final String it in readConstantContent) {
        writeConstantContext += '    const val $it: String = "$it"\n';
      }

      // 写入的完整内容。
      final String writeFileContent = '''
package $writePackage

object $readFileName {
$writeConstantContext}
''';

      // 将完整内容写入到的文件。
      final String writePath = writeDirectory.path + '/$readFileName.kt';

      if (File.fromUri(Uri.file(writePath)).existsSync()) {
        throw Exception('$readFileName 文件已存在！请手动删除！');
      } else {
        File.fromUri(Uri.file(writePath)).writeAsStringSync(writeFileContent);
      }
    }

    //
    else if (readFileName == 'generate_native') {
    }

    //
    else {
      final List<String> readConstantContent = readFileContent.split('{');

      // send 类名。
      final String sendClass = readConstantContent[0].split('class').last.trim();

      // send 常量。
      final List<String> sendConstantList = readConstantContent[1].split('\'')..removeWhere((String element) => element.contains(RegExp('=|;|}')));

      // send 常量内容。
      String sendConstantContent = '';
      for (final String it in sendConstantList) {
        sendConstantContent += '    const val ${it.toUpperCase()}: String = "$it"\n';
      }

      // listen 类名。
      final String listenClass = readConstantContent[1].split('class').last.trim();

      // listen 常量。
      final List<String> listenConstantList = readConstantContent[2].split('\'')..removeWhere((String element) => element.contains(RegExp('=|;|}')));

      // listen 常量内容。
      String listenConstantContent = '';
      for (final String it in listenConstantList) {
        listenConstantContent += '    const val $it: String = "$it"\n';
      }

      // 写入的完整内容。
      final String writeFileContent = '''
package $writePackage

object $sendClass {
$sendConstantContent}

object $listenClass {
$listenConstantContent}      
''';

      // 将完整内容写入到的文件。
      final String writePath = writeDirectory.path + '/$readFileName.kt';

      if (File.fromUri(Uri.file(writePath)).existsSync()) {
        throw Exception('$readFileName 文件已存在！请手动删除！');
      } else {
        File.fromUri(Uri.file(writePath)).writeAsStringSync(writeFileContent);
      }
    }
  }

  print('生成成功！');
}
