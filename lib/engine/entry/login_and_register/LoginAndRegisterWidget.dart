import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpResponse.dart';
import 'package:hybrid/data/mysql/httpstore/store/HttpStore_login_and_register_by_email_send_email.dart';
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

              final HttpStore_login_and_register_by_email_send_email requestResult = await DataTransferManager.instance.transfer.executeHttpCurd.sendRequest(
                httpStore: HttpStore_login_and_register_by_email_send_email(
                  putRequestDataVO_LARBESE: () => RequestDataVO_LARBESE(
                    email: emailTextEditingController.text,
                  ),
                ),
                sameNotConcurrent: null,
                isBanAllOtherRequest: true,
                resultHttpStoreJson: (Map<String, Object?> json) async => HttpStore_login_and_register_by_email_send_email.fromJson(json),
              );

              await requestResult.httpResponse.handle(
                doContinue: (HttpResponse<ResponseCodeCollect_LARBESE, ResponseDataVO_LARBESE> hr) async {
                  // 发送成功。
                  if (hr.code == hr.responseCodeCollect.C2_01_01_01) {
                    SbLogger(
                      c: null,
                      vm: hr.viewMessage,
                      data: null,
                      descp: hr.description,
                      e: null,
                      st: null,
                    ).withToast(false);
                    return true;
                  }
                  return false;
                },
                doCancel: (HttpResponse<ResponseCodeCollect_LARBESE, ResponseDataVO_LARBESE> hr) async {
                  timer?.cancel();
                  timer = null;
                  text = '重新发送';
                  state.refresh();
                  SbLogger(
                    c: hr.code,
                    vm: hr.viewMessage,
                    data: hr,
                    descp: Description(''),
                    e: hr.exception,
                    st: hr.stackTrace,
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
          await PushTo.withEntryName(
            entryName: 'dddddddddddddd',
            startViewParams: (ViewParams lastViewParams, SizeInt screenSize) {
              final SizeInt viewSize = screenSize.multi(2 / 3, 1);
              final SizeInt halfSize = screenSize.multi(1 / 2, 1 / 2);
              print('$viewSize');
              return ViewParams(
                width: viewSize.width,
                height: viewSize.height,
                x: halfSize.width - viewSize.width ~/ 2,
                y: halfSize.height - viewSize.height ~/ 2,
                isFocus: true,
              );
            },
            endViewParams: (ViewParams lastViewParams, SizeInt screenSize) {
              final SizeInt viewSize = screenSize.multi(2 / 3, 1);
              final SizeInt halfSize = screenSize.multi(1 / 2, 1 / 2);
              print('$viewSize');
              return ViewParams(
                width: viewSize.width,
                height: viewSize.height,
                x: halfSize.width - viewSize.width ~/ 2,
                y: halfSize.height - viewSize.height ~/ 2,
                isFocus: true,
              );
            },
          );

          // final HttpStore_login_and_register_by_email_verify_email httpStore = await HttpCurd.sendRequest(
          //   httpStore: HttpStore_login_and_register_by_email_verify_email(
          //     setRequestDataVO_LARBEVE: () => RequestDataVO_LARBEVE(
          //       email: emailTextEditingController.text,
          //       code: int.parse(codeTextEditingController.text),
          //     ),
          //   ),
          //   sameNotConcurrent: null,
          //   isBanAllOtherRequest: true,
          // );
          // await httpStore.httpResponse.handle(
          //   doCancel: (HttpResponse<ResponseCodeCollect_LARBEVE, ResponseDataVO_LARBEVE> hr) async {
          //     // 登陆/注册失败
          //     SbLogger(
          //       code: hr.code,
          //       viewMessage: hr.viewMessage,
          //       data: null,
          //       description: hr.description,
          //       exception: hr.exception,
          //       stackTrace: hr.stackTrace,
          //     ).withAll(true);
          //   },
          //   doContinue: (HttpResponse<ResponseCodeCollect_LARBEVE, ResponseDataVO_LARBEVE> hr) async {
          //     // 登陆/注册成功
          //     if (hr.code == hr.responseCodeCollect.C2_01_02_01 || hr.code == hr.responseCodeCollect.C2_01_02_02) {
          //       // TODO:
          //       // 云端 token 生成成功，存储至本地。
          //       final MUser newToken = MUser.createModel(
          //         id: null,
          //         aiid: null,
          //         uuid: null,
          //         username: null,
          //         password: null,
          //         email: null,
          //         age: null,
          //         // 无论 token 值是否有问题，都进行存储。
          //         token: hr.responseDataVO.token,
          //         is_downloaded_init_data: null,
          //         created_at: SbHelper.newTimestamp,
          //         updated_at: SbHelper.newTimestamp,
          //       );
          //
          //       await db.delete(newToken.tableName);
          //       await db.insert(newToken.tableName, newToken.getRowJson);
          //
          //       SbLogger(
          //         code: null,
          //         viewMessage: hr.viewMessage,
          //         data: null,
          //         description: null,
          //         exception: null,
          //         stackTrace: null,
          //       ).withToast(false);
          //       return true;
          //     }
          //     // 邮箱重复异常
          //     if (hr.code == hr.responseCodeCollect.C2_01_02_03) {
          //       SbLogger(
          //         code: hr.code,
          //         viewMessage: hr.viewMessage,
          //         data: null,
          //         description: null,
          //         exception: null,
          //         stackTrace: null,
          //       ).withToast(true);
          //       return true;
          //     }
          //     // 验证码不正确
          //     else if (hr.code == hr.responseCodeCollect.C2_01_02_04) {
          //       SbLogger(
          //         code: null,
          //         viewMessage: hr.viewMessage,
          //         data: null,
          //         description: null,
          //         exception: null,
          //         stackTrace: null,
          //       ).withToast(false);
          //       return true;
          //     }
          //     return false;
          //   },
          // );
        },
      ),
    );
  }
}
