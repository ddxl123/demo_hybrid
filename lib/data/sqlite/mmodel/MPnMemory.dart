// ignore_for_file: non_constant_identifier_names
// ignore_for_file: annotate_overrides
    import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
    import 'ModelBase.dart';
    
class MPnMemory implements ModelBase{
  MPnMemory();
  MPnMemory.createModel({
          required int? id,
                required int? aiid,
                required String? uuid,
                required int? created_at,
                required int? updated_at,
                required int? rule_aiid,
                required String? rule_uuid,
                required String? title,
                required String? easy_position,
        
  }) {
    _rowJson.addAll(
      <String, Object?>{
                'id': id,
              'aiid': aiid,
              'uuid': uuid,
              'created_at': created_at,
              'updated_at': updated_at,
              'rule_aiid': rule_aiid,
              'rule_uuid': rule_uuid,
              'title': title,
              'easy_position': easy_position,
      
      },
    );
  }
  
    String get tableName => 'pn_memory';
    
      String get id => 'id';
            String get aiid => 'aiid';
            String get uuid => 'uuid';
            String get created_at => 'created_at';
            String get updated_at => 'updated_at';
            String get rule_aiid => 'rule_aiid';
            String get rule_uuid => 'rule_uuid';
            String get title => 'title';
            String get easy_position => 'easy_position';
      
  final Map<String, Object?> _rowJson = <String, Object?>{};
  
  @override
  Map<String, Object?> get getRowJson => _rowJson;
  
  @override
  set setRowJson(Map<String,Object?> json){
    _rowJson.clear();
    _rowJson.addAll(json);
  }
    
      int? get get_id => _rowJson['id'] as int?;
            int? get get_aiid => _rowJson['aiid'] as int?;
            String? get get_uuid => _rowJson['uuid'] as String?;
            int? get get_created_at => _rowJson['created_at'] as int?;
            int? get get_updated_at => _rowJson['updated_at'] as int?;
            int? get get_rule_aiid => _rowJson['rule_aiid'] as int?;
            String? get get_rule_uuid => _rowJson['rule_uuid'] as String?;
            String? get get_title => _rowJson['title'] as String?;
            String? get get_easy_position => _rowJson['easy_position'] as String?;
      
    Set<String> getDeleteManyForTwo() => <String>{
              'f_memory.node',
        
    };    
    
    Set<String> getDeleteManyForSingle() => <String>{
      
    };    
    
  Future<int> insertDb() async {
    return await db.insert(tableName, _rowJson);
  }
    
}
