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
    final SingleResult<SingleResult<Map<String, Object?>>> executeResult =
        await DataTransferManager.instance.transferExecutor.execute<Map<String, Object?>, SingleResult<Map<String, Object?>>>(
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
      resultDataCast: (Object result) => SingleResult<Map<String, Object?>>.fromJson(
        resultJson: result.quickCast(),
        dataCast: (Object data) => data.quickCast(),
      ),
    );

    return await executeResult.handle<HS>(
      doSuccess: (SingleResult<Map<String, Object?>> successData) async {
        return await successData.handle<HS>(
          doSuccess: (Map<String, Object?> httpStoreResult) async {
            return await jsonToHS(httpStoreResult);
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
      },
      doError: (SingleResult<SingleResult<Map<String, Object?>>> errorResult) async {
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
