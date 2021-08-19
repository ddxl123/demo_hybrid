// ignore_for_file: non_constant_identifier_names
// ignore_for_file: annotate_overrides
    import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
    import 'ModelBase.dart';
    
class MUpload implements ModelBase{
  MUpload();
  MUpload.createModel({
          required int? id,
                required int? aiid,
                required String? uuid,
                required int? created_at,
                required int? updated_at,
                required String? for_table_name,
                required int? for_row_id,
                required int? for_aiid,
                required String? updated_columns,
                required int? curd_status,
                required int? upload_status,
                required int? mark,
        
  }) {
    _rowJson.addAll(
      <String, Object?>{
                'id': id,
              'aiid': aiid,
              'uuid': uuid,
              'created_at': created_at,
              'updated_at': updated_at,
              'for_table_name': for_table_name,
              'for_row_id': for_row_id,
              'for_aiid': for_aiid,
              'updated_columns': updated_columns,
              'curd_status': curd_status,
              'upload_status': upload_status,
              'mark': mark,
      
      },
    );
  }
  
    String get tableName => 'upload';
    
      String get id => 'id';
            String get aiid => 'aiid';
            String get uuid => 'uuid';
            String get created_at => 'created_at';
            String get updated_at => 'updated_at';
            String get for_table_name => 'for_table_name';
            String get for_row_id => 'for_row_id';
            String get for_aiid => 'for_aiid';
            String get updated_columns => 'updated_columns';
            String get curd_status => 'curd_status';
            String get upload_status => 'upload_status';
            String get mark => 'mark';
      
  final Map<String, Object?> _rowJson = <String, Object?>{};
  
  @override
  Map<String, Object?> get getRowJson => _rowJson;
    
      int? get get_id => _rowJson['id'] as int?;
            int? get get_aiid => _rowJson['aiid'] as int?;
            String? get get_uuid => _rowJson['uuid'] as String?;
            int? get get_created_at => _rowJson['created_at'] as int?;
            int? get get_updated_at => _rowJson['updated_at'] as int?;
            String? get get_for_table_name => _rowJson['for_table_name'] as String?;
            int? get get_for_row_id => _rowJson['for_row_id'] as int?;
            int? get get_for_aiid => _rowJson['for_aiid'] as int?;
            String? get get_updated_columns => _rowJson['updated_columns'] as String?;
            int? get get_curd_status => _rowJson['curd_status'] as int?;
            int? get get_upload_status => _rowJson['upload_status'] as int?;
            int? get get_mark => _rowJson['mark'] as int?;
      
    Set<String> getDeleteManyForTwo() => <String>{
      
    };    
    
    Set<String> getDeleteManyForSingle() => <String>{
      
    };    
    
  Future<int> insertDb() async {
    return await db.insert(tableName, _rowJson);
  }
    
}
