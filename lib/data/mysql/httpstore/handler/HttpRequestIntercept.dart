import 'package:hybrid/data/mysql/constant/PathConstant.dart';
import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
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
      final SingleResult<List<MUser>> usersResult = await SqliteCurd.queryRowsAsModels<MUser>(connectTransaction: null, tableName: MUser().tableName);
      if (usersResult.hasError) {
        throw '查询 user 数据时发生了异常！';
      }
      httpRequest.requestHeaders = <String, Object?>{
        'authorization': 'bearer ' + (usersResult.result!.isEmpty ? '' : (usersResult.result!.first.get_token ?? ''))
      };
    } else if (must == PathConstant.NO_JWT) {
    } else {
      throw 'Path is irregular! "${httpRequest.path}"';
    }
  }
}
