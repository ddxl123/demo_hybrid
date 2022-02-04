import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hybrid/data/drift/dao/DeleteDAO.dart';
import 'package:hybrid/data/drift/dao/InsertDAO.dart';
import 'package:hybrid/data/drift/dao/RetrieveDAO.dart';
import 'package:hybrid/data/drift/dao/UpdateDAO.dart';
import 'package:hybrid/data/drift/table/Cloud.dart';
import 'package:hybrid/data/drift/table/Local.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'DriftDb.g.dart';

@DriftDatabase(
  tables: <Type>[
    AppInfos,
    Users,
    Folders,
    Fragments,
    MemoryGroups,
    Folder2Fragments,
    MemoryGroup2Fragments,
    SimilarFragments,
    Remembers,
  ],
  daos: <Type>[
    InsertDAO,
    DeleteDAO,
    UpdateDAO,
    RetrieveDAO,
  ],
)
class DriftDb extends _$DriftDb {
  DriftDb._()
      : super(
          LazyDatabase(
            /// 创建或打开数据库时会调用。
            () async {
              final Directory dbFolder = await getApplicationDocumentsDirectory();
              final File file = File(join(dbFolder.path, 'db.sqlite'));

              if (true && await file.exists()) {
                log('sqlite reset success: ${(await file.delete()).path}');
              }

              return NativeDatabase(file, logStatements: true);
            },
          ),
        );
  static DriftDb? _instance;

  static DriftDb get instance {
    if (_instance == null) {
      _instance = DriftDb._();
      return _instance!;
    } else {
      return _instance!;
    }
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {},
      );
}
