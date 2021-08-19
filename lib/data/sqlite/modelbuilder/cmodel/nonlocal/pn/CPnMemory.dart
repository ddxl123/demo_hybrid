

import 'package:hybrid/data/sqlite/modelbuilder/builder/Type.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/FieldCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ForeignKeyCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ModelCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/cmodel/nonlocal/f/CFRule.dart';

class CPnMemory extends ModelCreator {
  @override
  List<FieldCreator> get fields => <FieldCreator>[
        ForeignKeyAiidField(fieldName: 'rule_aiid', foreignKey: ForeignKeyCreator(CFRule(), false)),
        ForeignKeyUuidField(fieldName: 'rule_uuid', foreignKey: ForeignKeyCreator(CFRule(), false)),
        NormalField(fieldName: 'title', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 20
        NormalField(fieldName: 'easy_position', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 50
      ];
}
