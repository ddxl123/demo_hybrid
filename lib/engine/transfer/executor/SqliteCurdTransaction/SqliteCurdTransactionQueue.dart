import 'package:hybrid/data/sqlite/sqliter/SqliteWrapper.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/util/SbHelper.dart';

import '../../TransferManager.dart';

class SqliteCurdTransactionQueue {
  ///

  SqliteCurdTransactionQueue.createForComplete(List<QueueMember> putMembers(SqliteCurdTransactionQueue queue)) {
    if (TransferManager.instance.currentEntryPointName == EngineEntryName.DATA_CENTER) {
      throw '只能在非 EngineEntryName.DATA_CENTER 中创建该对象！';
    }

    // 配置队列。
    queueId = hashCode.toString();
    fromWhichEntryPoint = TransferManager.instance.currentEntryPointName;
    members = <String, QueueMember>{};

    // 配置并添加成员。
    putMembers(this);

    // 添加队列。
    // 必须把 [队列的添加] 放到最后，因为当上方代码失败时，不会使得 [队列被添加]，从而无法清除。
    if (!TransferManager.instance.sqliteCurdTransactionQueues.containsKey(queueId)) {
      TransferManager.instance.sqliteCurdTransactionQueues.addAll(<String, SqliteCurdTransactionQueue>{queueId: this});
    } else {
      throw '队列重复！';
    }
  }

  SqliteCurdTransactionQueue.createForCutFromJson(Map<String, Object?> queueJson) {
    if (TransferManager.instance.currentEntryPointName == EngineEntryName.DATA_CENTER) {
      throw '只能在 EngineEntryName.DATA_CENTER 中创建该对象！';
    }

    if (queueJson.keys.length != 1) {
      throw 'createForCutFromJson 的 keys 数量不为 1！';
    }

    if (TransferManager.instance.sqliteCurdTransactionQueues.containsKey(queueJson.keys.first)) {
      throw 'transactionQueues 中已包含该 key！';
    }

    // 配置队列。
    queueId = queueJson.keys.first;
    final Map<String, Object?> ofQueueProperties = queueJson[queueId]!.quickCast();
    fromWhichEntryPoint = ofQueueProperties['fromWhichEntryPoint']! as String;
    members = <String, QueueMember>{};

    // 配置并添加成员。
    final Map<String, Object?> ofMembersJson = ofQueueProperties['members']!.quickCast();
    ofMembersJson.forEach(
      (String key, Object? value) {
        if (members.containsKey(key)) {
          throw 'members 中已包含该 key！';
        }
        members.addAll(<String, QueueMember>{key: QueueMember.createForCutFromJson(this, key, value!.quickCast())});
      },
    );

    // 添加队列。
    // 必须把 [队列的添加] 放到最后，因为当上方代码失败时，不会使得 [队列被添加]，从而无法清除。
    TransferManager.instance.sqliteCurdTransactionQueues.addAll(
      <String, SqliteCurdTransactionQueue>{queueId: this},
    );
  }

  /// 需要发送的。
  Map<String, Map<String, Object?>> toNeedSendJson() {
    final Map<String, Map<String, Object?>> needSendMembersMap = <String, Map<String, Object?>>{};
    members.forEach(
      (String key, QueueMember value) {
        needSendMembersMap.addAll(value.toNeedSendJson());
      },
    );

    return <String, Map<String, Object?>>{
      queueId: <String, Object?>{
        'formWhichEntryPoint': fromWhichEntryPoint,
        'members': needSendMembersMap,
      },
    };
  }

  /// 传
  ///
  /// 便于快速查找该对象。
  late String queueId;

  /// 传
  ///
  /// 来自哪个引擎入口。
  late final String fromWhichEntryPoint;

  /// 传
  ///
  /// curd 队列。
  late final Map<String, QueueMember> members;
}

class QueueMember {
  ///

  QueueMember.createForComplete({
    required this.queue,
    required this.curdWrapper,
    required this.laterFunction,
  }) {
    memberId = hashCode.toString();

    if (!queue.members.containsKey(memberId)) {
      queue.members.addAll(<String, QueueMember>{memberId: this});
    } else {
      throw '队列成员重复！';
    }
  }

  QueueMember.createForCutFromJson(this.queue, this.memberId, Map<String, Object?> memberJson) {
    curdWrapper = CurdWrapper.fromJsonByCurdType(memberJson['curdWrapper']!.quickCast());
  }

  /// 需要发送的。
  Map<String, Map<String, Object?>> toNeedSendJson() {
    return <String, Map<String, Object?>>{
      memberId: <String, Object?>{
        'curdWrapper': curdWrapper.toJson(),
      }
    };
  }

  final SqliteCurdTransactionQueue queue;

  /// 传
  /// 便于快速查找该对象。
  late final String memberId;

  /// 传
  /// curd 的包装：QueryWrapper 等。
  late final CurdWrapper curdWrapper;

  /// 不传
  /// curd 后要执行的函数。
  late final Function laterFunction;

  /// 不传
  /// curd 后获取到的 result。
  late final Object? result;
}
