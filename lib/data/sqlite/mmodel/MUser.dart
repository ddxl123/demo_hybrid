// ignore_for_file: non_constant_identifier_names
// ignore_for_file: annotate_overrides
    import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
    import 'ModelBase.dart';
    
class MUser implements ModelBase{
  MUser();
  MUser.createModel({
          required int? id,
                required int? aiid,
                required String? uuid,
                required int? created_at,
                required int? updated_at,
                required String? username,
                required String? password,
                required String? email,
                required int? age,
                required String? token,
                required int? is_downloaded_init_data,
        
  }) {
    _rowJson.addAll(
      <String, Object?>{
                'id': id,
              'aiid': aiid,
              'uuid': uuid,
              'created_at': created_at,
              'updated_at': updated_at,
              'username': username,
              'password': password,
              'email': email,
              'age': age,
              'token': token,
              'is_downloaded_init_data': is_downloaded_init_data,
      
      },
    );
  }
  
    String get tableName => 'user';
    
      String get id => 'id';
            String get aiid => 'aiid';
            String get uuid => 'uuid';
            String get created_at => 'created_at';
            String get updated_at => 'updated_at';
            String get username => 'username';
            String get password => 'password';
            String get email => 'email';
            String get age => 'age';
            String get token => 'token';
            String get is_downloaded_init_data => 'is_downloaded_init_data';
      
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
            String? get get_username => _rowJson['username'] as String?;
            String? get get_password => _rowJson['password'] as String?;
            String? get get_email => _rowJson['email'] as String?;
            int? get get_age => _rowJson['age'] as int?;
            String? get get_token => _rowJson['token'] as String?;
            int? get get_is_downloaded_init_data => _rowJson['is_downloaded_init_data'] as int?;
      
    Set<String> getDeleteManyForTwo() => <String>{
      
    };    
    
    Set<String> getDeleteManyForSingle() => <String>{
      
    };    
    
  Future<int> insertDb() async {
    return await db.insert(tableName, _rowJson);
  }
    
}
