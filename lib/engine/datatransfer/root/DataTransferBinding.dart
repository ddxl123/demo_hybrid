import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';

class DataTransferBinding {
  DataTransferBinding._();

  static DataTransferBinding instance = DataTransferBinding._();

  late String currentEntryName;

  late BaseDataTransfer currentDataTransfer;

  /// [currentEntryName] 必须比 [currentDataTransfer] 更先进行初始化，
  /// 因为 [currentDataTransfer] 需要 [currentEntryName]。
  ///
  /// [dataTransfer] 不能用对象传入，而必须用函数传入。
  /// 因为如果用对象传入，则会导致执行 [binding] 前 [BaseDataTransfer] 会先被构造，这时 [currentEntryName] 还并未初始化过，从而导致程序出错。
  void binding(String entryName, BaseDataTransfer dataTransfer()) {
    currentEntryName = entryName;
    currentDataTransfer = dataTransfer();
  }
}
