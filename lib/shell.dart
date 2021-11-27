import 'package:process_run/shell.dart';

Future<void> main() async {
  Sheller.buildRunner();
}

class Sheller {
  static Future<void> buildRunner() async {
    final Shell shell = Shell();

    await shell.run('''flutter pub run build_runner build --delete-conflicting-outputs''');
  }
}
