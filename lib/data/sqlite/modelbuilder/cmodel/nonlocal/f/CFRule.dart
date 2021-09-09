

import 'package:hybrid/data/sqlite/modelbuilder/builder/Type.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/FieldCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ForeignKeyCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ModelCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/cmodel/nonlocal/pn/CPnRule.dart';

class CFRule extends ModelCreator {
  @override
  List<FieldCreator> get fields => <FieldCreator>[
        ForeignKeyAiidField(fieldName: 'father_rule_aiid', foreignKey: ForeignKeyCreator(this, false)),
        ForeignKeyUuidField(fieldName: 'father_rule_uuid', foreignKey: ForeignKeyCreator(this, false)),
        ForeignKeyAiidField(fieldName: 'node_aiid', foreignKey: ForeignKeyCreator(CPnRule(), true)),
        ForeignKeyUuidField(fieldName: 'node_uuid', foreignKey: ForeignKeyCreator(CPnRule(), true)),
        NormalField(fieldName: 'title', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 20
      ];

  @override
  bool get isLocal => false;
}
