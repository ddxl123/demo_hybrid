import 'package:process_run/shell.dart';

Future<void> toJson() async {
  final Shell shell = Shell();

  await shell.run('''flutter pub run build_runner build --delete-conflicting-outputs''');
}

Future<void> driftWatch() async {
  final Shell shell = Shell();

  await shell.run('''flutter packages pub run build_runner watch''');
}

void main() {
  // toJson();
  driftWatch();
}
