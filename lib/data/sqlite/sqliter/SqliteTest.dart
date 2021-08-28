// ignore_for_file: non_constant_identifier_names

import 'package:hybrid/data/sqlite/mmodel/MPnComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnMemory.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnRule.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class SqliteTest {
  Future<void> _for({required int count, required Future<void> Function() insert}) async {
    for (int i = 0; i < count; i++) {
      await insert();
    }
  }

  Future<void> createTestData() async {
    //
    await _for(
      count: 5,
      insert: () async {
        await MPnFragment.createModel(
          id: null,
          aiid: null,
          uuid: SbHelper.newUuid,
          created_at: null,
          updated_at: null,
          rule_aiid: null,
          rule_uuid: null,
          easy_position: '${SbHelper.randomDouble(2000)},${SbHelper.randomDouble(2000)}',
          title: SbHelper.randomString(20),
        ).insertDb();
      },
    );
    await _for(
      count: 5,
      insert: () async {
        await MPnMemory.createModel(
          id: null,
          aiid: null,
          uuid: SbHelper.newUuid,
          rule_aiid: null,
          rule_uuid: null,
          created_at: null,
          updated_at: null,
          easy_position: '${SbHelper.randomDouble(2000)},${SbHelper.randomDouble(2000)}',
          title: SbHelper.randomString(20),
        ).insertDb();
      },
    );
    await _for(
      count: 5,
      insert: () async {
        await MPnComplete.createModel(
          id: null,
          aiid: null,
          uuid: SbHelper.newUuid,
          rule_aiid: null,
          rule_uuid: null,
          created_at: null,
          updated_at: null,
          easy_position: '${SbHelper.randomDouble(2000)},${SbHelper.randomDouble(2000)}',
          title: SbHelper.randomString(20),
        ).insertDb();
      },
    );
    await _for(
      count: 5,
      insert: () async {
        await MPnRule.createModel(
          id: null,
          aiid: null,
          uuid: SbHelper.newUuid,
          created_at: null,
          updated_at: null,
          easy_position: '${SbHelper.randomDouble(2000)},${SbHelper.randomDouble(2000)}',
          title: SbHelper.randomString(20),
        ).insertDb();
      },
    );

    // await _for(
    //   count: 5,
    //   insert: () async {
    //     await MFFragment.createModel(id: null, aiid: null, uuid: SbHelper().newUuid, created_at: null, updated_at: null, title: SbHelper().randomString(10)).insertDb();
    //   },
    // );
    //
    // await _for(
    //   count: 5,
    //   insert: () async {
    //     await MFMemory.createModel(id: null, aiid: null, uuid: SbHelper().newUuid, created_at: null, updated_at: null, title: SbHelper().randomString(10)).insertDb();
    //   },
    // );
    //
    // await _for(
    //   count: 5,
    //   insert: () async {
    //     await MFComplete.createModel(id: null, aiid: null, uuid: SbHelper().newUuid, created_at: null, updated_at: null, title: SbHelper().randomString(10)).insertDb();
    //   },
    // );
    //
    // await _for(
    //   count: 5,
    //   insert: () async {
    //     await MFRule.createModel(id: null, aiid: null, uuid: SbHelper().newUuid, created_at: null, updated_at: null, title: SbHelper().randomString(10)).insertDb();
    //   },
    // );
    //
    SbLogger(
      code: null,
      viewMessage: null,
      data: null,
      description: Description('生成测试数据成功！'),
      exception: null,
      stackTrace: null,
    );
  }
}
