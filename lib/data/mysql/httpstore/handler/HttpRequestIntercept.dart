import 'package:hybrid/data/mysql/constant/PathConstant.dart';
import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';

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
      final List<MUser> mUsers = await SqliteCurd.queryRowsAsModels(connectTransaction: null, tableName: MUser().tableName);
      httpRequest.requestHeaders = <String, Object?>{'authorization': 'bearer ' + (mUsers.isEmpty ? '' : (mUsers.first.get_token ?? ''))};
    } else if (must == PathConstant.NO_JWT) {
    } else {
      throw 'Path is irregular! "${httpRequest.path}"';
    }
  }
}
