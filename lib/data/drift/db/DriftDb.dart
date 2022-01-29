import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hybrid/data/drift/dao/JianJiDAO.dart';
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
    SimilarFragments,
  ],
  daos: <Type>[
    JianJiDAO,
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

              if (true) {
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
          await jianJiDAO.batch((batch) {
            batch.insertAll(
              folders,
              <FoldersCompanion>[
                const FoldersCompanion(cloudId: Value(1), title: Value('1')),
                const FoldersCompanion(cloudId: Value(2), title: Value('2')),
                const FoldersCompanion(cloudId: Value(3), title: Value('3')),
                const FoldersCompanion(cloudId: Value(4), title: Value('4')),
                const FoldersCompanion(cloudId: Value(5), title: Value('5')),
                const FoldersCompanion(cloudId: Value(6), title: Value('6')),
                const FoldersCompanion(cloudId: Value(7), title: Value('7')),
                const FoldersCompanion(cloudId: Value(8), title: Value('8')),
                const FoldersCompanion(cloudId: Value(9), title: Value('9')),
                const FoldersCompanion(cloudId: Value(10), title: Value('10')),
                const FoldersCompanion(cloudId: Value(11), title: Value('11')),
                const FoldersCompanion(cloudId: Value(12), title: Value('12')),
                const FoldersCompanion(cloudId: Value(13), title: Value('13')),
                const FoldersCompanion(cloudId: Value(14), title: Value('14')),
                const FoldersCompanion(cloudId: Value(15), title: Value('15')),
                const FoldersCompanion(cloudId: Value(16), title: Value('16')),
                const FoldersCompanion(cloudId: Value(17), title: Value('17')),
                const FoldersCompanion(cloudId: Value(18), title: Value('18')),
                const FoldersCompanion(cloudId: Value(19), title: Value('19')),
                const FoldersCompanion(cloudId: Value(20), title: Value('20')),
                const FoldersCompanion(cloudId: Value(21), title: Value('21')),
                const FoldersCompanion(cloudId: Value(22), title: Value('22')),
                const FoldersCompanion(cloudId: Value(23), title: Value('23')),
                const FoldersCompanion(cloudId: Value(24), title: Value('24')),
                const FoldersCompanion(cloudId: Value(25), title: Value('25')),
                const FoldersCompanion(cloudId: Value(26), title: Value('26')),
              ],
            );
          });
        },
        onUpgrade: (Migrator m, int from, int to) async {},
      );
}
