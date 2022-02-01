import 'package:drift/drift.dart';

import 'Base.dart';

// class PnRules extends TableCloudBase {
//   TextColumn get title => text().withDefault(const Constant('未命名'))();
//
//   TextColumn get easyPosition => text().nullable()();
// }
//
// class PnCompletes extends TableCloudBase {
//   IntColumn get ruleId => integer().nullable()();
//
//   IntColumn get ruleCid => integer().nullable()();
//
//   TextColumn get title => text().withDefault(const Constant('未命名'))();
//
//   TextColumn get easyPosition => text().nullable()();
// }
//
// class PnFragments extends TableCloudBase {
//   IntColumn get ruleId => integer().nullable()();
//
//   IntColumn get ruleCid => integer().nullable()();
//
//   TextColumn get title => text().withDefault(const Constant('未命名'))();
//
//   TextColumn get easyPosition => text().nullable()();
// }
//
// class PnMemorys extends TableCloudBase {
//   IntColumn get ruleId => integer().nullable()();
//
//   IntColumn get ruleCid => integer().nullable()();
//
//   TextColumn get title => text().withDefault(const Constant('未命名'))();
//
//   TextColumn get easyPosition => text().nullable()();
// }
//
// class FRules extends TableCloudBase {
//   IntColumn get fatherRuleId => integer().nullable()();
//
//   IntColumn get fatherRuleCid => integer().nullable()();
//
//   IntColumn get nodeId => integer().nullable()();
//
//   IntColumn get nodeCid => integer().nullable()();
//
//   TextColumn get title => text().withDefault(const Constant('未命名'))();
// }
//
// class FFragments extends TableCloudBase {
//   IntColumn get fatherFragmentId => integer().nullable()();
//
//   IntColumn get fatherFragmentCid => integer().nullable()();
//
//   IntColumn get nodeId => integer().nullable()();
//
//   IntColumn get nodeCid => integer().nullable()();
//
//   IntColumn get ruleId => integer().nullable()();
//
//   IntColumn get ruleCid => integer().nullable()();
//
//   TextColumn get title => text().withDefault(const Constant('未命名'))();
// }
//
// class FCompletes extends TableCloudBase {
//   IntColumn get nodeId => integer().nullable()();
//
//   IntColumn get nodeCid => integer().nullable()();
//
//   IntColumn get fragmentId => integer().nullable()();
//
//   IntColumn get fragmentCid => integer().nullable()();
//
//   IntColumn get ruleId => integer().nullable()();
//
//   IntColumn get ruleCid => integer().nullable()();
//
//   TextColumn get title => text().withDefault(const Constant('未命名'))();
// }
//
// class FMemorys extends TableCloudBase {
//   IntColumn get nodeId => integer().nullable()();
//
//   IntColumn get nodeCid => integer().nullable()();
//
//   IntColumn get fragmentId => integer().nullable()();
//
//   IntColumn get fragmentCid => integer().nullable()();
//
//   IntColumn get ruleId => integer().nullable()();
//
//   IntColumn get ruleCid => integer().nullable()();
//
//   TextColumn get title => text().withDefault(const Constant('未命名'))();
// }

///

class Users extends TableCloudBase {
  TextColumn get username => text().withDefault(const Constant('还没名字'))();

  TextColumn get password => text().nullable()();

  TextColumn get email => text().nullable()();

  IntColumn get age => integer().withDefault(const Constant(-1))();

  TextColumn get token => text()();

  BoolColumn get isDownloadedInitData => boolean().withDefault(const Constant(false))();
}

class Folders extends TableCloudBase {
  TextColumn get title => text().nullable()();
}

class Fragments extends TableCloudBase {
  TextColumn get question => text().nullable()();

  TextColumn get answer => text().nullable()();

  TextColumn get description => text().nullable()();
}

class Folder2Fragments extends TableCloudBase {
  IntColumn get folderId => integer().nullable()();

  IntColumn get folderCloudId => integer().nullable()();

  IntColumn get fragmentId => integer().nullable()();

  IntColumn get fragmentCloudId => integer().nullable()();
}

class SimilarFragments extends TableCloudBase {
  IntColumn get fragmentAId => integer().nullable()();

  IntColumn get fragmentACloudId => integer().nullable()();

  IntColumn get fragmentBId => integer().nullable()();

  IntColumn get fragmentBCloudId => integer().nullable()();
}

class MemoryGroups extends TableCloudBase {
  TextColumn get title => text().nullable()();
}

class MemoryGroup2Fragments extends TableCloudBase {
  IntColumn get memoryGroupId => integer().nullable()();

  IntColumn get memoryGroupCloudId => integer().nullable()();

  IntColumn get fragmentId => integer().nullable()();

  IntColumn get fragmentCloudId => integer().nullable()();
}
