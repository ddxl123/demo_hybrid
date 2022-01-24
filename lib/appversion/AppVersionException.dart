abstract class AppVersionException implements Exception {}

/// app 安装覆盖原来的版本后, 新版本高于旧版本, 但未对数据库结构进行改变
class AVNotChangeDbException extends AppVersionException {}

/// app 安装覆盖原来的版本后, 新版本高于旧版本, 也对数据库结构进行了改变, 但无需让用户将旧版本中未上传的数据全部上传后再对数据库结构进行覆盖
class AVChangeDbNotUpload extends AppVersionException {}

/// app 安装覆盖原来的版本后, 新版本高于旧版本, 也对数据库结构进行了改变, 但需要让用户将旧版本中未上传的数据全部上传后才能对数据库结构进行覆盖
class AVChangeDbAfterUpload extends AppVersionException {}

/// app 安装覆盖原来的版本后, 新版本低于旧版本
class AVBackException extends AppVersionException {}
