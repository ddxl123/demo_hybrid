import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';

class ExecuteHttpCurd {
  /// [resultJson] 需要手动转换成 [HttpStore]。
  Future<HS> sendRequest<HS extends HttpStore>({
    required HS httpStore,
    required String? sameNotConcurrent,
    bool isBanAllOtherRequest = false,
    required Future<HS> resultHttpStoreJson(Map<String, Object?> resultJson),
  }) async {
    final SingleResult<Map<String, Object?>> executeResult = await DataTransferManager.instance.transfer.execute<Map<String, Object?>, Map<String, Object?>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationIdWhenEngineOnReady: OUniform.HTTP_CURD,
      setOperationData: () => <String, Object?>{
        'putHttpStore': httpStore.toJson(),
        'sameNotConcurrent': sameNotConcurrent,
        'isBanAllOtherRequest': isBanAllOtherRequest,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => (resultData as Map<Object?, Object?>).cast<String, Object?>(),
    );
    return await executeResult.handle<HS>(
      onSuccess: (Map<String, Object?> successResult) async {
        return await resultHttpStoreJson(successResult);
      },
      onError: (Object? exception, StackTrace? stackTrace) async {
        return await resultHttpStoreJson(
          <String, Object?>{
            'exception': exception?.toString(),
            'stackTrace': stackTrace?.toString(),
          },
        );
      },
    );
  }
}
