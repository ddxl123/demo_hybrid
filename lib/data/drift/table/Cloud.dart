import 'package:drift/drift.dart';

import 'Base.dart';

class Users extends TableCloudBase {
  TextColumn get username => text().withDefault(const Constant('异常用户名'))();

  TextColumn get password => text().nullable()();

  TextColumn get email => text().nullable()();

  IntColumn get age => integer().withDefault(const Constant(-1))();

  TextColumn get token => text()();

  BoolColumn get isDownloadedInitData => boolean().withDefault(const Constant(false))();
}

class PnRules extends TableCloudBase {
  TextColumn get title => text().withDefault(const Constant('未命名'))();

  TextColumn get easyPosition => text().nullable()();
}

class PnCompletes extends TableCloudBase {
  IntColumn get ruleId => integer().nullable()();

  IntColumn get ruleCid => integer().nullable()();

  TextColumn get title => text().withDefault(const Constant('未命名'))();

  TextColumn get easyPosition => text().nullable()();
}

class PnFragments extends TableCloudBase {
  IntColumn get ruleId => integer().nullable()();

  IntColumn get ruleCid => integer().nullable()();

  TextColumn get title => text().withDefault(const Constant('未命名'))();

  TextColumn get easyPosition => text().nullable()();
}

class PnMemorys extends TableCloudBase {
  IntColumn get ruleId => integer().nullable()();

  IntColumn get ruleCid => integer().nullable()();

  TextColumn get title => text().withDefault(const Constant('未命名'))();

  TextColumn get easyPosition => text().nullable()();
}

class FRules extends TableCloudBase {
  IntColumn get fatherRuleId => integer().nullable()();

  IntColumn get fatherRuleCid => integer().nullable()();

  IntColumn get nodeId => integer().nullable()();

  IntColumn get nodeCid => integer().nullable()();

  TextColumn get title => text().withDefault(const Constant('未命名'))();
}

class FFragments extends TableCloudBase {
  IntColumn get fatherFragmentId => integer().nullable()();

  IntColumn get fatherFragmentCid => integer().nullable()();

  IntColumn get nodeId => integer().nullable()();

  IntColumn get nodeCid => integer().nullable()();

  IntColumn get ruleId => integer().nullable()();

  IntColumn get ruleCid => integer().nullable()();

  TextColumn get title => text().withDefault(const Constant('未命名'))();
}

class FCompletes extends TableCloudBase {
  IntColumn get nodeId => integer().nullable()();

  IntColumn get nodeCid => integer().nullable()();

  IntColumn get fragmentId => integer().nullable()();

  IntColumn get fragmentCid => integer().nullable()();

  IntColumn get ruleId => integer().nullable()();

  IntColumn get ruleCid => integer().nullable()();

  TextColumn get title => text().withDefault(const Constant('未命名'))();
}

class FMemorys extends TableCloudBase {
  IntColumn get nodeId => integer().nullable()();

  IntColumn get nodeCid => integer().nullable()();

  IntColumn get fragmentId => integer().nullable()();

  IntColumn get fragmentCid => integer().nullable()();

  IntColumn get ruleId => integer().nullable()();

  IntColumn get ruleCid => integer().nullable()();

  TextColumn get title => text().withDefault(const Constant('未命名'))();
}
