enum CurdStatus { C, U, D }

enum UploadStatus { notUploaded, uploading, uploaded }

enum CheckResult {
  ok,

  /// model id 为空，非 aiid/uuid
  modelIdIsNull,

  /// model 不存在。
  modelIsNotExist,

  /// model 的 aiid/uuid 同时存在。
  modelIsTwoIdExist,

  /// model 的 aiid/uuid 都不存在。
  modelIsTwoIdNotExist,

  /// upload model 不存在。
  uploadModelIsNotExist,
}
