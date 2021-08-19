import '../../builder/Type.dart';
import '../../builder/creator/FieldCreator.dart';
import '../../builder/creator/ModelCreator.dart';

class CAppVersionInfo extends ModelCreator {

  @override
  List<FieldCreator> get fields {
    return <FieldCreator>[
      NormalField(fieldName: 'saved_version', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING),
    ];
  }
}
