import 'package:json_annotation/json_annotation.dart';

import 'executor/SqliteCurdTransaction/SqliteCurdTransactionQueue.dart';
import 'executor/TransferExecutor.dart';
import 'listener/TransferListener.dart';

part 'TransferManager.g.dart';

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

class TransferManager {
  TransferManager._();

  static TransferManager instance = TransferManager._();

  late final String currentEntryPointName;

  /// 当前入口的监听者。
  late final TransferListener transferListener;

  /// 当前入口的执行者。
  final TransferExecutor transferExecutor = TransferExecutor();

  bool isCurrentFlutterEngineOnReady = false;

  /// 1. 在 data_center 引擎中是存储来自其他引擎的每个 sqlite curd 流程操作。
  ///
  /// 2. 在其他引擎中是存储当前引擎的每个 sqlite curd 流程操作。
  ///
  /// 每创建一次 [SqliteCurdTransactionQueue] 对象，就会向这里面添加。
  final Map<String, SqliteCurdTransactionQueue> sqliteCurdTransactionQueues = <String, SqliteCurdTransactionQueue>{};

  /// [currentEntryPointName] 必须比 [transferListener] 更先进行初始化，
  /// 因为 [transferListener] 需要 [currentEntryPointName]。
  ///
  /// [putTransferListener] 不能用对象传入，而必须用函数传入。
  /// 因为如果用对象传入，则会导致执行 [binding] 前 [TransferListener] 会先被构造，这时 [currentEntryPointName] 还并未初始化过，从而导致程序出错。
  void binding(String entryPointName, TransferListener putTransferListener()) {
    currentEntryPointName = entryPointName;
    transferListener = putTransferListener();
  }
}
