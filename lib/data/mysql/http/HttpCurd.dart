// ignore_for_file: avoid_classes_with_only_static_members

import 'package:dio/dio.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import '../../../Config.dart';
import 'HttpInit.dart';

class HttpCurd {
  /// 【常规】请求的不可并发请求标志
  static final Map<String, bool> _sameNotConcurrentMap = <String, bool>{};

  /// 是否禁止所有请求。
  static bool _isBanAllRequest = false;

  ///
  ///
  ///
  /// general request
  ///
  /// [getHttpStore] 必须使用函数传入 [HS]，因为需要验证 [HS] 的请求参数，如果以对象的方式传入，则会导致请求参数验证异常无法捕获问题！
  ///   由于存在 [HttpStore_Catch] ，返回的 [HS] 对象可能与传入的 [HS] 对象不同，因此作 [HttpResponse.handle] 处理时需要使用返回的 [HS] 对象！
  ///
  /// [sameNotConcurrent] 不可并发标记。多个请求（可相同可不同），具有相同标记的请求不可并发。为 null 时代表不进行标记（即可并发）。
  ///
  /// [isBanAllOtherRequest] 若为 true，则其他请求全部禁止，只有当前请求继续直到当前请求结束。
  ///   - 若为 true，但同时存在其他请求，则当前请求也会失败。
  ///   - 若为 true，则 [sameNotConcurrent] 可为空。
  ///
  /// 向云端修改数据成功，而响应回本地修改 sqlite 数据失败 ———— 该问题会在 [SqliteCurd] 中进行处理。
  ///
  static Future<HS> sendRequest<HS extends HttpStore>({
    required HS httpStore,
    required String? sameNotConcurrent,
    bool isBanAllOtherRequest = false,
  }) async {
    try {
      if (_isBanAllRequest) {
        return await httpStore.setCancel(viewMessage: '请求频繁！', description: Description('已禁止全部请求！'), exception: null, stackTrace: null) as HS;
      }

      if (isBanAllOtherRequest) {
        // 若存在任意请求，则当前请求触发失败。
        if (_sameNotConcurrentMap.isNotEmpty) {
          return await httpStore.setCancel(
              viewMessage: '请求频繁！', description: Description('要禁止其他全部请求时，已存在其他请求，需在没有任何请求的情况下才能触发！'), exception: null, stackTrace: null) as HS;
        }
        _isBanAllRequest = true;
      }

      if (sameNotConcurrent != null) {
        /// 若相同请求被并发
        if (_sameNotConcurrentMap.containsKey(sameNotConcurrent)) {
          return await httpStore.setCancel(viewMessage: '请求频繁！', description: Description('相同标记的请求被并发！'), exception: null, stackTrace: null) as HS;
        }

        /// 当相同请求未并发时，对当前请求做阻断标记
        _sameNotConcurrentMap[sameNotConcurrent] = true;
      }

      SbLogger(
        code: null,
        viewMessage: null,
        data: null,
        description: Description(dio.options.baseUrl + httpStore.httpRequest.path),
        exception: null,
        stackTrace: null,
      );

      if (isDev) {
        await Future<void>.delayed(const Duration(seconds: 2));
      }

      final Response<Map<String, dynamic>> response = await dio.request<Map<String, dynamic>>(
        httpStore.httpRequest.path,
        data: httpStore.httpRequest.requestDataVO?.toJson(),
        queryParameters: httpStore.httpRequest.requestParamsVO?.toJson(),
        options: Options(
          method: httpStore.httpRequest.method,
          headers: httpStore.httpRequest.requestHeaders,
        ),
      );

      _sameNotConcurrentMap.remove(sameNotConcurrent);
      _isBanAllRequest = false;
      return await httpStore.setPass(response) as HS;
    } catch (e, st) {
      _sameNotConcurrentMap.remove(sameNotConcurrent);
      _isBanAllRequest = false;
      if (e is DioError) {
        if (e.type == DioErrorType.sendTimeout || e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
          return await httpStore.setCancel(
            viewMessage: '请求超时！',
            description: Description('dio 异常！可能是发送超时、连接超时、接收超时'),
            exception: e,
            stackTrace: st,
          ) as HS;
        }
        return await httpStore.setCancel(
          viewMessage: '请求异常！',
          description: Description('dio 异常！'),
          exception: e,
          stackTrace: st,
        ) as HS;
      }
      return await httpStore.setCancel(
        viewMessage: '发生错误！',
        description: Description('1. 可能是某个请求参数错误！'),
        exception: e,
        stackTrace: st,
      ) as HS;
    }
  }

  ///
  ///
  ///
  ///
  ///
// static Future<bool> sendRequestForRefreshToken() async {
//   bool isSuccess = false;
//
//   try {
//     final List<MToken> tokens = await ModelManager.queryRowsAsModels(connectTransaction: null, tableName: MToken().tableName);
//
//     final Map<String, String> headers = <String, String>{'Authorization': 'Bearer ' + (tokens.isEmpty ? '' : (tokens.first.get_token ?? ''))};
//
//     final HttpResult<CreateTokenVO> httpResult = await sendRequest(
//       method: 'GET',
//       httpPath: HttpPath_LONGIN_AND_REGISTER_BY_EMAIL_SEND_EMAIL(),
//       headers: headers,
//       data: null,
//       queryParameters: null,
//       sameNotConcurrent: null,
//       dataVO: CreateTokenVO(),
//       isBanAllOtherRequest: true,
//     );
//
//     await httpResult.handle(
//       doCancel: (HttpResult<CreateTokenVO> ht) async {
//         isSuccess = false;
//         SbLogger(
//           code: ht.getCode,
//           viewMessage: ht.getViewMessage ?? '发生异常，请重新登陆！',
//           data: null,
//           description: ht.getDescription,
//           exception: ht.getException,
//           stackTrace: ht.getStackTrace,
//         );
//       },
//       doContinue: (HttpResult<CreateTokenVO> ht) async {
//         if (httpResult.getCode == 1) {
//           // 云端 token 生成成功，存储至本地。
//           final MToken newToken = MToken.createModel(
//             id: null,
//             aiid: null,
//             uuid: null,
//             created_at: SbHelper().newTimestamp,
//             updated_at: SbHelper().newTimestamp,
//             // 无论 token 值是否有问题，都进行存储。
//             token: httpResult.getDataVO.emailToken,
//           );
//
//           await db.delete(MToken().tableName);
//           await db.insert(newToken.tableName, newToken.getRowJson);
//
//           SbLogger(
//             code: null,
//             viewMessage: ht.getViewMessage ?? '登陆成功！',
//             data: null,
//             description: ht.getDescription,
//             exception: ht.getException,
//             stackTrace: ht.getStackTrace,
//           );
//
//           isSuccess = true;
//           return true;
//         }
//         return false;
//       },
//     );
//   } catch (e, st) {
//     isSuccess = false;
//     SbLogger(
//       code: null,
//       viewMessage: '发生异常，请重新尝试！',
//       data: null,
//       description: '刷新令牌异常！',
//       exception: e,
//       stackTrace: st,
//     );
//   }
//   return isSuccess;
// }
}
