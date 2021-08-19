

import 'package:hybrid/data/sqlite/modelbuilder/builder/Type.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/FieldCreator.dart';
import 'package:hybrid/data/sqlite/modelbuilder/builder/creator/ModelCreator.dart';

class CUpload extends ModelCreator {
  @override
  List<FieldCreator> get fields => <FieldCreator>[
        NormalField(fieldName: 'for_table_name', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING),
        NormalField(fieldName: 'for_row_id', sqliteTypes: <String>[SqliteType.INTEGER], dartType: DartType.INT),
        NormalField(fieldName: 'for_aiid', sqliteTypes: <String>[SqliteType.INTEGER], dartType: DartType.INT),
        NormalField(fieldName: 'updated_columns', sqliteTypes: <String>[SqliteType.TEXT], dartType: DartType.STRING),
        NormalField(fieldName: 'curd_status', sqliteTypes: <String>[SqliteType.INTEGER], dartType: DartType.INT),
        NormalField(fieldName: 'upload_status', sqliteTypes: <String>[SqliteType.INTEGER], dartType: DartType.INT),
        NormalField(fieldName: 'mark', sqliteTypes: <String>[SqliteType.INTEGER], dartType: DartType.INT),
      ];
}
