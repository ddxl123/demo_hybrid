import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpHandler.dart';
import 'package:hybrid/data/mysql/httpstore/store/HttpStore_login_and_register_by_email_send_email.dart';
import 'package:hybrid/data/mysql/httpstore/store/HttpStore_login_and_register_by_email_verify_email.dart';
import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/global/Global.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';
import 'package:hybrid/util/sbroute/SbPopResult.dart';
import 'package:hybrid/util/sbroute/SbRoute.dart';
import 'package:hybrid/util/sheetroute/Helper.dart';

class LoginPage extends SbRoute {
  TextEditingController emailTextEditingController = TextEditingController(text: '1033839760@qq.com');
  TextEditingController codeTextEditingController = TextEditingController();

  Timer? timer;
  int time = 30;
  String text = '发送';

  @override
  List<Widget> body() {
    return <Widget>[
      SbRoundedBox(
        width: screenSize.width * 4 / 5,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        children: <Widget>[
          const Flexible(
            child: Text(
              '登陆/注册',
              style: TextStyle(fontSize: 18),
            ),
          ),
          _emailInputField(),
          const Flexible(child: SizedBox(height: 10)),
          Flexible(
            child: Row(
              children: <Widget>[
                _codeInputField(),
                _sendEmailButton(),
              ],
            ),
          ),
          const Flexible(child: SizedBox(height: 10)),
          _verifyEmailButton(),
        ],
      ),
    ];
  }

  Widget _emailInputField() {
    return Flexible(
      child: TextField(
        controller: emailTextEditingController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          icon: Icon(Icons.person),
          labelText: '邮箱',
        ),
        minLines: 1,
        maxLines: 1,
      ),
    );
  }

  Widget _codeInputField() {
    return Expanded(
      child: TextField(
        controller: codeTextEditingController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          icon: Icon(Icons.lock),
          labelText: '验证码',
        ),
        minLines: 1,
        maxLines: 1,
      ),
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

              final HttpStore_login_and_register_by_email_send_email requestResult = await DataTransferManager.instance.transfer.executeHttpCurd.sendRequest(
                httpStore: HttpStore_login_and_register_by_email_send_email(
                  requestHeadersVO_LARBESE: RequestHeadersVO_LARBESE(),
                  requestParamsVO_LARBESE: RequestParamsVO_LARBESE(),
                  requestDataVO_LARBESE: RequestDataVO_LARBESE(
                    email: emailTextEditingController.text,
                  ),
                ),
                sameNotConcurrent: null,
                isBanAllOtherRequest: true,
                resultHttpStoreJson2HS: (Map<String, Object?> json) async => HttpStore_login_and_register_by_email_send_email.fromJson(json),
              );
              await requestResult.httpHandler.handle<HttpStore_login_and_register_by_email_send_email>(
                doContinue: (HttpStore_login_and_register_by_email_send_email hs) async {
                  // 发送成功。
                  if (hs.httpResponse.code == hs.httpResponse.getResponseCodeCollect(hs).C2_01_01_01) {
                    SbLogger(
                      c: hs.httpResponse.code,
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
                    c: null,
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
    return Flexible(
      child: Container(
        width: double.maxFinite,
        child: TextButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(const BorderSide(color: Colors.green)),
          ),
          child: const Text('登陆/注册'),
          onPressed: () async {
            final HttpStore_login_and_register_by_email_verify_email requestResult = await DataTransferManager.instance.transfer.executeHttpCurd.sendRequest(
              httpStore: HttpStore_login_and_register_by_email_verify_email(
                requestHeadersVO_LARBEVE: RequestHeadersVO_LARBEVE(),
                requestParamsVO_LARBEVE: RequestParamsVO_LARBEVE(),
                requestDataVO_LARBEVE: RequestDataVO_LARBEVE(
                  email: emailTextEditingController.text,
                  code: int.parse(codeTextEditingController.text),
                ),
              ),
              sameNotConcurrent: null,
              isBanAllOtherRequest: true,
              resultHttpStoreJson2HS: (Map<String, Object?> json) async => HttpStore_login_and_register_by_email_verify_email.fromJson(json),
            );
            await requestResult.httpHandler.handle<HttpStore_login_and_register_by_email_verify_email>(
              doContinue: (HttpStore_login_and_register_by_email_verify_email hs) async {
                // 登陆/注册成功
                if (hs.httpResponse.code == hs.httpResponse.getResponseCodeCollect(hs).C2_01_02_01 ||
                    hs.httpResponse.code == hs.httpResponse.getResponseCodeCollect(hs).C2_01_02_02) {
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
                    token: hs.httpResponse.getResponseDataVO(hs).token,
                    is_downloaded_init_data: null,
                    created_at: SbHelper.newTimestamp,
                    updated_at: SbHelper.newTimestamp,
                  );

                  await db.delete(newToken.tableName);
                  await db.insert(newToken.tableName, newToken.getRowJson);

                  SbLogger(
                    c: null,
                    vm: hs.httpResponse.viewMessage,
                    data: null,
                    descp: null,
                    e: null,
                    st: null,
                  ).withToast(false);
                  return true;
                }
                // 邮箱重复异常
                if (hs.httpResponse.code == hs.httpResponse.getResponseCodeCollect(hs).C2_01_02_03) {
                  SbLogger(
                    c: hs.httpResponse.code,
                    vm: hs.httpResponse.viewMessage,
                    data: null,
                    descp: null,
                    e: null,
                    st: null,
                  ).withToast(true);
                  return true;
                }
                // 验证码不正确
                else if (hs.httpResponse.code == hs.httpResponse.getResponseCodeCollect(hs).C2_01_02_04) {
                  SbLogger(
                    c: null,
                    vm: hs.httpResponse.viewMessage,
                    data: null,
                    descp: null,
                    e: null,
                    st: null,
                  ).withToast(false);
                  return true;
                }
                return false;
              },
              doCancel: (HttpHandler hh) async {
                // 登陆/注册失败
                SbLogger(
                  c: null,
                  vm: hh.getRequiredViewMessage(),
                  data: null,
                  descp: hh.getRequiredDescription(),
                  e: hh.getRequiredException(),
                  st: hh.stackTrace,
                ).withAll(true);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Future<bool> whenPop(SbPopResult? popResult) async {
    return await quickWhenPop(popResult, (SbPopResult quickPopResult) async => false);
  }

  @override
  bool whenException(Object? exception, StackTrace? stackTrace) {
    SbLogger(c: null, vm: null, data: null, descp: null, e: exception, st: stackTrace);
    return false;
  }
}
