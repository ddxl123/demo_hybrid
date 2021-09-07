    // ignore_for_file: non_constant_identifier_names
  abstract class ModelBase {
  String get tableName;

  String get id;

  String get aiid;

  String get uuid;

  String get created_at;

  String get updated_at;

  Map<String, Object?> get getRowJson;
  
  set setRowJson(Map<String,Object?> json);

  int? get get_id;

  int? get get_aiid;

  String? get get_uuid;

  int? get get_created_at;

  int? get get_updated_at;
  
  Set<String> getDeleteManyForTwo();

  Set<String> getDeleteManyForSingle();
  }
    