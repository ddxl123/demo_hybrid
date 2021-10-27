// ignore_for_file: avoid_classes_with_only_static_members

import 'package:dio/dio.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import '../../../Config.dart';
import 'Httper.dart';

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
  /// [putHttpStore] 返回的 [HttpStore] 不一定是输入的 [HttpStore]，所以在 [HttpStore.handle] 时，必须使用返回的 [HttpStore]。
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

      // 检测本地是否存在账号信息？
      final SingleResult<List<MUser>> usersResult = await SqliteCurd.queryRowsAsModels<MUser>(
        connectTransaction: null,
        queryWrapper: QueryWrapper(tableName: MUser().tableName),
      );

      final HS? usersResultHandleResult = await usersResult.handle<HS?>(
        onSuccess: (List<MUser> result) async {
          if (result.isEmpty) {
            //TODO: 弹出【登陆界面引擎】
            return await httpStore.setCancel(
              viewMessage: '未登录！',
              description: Description('本地不存在账号信息！'),
              exception: null,
              stackTrace: null,
            ) as HS;
          }
          return null;
        },
        onError: (Object? exception, StackTrace? stackTrace) async {
          return await httpStore.setCancel(
            viewMessage: '检查账号时发生了异常！',
            description: Description('查询数据库时发生了异常！'),
            exception: usersResult.exception,
            stackTrace: usersResult.stackTrace,
          ) as HS;
        },
      );

      if (usersResultHandleResult != null) {
        return usersResultHandleResult;
      }

      SbLogger(
        code: null,
        viewMessage: null,
        data: null,
        description: Description(Httper.dio.options.baseUrl + httpStore.httpRequest.path),
        exception: null,
        stackTrace: null,
      );

      if (isDev) {
        await Future<void>.delayed(const Duration(seconds: 2));
      }

      final Response<Map<String, Object?>> response = await Httper.dio.request<Map<String, Object?>>(
        httpStore.httpRequest.path,
        data: httpStore.httpRequest.requestDataVO?.toJson(),
        queryParameters: httpStore.httpRequest.requestParamsVO?.toJson(),
        options: Options(
          method: httpStore.httpRequest.method,
          headers: httpStore.httpRequest.requestHeaders,
        ),
      );

      // 说明 token 刷新成功，即验证用户身份成功。
      if (response.headers.map['authorization'] != null) {
        // 检测本地初始化数据是否已下载？
        if (usersResult.result!.first.get_is_downloaded_init_data != 1) {
          //TODO: 未下载，则弹出下载的相关页面，下载前删除除了 user 数据外的其他全部数据。
          return await httpStore.setCancel(viewMessage: '数据未下载！', description: Description('Token 刷新成功，但未下载初始化数据！'), exception: null, stackTrace: null) as HS;
        }
      }

      _sameNotConcurrentMap.remove(sameNotConcurrent);
      _isBanAllRequest = false;
      return await httpStore.setPass(response) as HS;
    } catch (e, st) {
      _sameNotConcurrentMap.remove(sameNotConcurrent);
      _isBanAllRequest = false;
      if (e is DioError) {
        if (e.type == DioErrorType.sendTimeout || e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
          return await httpStore.setCancel(viewMessage: '请求超时！', description: Description('dio 异常！可能是发送超时、连接超时、接收超时'), exception: e, stackTrace: st) as HS;
        }
        return await httpStore.setCancel(viewMessage: '请求异常！', description: Description('dio 异常！'), exception: e, stackTrace: st) as HS;
      }
      return await httpStore.setCancel(
        viewMessage: '发生错误！',
        description: Description('1. 可能是 putHttpStore 中的某个请求参数错误！'),
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
