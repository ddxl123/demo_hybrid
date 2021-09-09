

import 'package:hybrid/data/sqlite/modelbuilder/builder/Type.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/FieldCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ForeignKeyCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ModelCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/cmodel/nonlocal/pn/CPnFragment.dart';

import 'CFRule.dart';

class CFFragment extends ModelCreator {
  @override
  List<FieldCreator> get fields => <FieldCreator>[
        ForeignKeyAiidField(fieldName: 'father_fragment_aiid', foreignKey: ForeignKeyCreator(this, false)),
        ForeignKeyUuidField(fieldName: 'father_fragment_uuid', foreignKey: ForeignKeyCreator(this, false)),
        ForeignKeyAiidField(fieldName: 'node_aiid', foreignKey: ForeignKeyCreator(CPnFragment(), true)),
        ForeignKeyUuidField(fieldName: 'node_uuid', foreignKey: ForeignKeyCreator(CPnFragment(), true)),
        ForeignKeyAiidField(fieldName: 'rule_aiid', foreignKey: ForeignKeyCreator(CFRule(), false)),
        ForeignKeyUuidField(fieldName: 'rule_uuid', foreignKey: ForeignKeyCreator(CFRule(), false)),
        NormalField(fieldName: 'title', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 20
      ];

  @override
  bool get isLocal => false;
}
