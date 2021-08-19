

import 'package:hybrid/data/mysql/constant/PathConstant.dart';
import 'package:hybrid/data/sqlite/mmodel/MToken.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';

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
      final List<MToken> tokens = await ModelManager.queryRowsAsModels(connectTransaction: null, tableName: MToken().tableName);
      httpRequest.requestHeaders = <String, dynamic>{'authorization': 'bearer ' + (tokens.isEmpty ? '' : (tokens.first.get_token ?? ''))};
    } else if (must == PathConstant.NO_JWT) {
    } else {
      throw 'Path is irregular! "${httpRequest.path}"';
    }
  }
}
