import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hybrid/data/drift/dao/EasyDAO.dart';
import 'package:hybrid/data/drift/table/Cloud.dart';
import 'package:hybrid/data/drift/table/Local.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'DriftDb.g.dart';

@DriftDatabase(
  tables: <Type>[
    AppVersionInfos,
    Users,
    PnRules,
    PnCompletes,
    PnFragments,
    PnMemorys,
    FRules,
    FFragments,
    FCompletes,
    FMemorys,
  ],
  daos: <Type>[
    EasyDAO,
  ],
)
class DriftDb extends _$DriftDb {
  DriftDb._()
      : super(
          LazyDatabase(
            () async {
              final Directory dbFolder = await getApplicationDocumentsDirectory();
              final File file = File(join(dbFolder.path, 'db.sqlite'));
              return NativeDatabase(file, logStatements: true);
            },
          ),
        );

  static final DriftDb instance = DriftDb._();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {},
      );
}
