

import 'package:hybrid/data/sqlite/modelbuilder/builder/Type.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/FieldCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ModelCreator.dart';

class CToken extends ModelCreator {
  @override
  List<FieldCreator> get fields => <FieldCreator>[
        NormalField(fieldName: 'token', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING),
      ];
}
