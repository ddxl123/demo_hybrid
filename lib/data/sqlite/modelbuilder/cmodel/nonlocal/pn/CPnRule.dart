

import 'package:hybrid/data/sqlite/modelbuilder/builder/Type.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/FieldCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ModelCreator.dart';

class CPnRule extends ModelCreator {
  @override
  List<FieldCreator> get fields => <FieldCreator>[
        NormalField(fieldName: 'title', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 20
        NormalField(fieldName: 'easy_position', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 50
      ];
  @override
  bool get isLocal => false;
}
