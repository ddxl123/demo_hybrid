import 'dart:async';

import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/execute/Transfer.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DataTransferManager.g.dart';

/// 若 [left] 与 [right] 都为 null，则居中。
@JsonSerializable()
class ViewParams {
  ViewParams({
    required this.width,
    required this.height,
    required this.x,
    required this.y,
    required this.isFocus,
  });

  factory ViewParams.fromJson(Map<String, Object?> json) => _$ViewParamsFromJson(json);

  Map<String, Object?> toJson() => _$ViewParamsToJson(this);

  final int width;
  final int height;
  final int x;
  final int y;
  @JsonKey(name: 'is_focus')
  final bool? isFocus;

  @override
  String toString() {
    return 'ViewParams($width, $height, $x, $y, $isFocus)';
  }
}

class DataTransferManager {
  DataTransferManager._();

  static DataTransferManager instance = DataTransferManager._();

  late final String currentEntryPointName;

  late final BaseDataTransfer currentDataTransfer;

  final Transfer transfer = Transfer();

  bool isCurrentFlutterEngineOnReady = false;

  /// [currentEntryPointName] 必须比 [currentDataTransfer] 更先进行初始化，
  /// 因为 [currentDataTransfer] 需要 [currentEntryPointName]。
  ///
  /// [dataTransfer] 不能用对象传入，而必须用函数传入。
  /// 因为如果用对象传入，则会导致执行 [binding] 前 [BaseDataTransfer] 会先被构造，这时 [currentEntryPointName] 还并未初始化过，从而导致程序出错。
  void binding(String entryName, BaseDataTransfer dataTransfer()) {
    currentEntryPointName = entryName;
    currentDataTransfer = dataTransfer();
  }

  /// 向其他 flutter 引擎发消息，并接收返回值。
  ///
  /// [S] 发送的数据类型。 using the Flutter standard binary encoding.
  ///
  /// [R] 返回的正确数据类型。 using the Flutter standard binary encoding.
  ///
  /// [sendToWhichEngine] 发送消息到哪个引擎上。
  ///   - 固定：[EngineEntryName.MAIN] -> main 引擎，[EngineEntryName.NATIVE] -> 仅原生。
  ///
  /// [operationId] 操作的唯一标识。
  ///
  /// [setSendData] 发送的附带数据。
  ///
  /// [resultDataCast] 将原始类型手动转化为 [R]，若为空，则自动转化。
  ///
  Future<SingleResult<R>> sendMessageToOther<S, R extends Object>({
    required String sendToWhichEngine,
    required String operationId,
    required S setSendData(),
    required R resultDataCast(Object resultData)?,
  }) async {
    final SingleResult<R> sendResult = SingleResult<R>.empty();
    try {
      final Map<String, Object?> messageMap = <String, Object?>{
        'send_to_which_engine': sendToWhichEngine,
        'operation_id': operationId,
        'data': setSendData(),
      };
      final Object? resultData = await currentDataTransfer.basicMessageChannel.send(messageMap);
      if (resultData == null) {
        throw Exception('''
                
        来自原生的响应数据为 null！
        可能的原因如下：
          1. 消息通道异常。--- 直接返回了 null，而未抛出如何异常，没有错误 log 输出
          2. 原生发生了异常：
            1) 未发现引擎 sendToWhichEngine: $sendToWhichEngine。
            2) 未对 operationId: $operationId 进行处理。
          3. 接收者发生了异常
            1) listenerMessageFormOtherFlutterEngine 内部异常！
            2) 未对 operationId: $operationId 进行处理。
        ''');
      } else {
        await sendResult.setSuccess(setResult: () async => resultDataCast == null ? resultData as R : resultDataCast(resultData));
      }
    } catch (e, st) {
      sendResult.setError(exception: '_sendMessageToOther 内部异常！$e', stackTrace: st);
    }
    return sendResult;
  }

}
