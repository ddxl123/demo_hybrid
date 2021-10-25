import 'package:hybrid/data/mysql/constant/PathConstant.dart';
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
    final String must = httpRequest.path.split('/')[0];
    if (must == PathConstant.JWT) {
      final SingleResult<List<MUser>> queryResult = await DataTransferManager.instance.transfer.executeSqliteCurd.queryRowsAsModels<MUser>(
        QueryWrapper(tableName: MUser().tableName),
      );
      await queryResult.handle(
        onSuccess: (List<MUser> result) async {
          httpRequest.requestHeaders = <String, Object?>{'authorization': 'bearer ' + (result.isEmpty ? '' : (result.first.get_token ?? ''))};
        },
        onError: (Object? exception, StackTrace? stackTrace) async {
          throw '查询 user 数据时发生了异常！$exception';
        },
      );
    } else if (must == PathConstant.NO_JWT) {
    } else {
      throw 'Path is irregular! "${httpRequest.path}"';
    }
  }
}
