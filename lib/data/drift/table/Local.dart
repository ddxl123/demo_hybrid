import 'package:drift/drift.dart';

import 'Base.dart';

class AppVersionInfos extends TableLocalBase {
  TextColumn get savedVersion => text()();
}
