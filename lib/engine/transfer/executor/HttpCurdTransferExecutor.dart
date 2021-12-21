import 'package:hybrid/data/mysql/httpstore/handler/HttpHandler.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';

import '../TransferManager.dart';

class HttpCurdTransferExecutor {
  ///

  /// [resultJson] 需要手动转换成 [HttpStore]。
  Future<HS> sendRequest<HS extends HttpStore>({
    required HS httpStore,
    required String? sameNotConcurrent,
    bool isBanAllOtherRequest = false,
    required Future<HS> jsonToHS(Map<String, Object?> json),
  }) async {
    final SingleResult<Map<String, Object?>> executeResult = await TransferManager.instance.transferExecutor.executeWithViewAndOperation(
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
      resultDataCast: (Object resultData) => resultData.quickCast(),
    );

    return await executeResult.handle<HS>(
      doSuccess: (Map<String, Object?> successData) async {
        return await jsonToHS(successData);
      },
      doError: (SingleResult<Map<String, Object?>> errorResult) async {
        return await jsonToHS(
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
