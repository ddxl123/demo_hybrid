import 'package:hybrid/data/mysql/httpstore/handler/HttpHandler.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';

import '../TransferManager.dart';

class HttpCurdTransferExecutor {
  ///

  /// 传入的 [httpStore] 与返回的对象 是同一个对象。
  Future<HS> sendRequest<HS extends HttpStore>({
    required HS httpStore,
    required String? sameNotConcurrent,
    bool isBanAllOtherRequest = false,
  }) async {
    final SingleResult<Map<String, Object?>> executeResult = await TransferManager.instance.transferExecutor.executeWithViewAndOperation(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.HTTP_CURD,
      startEngineWhenClose: false,
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
        final HttpStore_Any any = HttpStore_Any.fromJson(successData);
        httpStore.httpResponse.resetAll(any.httpResponse);
        httpStore.httpHandler.resetAll(any.httpHandler);
        return httpStore;
      },
      doError: (SingleResult<Map<String, Object?>> errorResult) async {
        httpStore.httpHandler.resetAll(HttpHandler.fromJson(errorResult.toJson()));
        return httpStore;
      },
    );
  }
}
