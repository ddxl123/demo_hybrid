import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';

import 'HttpRequest.dart';

class HttpRequestIntercept<REQVO extends RequestDataVO, REQPVO extends RequestParamsVO> {
  HttpRequestIntercept(this.httpRequest);

  final HttpRequest<REQVO, REQPVO> httpRequest;

  bool hasIntercept = false;

  Future<void> intercept() async {
    if (hasIntercept) {
      return;
    }
    if (httpRequest.pathType() == PathType.jwt) {
      final SingleResult<List<MUser>> queryResult = await DataTransferManager.instance.transfer.executeSqliteCurd.queryRowsAsModels<MUser>(
        QueryWrapper(tableName: MUser().tableName),
      );
      await queryResult.handle(
        doSuccess: (List<MUser> result) async {
          httpRequest.requestHeadersVO = <String, Object?>{'authorization': 'bearer ' + (result.isEmpty ? '' : (result.first.get_token ?? ''))};
        },
        doError: (Object? exception, StackTrace? stackTrace) async {
          throw '查询 user 数据时发生了异常！$exception';
        },
      );
    } else if (httpRequest.pathType() == PathType.no_jwt) {
    } else {
      throw 'unknown PathType: ${httpRequest.path}';
    }
  }
}
