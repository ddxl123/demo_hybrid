import 'package:hybrid/data/sqlite/modelbuilder/builder/Type.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/FieldCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ModelCreator.dart';

class CUser extends ModelCreator {
  @override
  List<FieldCreator> get fields => <FieldCreator>[
        NormalField(fieldName: 'username', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 20
        NormalField(fieldName: 'password', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 100
        NormalField(fieldName: 'email', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING), // 50
        NormalField(fieldName: 'age', sqliteTypes: <String>[SqliteType.INTEGER], dartType: DartType.INT),
        NormalField(fieldName: 'token', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING),
        NormalField(fieldName: 'is_downloaded_init_data', sqliteTypes: <String>[SqliteType.INTEGER], dartType: DartType.INT),
      ];

  @override
  bool get isLocal => false;
}
