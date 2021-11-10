import 'package:hybrid/data/mysql/httpstore/handler/HttpHandler.dart';
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
    required Future<HS> resultHttpStoreJson2HS(Map<String, Object?> resultJson),
  }) async {
    final SingleResult<Map<String, Object?>> executeResult = await DataTransferManager.instance.transfer.execute<Map<String, Object?>, Map<String, Object?>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.HTTP_CURD,
      setOperationData: () => <String, Object?>{
        'putHttpStore': httpStore.toJson(),
        'sameNotConcurrent': sameNotConcurrent,
        'isBanAllOtherRequest': isBanAllOtherRequest,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object httpStoreJsonResult) => (httpStoreJsonResult as Map<Object?, Object?>).cast<String, Object?>(),
    );
    return await executeResult.handle<HS>(
      doSuccess: (Map<String, Object?> successResult) async {
        return await resultHttpStoreJson2HS(successResult);
      },
      doError: (SingleResult<Map<String, Object?>> errorResult) async {
        return await resultHttpStoreJson2HS(
          <String, Object?>{
            'httpHandler': HttpHandler.error(
              vm: errorResult.getRequiredVm(),
              descp: errorResult.getRequiredDescp(),
              e: errorResult.getRequiredE(),
              st: errorResult.stackTrace,
            ).toJson(),
          },
        );
      },
    );
  }
}
