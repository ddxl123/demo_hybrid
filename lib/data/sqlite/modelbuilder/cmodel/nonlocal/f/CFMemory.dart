

import 'package:hybrid/data/sqlite/modelbuilder/builder/Type.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/FieldCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ForeignKeyCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ModelCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/cmodel/nonlocal/pn/CPnMemory.dart';

import 'CFFragment.dart';
import 'CFRule.dart';

class CFMemory extends ModelCreator {
  @override
  List<FieldCreator> get fields => <FieldCreator>[
        ForeignKeyAiidField(fieldName: 'node_aiid', foreignKey: ForeignKeyCreator(CPnMemory(), true)),
        ForeignKeyUuidField(fieldName: 'node_uuid', foreignKey: ForeignKeyCreator(CPnMemory(), true)),
        ForeignKeyAiidField(fieldName: 'fragment_aiid', foreignKey: ForeignKeyCreator(CFFragment(), true)),
        ForeignKeyUuidField(fieldName: 'fragment_uuid', foreignKey: ForeignKeyCreator(CFFragment(), true)),
        ForeignKeyAiidField(fieldName: 'rule_aiid', foreignKey: ForeignKeyCreator(CFRule(), false)),
        ForeignKeyUuidField(fieldName: 'rule_uuid', foreignKey: ForeignKeyCreator(CFRule(), false)),
        NormalField(fieldName: 'title', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 20
      ];
  @override
  bool get isLocal => false;
}
