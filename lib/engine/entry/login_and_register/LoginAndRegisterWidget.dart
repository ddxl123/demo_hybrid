import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpHandler.dart';
import 'package:hybrid/data/mysql/httpstore/store/HttpStore_login_and_register_by_email_send_email.dart';
import 'package:hybrid/data/mysql/httpstore/store/HttpStore_login_and_register_by_email_verify_email.dart';
import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/engine/push/PushTo.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';
import 'package:hybrid/util/sheetroute/Helper.dart';

class LoginAndRegisterWidget extends StatefulWidget {
  @override
  _LoginAndRegisterWidgetState createState() => _LoginAndRegisterWidgetState();
}

class _LoginAndRegisterWidgetState extends State<LoginAndRegisterWidget> {
  TextEditingController emailTextEditingController = TextEditingController(text: '1033839760@qq.com');
  TextEditingController codeTextEditingController = TextEditingController();

  Timer? timer;
  int time = 30;
  String text = '发送';

  Size currentSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return SbRoundedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      children: <Widget>[
        const Text(
          '登陆/注册',
          style: TextStyle(fontSize: 18),
        ),
        _emailInputField(),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(flex: 3, child: _codeInputField()),
            Expanded(child: _sendEmailButton()),
          ],
        ),
        const SizedBox(height: 10),
        _verifyEmailButton(),
      ],
    );
  }

  Widget _emailInputField() {
    return TextField(
      controller: emailTextEditingController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        icon: Icon(Icons.person),
        labelText: '邮箱',
      ),
      minLines: 1,
      maxLines: 1,
    );
  }

  Widget _codeInputField() {
    return TextField(
      controller: codeTextEditingController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        icon: Icon(Icons.lock),
        labelText: '验证码',
      ),
      minLines: 1,
      maxLines: 1,
    );
  }

  Widget _sendEmailButton() {
    return StatefulInitBuilder(
      init: (StatefulInitBuilderState state) {},
      builder: (StatefulInitBuilderState state) {
        return TextButton(
          child: Text(text),
          onPressed: () async {
            if (timer == null) {
              time = 10;
              text = time.toString() + 's';
              state.refresh();
              timer = Timer.periodic(
                const Duration(seconds: 1),
                (Timer t) {
                  if (time == 0) {
                    timer?.cancel();
                    timer = null;
                    text = '重新发送';
                    state.refresh();
                    return;
                  }
                  time -= 1;
                  text = time.toString() + 's';
                  state.refresh();
                },
              );
              final HttpStore_login_and_register_by_email_send_email requestResult = await DataTransferManager.instance.transferTool.executeHttpCurd.sendRequest(
                httpStore: HttpStore_login_and_register_by_email_send_email(
                  requestHeadersVO_LARBESE: RequestHeadersVO_LARBESE(),
                  requestParamsVO_LARBESE: RequestParamsVO_LARBESE(),
                  requestDataVO_LARBESE: RequestDataVO_LARBESE(
                    email: emailTextEditingController.text,
                  ),
                ),
                sameNotConcurrent: '_sendEmailButtonHttpStore_login_and_register_by_email_send_email',
                isBanAllOtherRequest: true,
                resultHttpStoreJson2HS: (Map<String, Object?> json) async => HttpStore_login_and_register_by_email_send_email.fromJson(json),
              );
              await requestResult.httpHandler.handle<HttpStore_login_and_register_by_email_send_email>(
                doContinue: (HttpStore_login_and_register_by_email_send_email hs) async {
                  // 发送成功。
                  if (hs.httpResponse.code == hs.httpResponse.getResponseCodeCollect(hs).C2_01_01_01) {
                    SbLogger(
                      c: null,
                      vm: hs.httpResponse.viewMessage,
                      data: null,
                      descp: Description(''),
                      e: null,
                      st: null,
                    ).withToast(false);
                    return true;
                  }
                  return false;
                },
                doCancel: (HttpHandler hh) async {
                  timer?.cancel();
                  timer = null;
                  text = '重新发送';
                  state.refresh();
                  SbLogger(
                    c: -1,
                    vm: hh.getRequiredViewMessage(),
                    data: null,
                    descp: hh.getRequiredDescription(),
                    e: hh.getRequiredException(),
                    st: hh.stackTrace,
                  ).withAll(true);
                },
              );
            }
          },
        );
      },
    );
  }

  Widget _verifyEmailButton() {
    return Container(
      width: double.maxFinite,
      child: TextButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all(const BorderSide(color: Colors.green)),
        ),
        child: const Text('登陆/注册'),
        onPressed: () async {
          final HttpStore_login_and_register_by_email_verify_email result = await HttpCurd.sendRequest<HttpStore_login_and_register_by_email_verify_email>(
            httpStore: HttpStore_login_and_register_by_email_verify_email(
              requestHeadersVO_LARBEVE: RequestHeadersVO_LARBEVE(),
              requestParamsVO_LARBEVE: RequestParamsVO_LARBEVE(),
              requestDataVO_LARBEVE: RequestDataVO_LARBEVE(email: emailTextEditingController.text, code: int.parse(codeTextEditingController.text)),
            ),
            sameNotConcurrent: '_verifyEmailButtonHttpStore_login_and_register_by_email_verify_email',
          );
          await result.httpHandler.handle(
            doContinue: (HttpStore_login_and_register_by_email_verify_email hs) async {
              // 登陆/注册成功
              if (hs.httpResponse.code == hs.httpResponse.getResponseCodeCollect(hs).C2_01_02_01 ||
                  hs.httpResponse.code == hs.httpResponse.getResponseCodeCollect(hs).C2_01_02_02) {
                // 云端 token 生成成功，存储至本地。
                final MUser newToken = MUser.createModel(
                  id: null,
                  aiid: hs.httpResponse.getResponseDataVO(hs).user_id,
                  uuid: null,
                  username: null,
                  password: null,
                  email: null,
                  age: null,
                  // 无论 token 值是否有问题，都进行存储。
                  token: hs.httpResponse.getResponseDataVO(hs).token,
                  is_downloaded_init_data: null,
                  created_at: SbHelper.newTimestamp,
                  updated_at: SbHelper.newTimestamp,
                );

                // TODO: clearToken 与 insertNewToken 必须进行事务处理。
                // 清空本地 token 信息。
                final SingleResult<bool> clearToken =
                    await DataTransferManager.instance.transferTool.executeSqliteCurd.deleteRow(modelTableName: newToken.tableName, modelId: null);

                final bool hasClearTokenError = await clearToken.handle<bool>(
                  doSuccess: (bool successResult) async {
                    if (!successResult) {
                      throw Exception('successResult is false');
                    }
                    return false;
                  },
                  doError: (SingleResult<bool> errorResult) async {
                    hs.httpHandler.setCancel(
                        vm: errorResult.getRequiredVm(), descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace);
                    return true;
                  },
                );
                if (hasClearTokenError) {
                  return false;
                }

                // 插入心的 token。
                final SingleResult<MUser> insertNewToken = await DataTransferManager.instance.transferTool.executeSqliteCurd.insertRow(newToken);
                final bool hasInsertNewTokenError = await insertNewToken.handle<bool>(
                  doSuccess: (MUser successResult) async {
                    SbLogger(c: null, vm: null, data: successResult.getRowJson, descp: Description('对 user 插入新 token 成功！'), e: null, st: null);
                    return false;
                  },
                  doError: (SingleResult<MUser> errorResult) async {
                    hs.httpHandler.setCancel(
                        vm: errorResult.getRequiredVm(), descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace);
                    return true;
                  },
                );
                if (hasInsertNewTokenError) {
                  return false;
                }

                SbLogger(c: null, vm: '登陆/注册成功！', data: null, descp: descp, e: e, st: st)
                return true;
              }
              // 邮箱重复异常
              if (hr.code == hr.responseCodeCollect.C2_01_02_03) {
                SbLogger(
                  code: hr.code,
                  viewMessage: hr.viewMessage,
                  data: null,
                  description: null,
                  exception: null,
                  stackTrace: null,
                ).withToast(true);
                return true;
              }
              // 验证码不正确
              else if (hr.code == hr.responseCodeCollect.C2_01_02_04) {
                SbLogger(
                  code: null,
                  viewMessage: hr.viewMessage,
                  data: null,
                  description: null,
                  exception: null,
                  stackTrace: null,
                ).withToast(false);
                return true;
              }
              return false;
            },
            doCancel: (HttpHandler hh) async {},
          );
          await httpStore.httpResponse.handle(
            doCancel: (HttpResponse<ResponseCodeCollect_LARBEVE, ResponseDataVO_LARBEVE> hr) async {
              // 登陆/注册失败
              SbLogger(
                code: hr.code,
                viewMessage: hr.viewMessage,
                data: null,
                description: hr.description,
                exception: hr.exception,
                stackTrace: hr.stackTrace,
              ).withAll(true);
            },
            doContinue: (HttpResponse<ResponseCodeCollect_LARBEVE, ResponseDataVO_LARBEVE> hr) async {
              // 登陆/注册成功
              if (hr.code == hr.responseCodeCollect.C2_01_02_01 || hr.code == hr.responseCodeCollect.C2_01_02_02) {
                // TODO:
                // 云端 token 生成成功，存储至本地。
                final MUser newToken = MUser.createModel(
                  id: null,
                  aiid: null,
                  uuid: null,
                  username: null,
                  password: null,
                  email: null,
                  age: null,
                  // 无论 token 值是否有问题，都进行存储。
                  token: hr.responseDataVO.token,
                  is_downloaded_init_data: null,
                  created_at: SbHelper.newTimestamp,
                  updated_at: SbHelper.newTimestamp,
                );

                await db.delete(newToken.tableName);
                await db.insert(newToken.tableName, newToken.getRowJson);

                SbLogger(
                  code: null,
                  viewMessage: hr.viewMessage,
                  data: null,
                  description: null,
                  exception: null,
                  stackTrace: null,
                ).withToast(false);
                return true;
              }
              // 邮箱重复异常
              if (hr.code == hr.responseCodeCollect.C2_01_02_03) {
                SbLogger(
                  code: hr.code,
                  viewMessage: hr.viewMessage,
                  data: null,
                  description: null,
                  exception: null,
                  stackTrace: null,
                ).withToast(true);
                return true;
              }
              // 验证码不正确
              else if (hr.code == hr.responseCodeCollect.C2_01_02_04) {
                SbLogger(
                  code: null,
                  viewMessage: hr.viewMessage,
                  data: null,
                  description: null,
                  exception: null,
                  stackTrace: null,
                ).withToast(false);
                return true;
              }
              return false;
            },
          );
        },
      ),
    );
  }
}
