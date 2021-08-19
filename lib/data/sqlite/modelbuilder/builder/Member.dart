/// 模型名称、字段。eg. {"table_name":{"field1":['TEXT', 'String']}}
Map<String, Map<String, List<String>>> modelFields =
    <String, Map<String, List<String>>>{};

// ===============================================================================
// ===============================================================================

/// 表的外键所指向的外表字段。
///
/// 键：表名。
///
/// 值：该表的外键字段所指向的表。
///
/// eg. { "table_name" :{ "xx" : "table_name2" }}
///
/// xx_aiid 和 xx_uuid 会合并成 xx。
///
/// 由于指向的表的 column 始终为 id/uuid/aiid ，因此无需设置 column。
Map<String, Map<String, String>> foreignKeyBelongsToForTwo =
    <String, Map<String, String>>{};

/// 表的外键所指向的外表字段。
///
/// 键：表名。
///
/// 值：该表的外键字段所指向的表以及 column。
///
/// eg. { "table_name" :{ "xx" : "table_name2" }}
///
/// xx_id 会被去掉后缀变成 xx。
///
/// 由于指向的表的 column 始终为 id/uuid/aiid ，因此无需设置 column。
Map<String, Map<String, String>> foreignKeyBelongsToForSingle =
    <String, Map<String, String>>{};

// ===============================================================================

/// 表的 aiid/uuid 被哪些外表字段指向。
///
/// 键：表名。
///
/// 值：该表的 aiid/uuid 被哪些外表字段指向。
///
/// eg. {'table_name':{'table_name2.xx'}}，
///
/// xx_aiid 和 xx_uuid 会合并成 xx，。
Map<String, Set<String>> foreignKeyHaveManyForTwo = <String, Set<String>>{};

/// 表的 id 被哪些外表字段指向。
///
/// 键：表名。
///
/// 值：该表名的 id 被哪些外表字段指向。
///
/// eg. {'table_name':{'table_name1.xx'}}，
///
/// xx_id 会被去掉后缀变成 xx。
Map<String, Set<String>> foreignKeyHaveManyForSingle = <String, Set<String>>{};

// ===============================================================================

/// 表被删除时，需要同时删除的外表 row。
///
/// 键：表名。
///
/// 值：需要同时被删除的 table.column。
///
/// eg. {'table_name':{'table_name2.xx'}}
///
/// xx_aiid 和 xx_uuid 会合并成 xx，。
Map<String, Set<String>> deleteManyForTwo = <String, Set<String>>{};

/// 表被删除时，需要同时删除的外表 row。
///
/// 键：表名。
///
/// 值：需要同时被删除的 table.column。
///
/// eg. {'table_name':{'table_name2.xx'}}
///
/// xx_id 会被去掉后缀变成 xx。
Map<String, Set<String>> deleteManyForSingle = <String, Set<String>>{};

// ===============================================================================
// ===============================================================================
