// ignore_for_file: avoid_classes_with_only_static_members

import 'package:dio/dio.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpRequest.dart';
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
        return httpStore.httpHandler.setCancel(vm: '请求频繁！', descp: Description(''), e: Exception('已禁止全部请求！'), st: null) as HS;
      }

      if (isBanAllOtherRequest) {
        // 若存在任意请求，则当前请求触发失败。
        if (_sameNotConcurrentMap.isNotEmpty) {
          return httpStore.httpHandler.setCancel(vm: '请求频繁！', descp: Description(''), e: Exception('要禁止其他全部请求时，已存在其他请求，需在没有任何请求的情况下才能触发！'), st: null) as HS;
        }
        _isBanAllRequest = true;
      }

      if (sameNotConcurrent != null) {
        /// 若相同请求被并发
        if (_sameNotConcurrentMap.containsKey(sameNotConcurrent)) {
          return httpStore.httpHandler.setCancel(vm: '请求频繁！', descp: Description(''), e: Exception('相同标记的请求被并发！'), st: null) as HS;
        }

        /// 当相同请求未并发时，对当前请求做阻断标记
        _sameNotConcurrentMap[sameNotConcurrent] = true;
      }
      late final MUser user;
      // 前提是用户已经在本地是已登陆状态，因为未登陆状态的请求是 no_jwt。
      if (httpStore.httpRequest.pathType() == PathType.jwt) {
        // 检测本地是否存在账号信息？
        final SingleResult<List<MUser>> queryUsersResult = await SqliteCurd.queryRowsAsModels<MUser>(
          connectTransactionMark: null,
          queryWrapper: QueryWrapper(tableName: MUser().tableName),
        );

        // 返回空则继续，即存在账号(同时获取 token)。
        final bool isReturn = await queryUsersResult.handle<bool>(
          doSuccess: (List<MUser> result) async {
            if (result.isEmpty) {
              //TODO: 不存在账号信息，则弹出【登陆界面引擎】
              httpStore.httpHandler.setCancel(vm: '未登录！', descp: Description(''), e: Exception('本地不存在账号信息！'), st: null) as HS;
              return true;
            }
            user = result.first;
            httpStore.httpRequest.requestHeadersVO.addAll(
              <String, Object?>{'authorization': 'bearer ' + (user.get_token ?? '')},
            );
            return false;
          },
          doError: (SingleResult<List<MUser>> errorResult) async {
            httpStore.httpHandler.setCancel(
                vm: errorResult.getRequiredVm(), descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace) as HS;
            return true;
          },
        );

        if (isReturn) {
          return httpStore;
        }
      } else if (httpStore.httpRequest.pathType() == PathType.no_jwt) {
      } else {
        return httpStore.httpHandler.setCancel(vm: '请求异常！', descp: Description(''), e: Exception('PathType：${httpStore.httpRequest.pathType()}'), st: null)
            as HS;
      }
      SbLogger(
        c: null,
        vm: null,
        data: <String, Object?>{
          'basePath': Httper.dio.options.baseUrl,
          'httpStore': httpStore.toJson(),
        },
        descp: Description(''),
        e: null,
        st: null,
      );

      if (isDev) {
        await Future<void>.delayed(const Duration(seconds: 2));
      }

      final Response<Map<String, Object?>> response = await Httper.dio.request<Map<String, Object?>>(
        httpStore.httpRequest.path,
        data: httpStore.httpRequest.requestDataVO,
        queryParameters: httpStore.httpRequest.requestParamsVO,
        options: Options(
          method: httpStore.httpRequest.method,
          headers: httpStore.httpRequest.requestHeadersVO,
        ),
      );

      SbLogger(c: null, vm: null, data: response, descp: Description('响应结果'), e: null, st: null);

      // 前提是用户已经在本地是已登陆状态，因为未登陆状态的请求是 no_jwt。
      if (httpStore.httpRequest.pathType() == PathType.jwt) {
        // 说明 token 刷新成功，即验证用户身份成功。
        if (response.headers.map['authorization'] != null) {
          final SingleResult<MUser> updateUserResult = await SqliteCurd.updateRow<MUser>(
            modelTableName: user.tableName,
            modelId: user.get_id!,
            updateContent: <String, Object?>{'authorization': (response.headers.map['authorization']! as String).split(' ')[1]},
            connectTransactionMark: null,
          );
          final bool isReturn = await updateUserResult.handle<bool>(
            doSuccess: (MUser successResult) async {
              return false;
            },
            doError: (SingleResult<MUser> errorResult) async {
              httpStore.httpHandler
                  .setCancel(vm: errorResult.getRequiredVm(), descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace);
              return true;
            },
          );
          if (isReturn) {
            return httpStore;
          }

          // 检测本地初始化数据是否已下载？
          if (user.get_is_downloaded_init_data != 1) {
            //TODO: 未下载，则弹出下载的相关页面，下载前删除除了 user 数据外的其他全部数据。
            return httpStore.httpHandler.setCancel(vm: '数据未下载！', descp: Description(''), e: Exception('Token 刷新成功，但未下载初始化数据！'), st: null) as HS;
          }
        } else {
          return httpStore.httpHandler.setCancel(vm: '用户验证失败，请重新尝试！', descp: Description(''), e: Exception('响应(刷新)的 authorization(token) 为 null！'), st: null)
              as HS;
        }
      }

      _sameNotConcurrentMap.remove(sameNotConcurrent);
      _isBanAllRequest = false;
      return httpStore.httpHandler.setPass(response) as HS;
    } catch (e, st) {
      _sameNotConcurrentMap.remove(sameNotConcurrent);
      _isBanAllRequest = false;
      if (e is DioError) {
        if (e.type == DioErrorType.sendTimeout || e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
          return httpStore.httpHandler.setCancel(vm: '请求超时！', descp: Description('dio 异常！可能是发送超时、连接超时、接收超时'), e: e, st: st) as HS;
        }
        return httpStore.httpHandler.setCancel(vm: '请求异常！', descp: Description('dio 异常！可能是 url 异常(不能为 127.0.0.1)'), e: e, st: st) as HS;
      }
      return httpStore.httpHandler.setCancel(vm: '发生错误！', descp: Description('1. 未知错误！'), e: e, st: st) as HS;
    }
  }
}
