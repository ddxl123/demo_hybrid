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
      final SingleResult<List<MUser>> queryResult = await DataTransferManager.instance.executeSqliteCurd.queryRowsAsModels<MUser>(
        QueryWrapper(tableName: MUser().tableName),
      );
      if (!queryResult.hasError) {
        httpRequest.requestHeaders = <String, Object?>{
          'authorization': 'bearer ' + (queryResult.result!.isEmpty ? '' : (queryResult.result!.first.get_token ?? ''))
        };
      } else {
        throw '查询 user 数据时发生了异常！';
      }
    } else if (must == PathConstant.NO_JWT) {
    } else {
      throw 'Path is irregular! "${httpRequest.path}"';
    }
  }
}
