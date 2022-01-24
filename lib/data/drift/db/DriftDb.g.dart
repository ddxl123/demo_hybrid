// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'DriftDb.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class AppVersionInfo extends DataClass implements Insertable<AppVersionInfo> {
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final String savedVersion;
  AppVersionInfo(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.savedVersion});
  factory AppVersionInfo.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return AppVersionInfo(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      savedVersion: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}saved_version'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['saved_version'] = Variable<String>(savedVersion);
    return map;
  }

  AppVersionInfosCompanion toCompanion(bool nullToAbsent) {
    return AppVersionInfosCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      savedVersion: Value(savedVersion),
    );
  }

  factory AppVersionInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppVersionInfo(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      savedVersion: serializer.fromJson<String>(json['savedVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'savedVersion': serializer.toJson<String>(savedVersion),
    };
  }

  AppVersionInfo copyWith(
          {int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? savedVersion}) =>
      AppVersionInfo(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        savedVersion: savedVersion ?? this.savedVersion,
      );
  @override
  String toString() {
    return (StringBuffer('AppVersionInfo(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('savedVersion: $savedVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, savedVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppVersionInfo &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.savedVersion == this.savedVersion);
}

class AppVersionInfosCompanion extends UpdateCompanion<AppVersionInfo> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> savedVersion;
  const AppVersionInfosCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.savedVersion = const Value.absent(),
  });
  AppVersionInfosCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String savedVersion,
  }) : savedVersion = Value(savedVersion);
  static Insertable<AppVersionInfo> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? savedVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (savedVersion != null) 'saved_version': savedVersion,
    });
  }

  AppVersionInfosCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? savedVersion}) {
    return AppVersionInfosCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      savedVersion: savedVersion ?? this.savedVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (savedVersion.present) {
      map['saved_version'] = Variable<String>(savedVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppVersionInfosCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('savedVersion: $savedVersion')
          ..write(')'))
        .toString();
  }
}

class $AppVersionInfosTable extends AppVersionInfos
    with TableInfo<$AppVersionInfosTable, AppVersionInfo> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AppVersionInfosTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _savedVersionMeta =
      const VerificationMeta('savedVersion');
  @override
  late final GeneratedColumn<String?> savedVersion = GeneratedColumn<String?>(
      'saved_version', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, updatedAt, savedVersion];
  @override
  String get aliasedName => _alias ?? 'app_version_infos';
  @override
  String get actualTableName => 'app_version_infos';
  @override
  VerificationContext validateIntegrity(Insertable<AppVersionInfo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('saved_version')) {
      context.handle(
          _savedVersionMeta,
          savedVersion.isAcceptableOrUnknown(
              data['saved_version']!, _savedVersionMeta));
    } else if (isInserting) {
      context.missing(_savedVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppVersionInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    return AppVersionInfo.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AppVersionInfosTable createAlias(String alias) {
    return $AppVersionInfosTable(_db, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  /// 可空。
  final int cloudId;

  /// 同步 curd 类型。为空则表示该行不需要进行同步。
  ///
  /// 值： null C-0 U-1 R-2 D-3
  ///
  /// 不为 null 的可能性：
  ///   1. 未上传更改。
  ///   2. 客户端上传数据后，客户端被断掉，从而未对服务器上传成功的消息进行接收。（若是服务器断掉，则客户端会收到失败的响应）
  ///
  /// 若客户端请求——服务器响应，这个流程成功则设为 null，失败则保持为 curd。
  /// 若为 2 的情况，应用会再次检索未上传的数据，再次进行上传，但无碍，因为服务端上传时，会对比 updatedAt。
  ///   - 若新旧相同，则服务端已同步过，响应客户端将其置空。
  ///   - 若新的晚于旧的，则需要服务端进行同步后，响应客户端将其置空。
  ///   - 若新的早于旧的，则 1. 可能客户端、服务端时间被篡改；2. 该条数据在其他客户端已经被同步过了 TODO: 可依据此处设计多客户端登陆方案。
  final int? syncCurd;

  /// 当 [syncCurd] 为 U-1 时，[syncUpdateColumns] 不能为空。
  ///
  /// 值为字段名，如："username,password"。
  final String? syncUpdateColumns;
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final String username;
  final String? password;
  final String? email;
  final int age;
  final String token;
  final bool isDownloadedInitData;
  User(
      {required this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.username,
      this.password,
      this.email,
      required this.age,
      required this.token,
      required this.isDownloadedInitData});
  factory User.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id'])!,
      syncCurd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sync_curd']),
      syncUpdateColumns: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sync_update_columns']),
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      username: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}username'])!,
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email']),
      age: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}age'])!,
      token: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}token'])!,
      isDownloadedInitData: const BoolType().mapFromDatabaseResponse(
          data['${effectivePrefix}is_downloaded_init_data'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cloud_id'] = Variable<int>(cloudId);
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String?>(password);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String?>(email);
    }
    map['age'] = Variable<int>(age);
    map['token'] = Variable<String>(token);
    map['is_downloaded_init_data'] = Variable<bool>(isDownloadedInitData);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      cloudId: Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      username: Value(username),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      age: Value(age),
      token: Value(token),
      isDownloadedInitData: Value(isDownloadedInitData),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      cloudId: serializer.fromJson<int>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String?>(json['password']),
      email: serializer.fromJson<String?>(json['email']),
      age: serializer.fromJson<int>(json['age']),
      token: serializer.fromJson<String>(json['token']),
      isDownloadedInitData:
          serializer.fromJson<bool>(json['isDownloadedInitData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String?>(password),
      'email': serializer.toJson<String?>(email),
      'age': serializer.toJson<int>(age),
      'token': serializer.toJson<String>(token),
      'isDownloadedInitData': serializer.toJson<bool>(isDownloadedInitData),
    };
  }

  User copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? username,
          String? password,
          String? email,
          int? age,
          String? token,
          bool? isDownloadedInitData}) =>
      User(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        username: username ?? this.username,
        password: password ?? this.password,
        email: email ?? this.email,
        age: age ?? this.age,
        token: token ?? this.token,
        isDownloadedInitData: isDownloadedInitData ?? this.isDownloadedInitData,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('email: $email, ')
          ..write('age: $age, ')
          ..write('token: $token, ')
          ..write('isDownloadedInitData: $isDownloadedInitData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cloudId,
      syncCurd,
      syncUpdateColumns,
      id,
      createdAt,
      updatedAt,
      username,
      password,
      email,
      age,
      token,
      isDownloadedInitData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.username == this.username &&
          other.password == this.password &&
          other.email == this.email &&
          other.age == this.age &&
          other.token == this.token &&
          other.isDownloadedInitData == this.isDownloadedInitData);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> username;
  final Value<String?> password;
  final Value<String?> email;
  final Value<int> age;
  final Value<String> token;
  final Value<bool> isDownloadedInitData;
  const UsersCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.email = const Value.absent(),
    this.age = const Value.absent(),
    this.token = const Value.absent(),
    this.isDownloadedInitData = const Value.absent(),
  });
  UsersCompanion.insert({
    required int cloudId,
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.email = const Value.absent(),
    this.age = const Value.absent(),
    required String token,
    this.isDownloadedInitData = const Value.absent(),
  })  : cloudId = Value(cloudId),
        token = Value(token);
  static Insertable<User> custom({
    Expression<int>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? username,
    Expression<String?>? password,
    Expression<String?>? email,
    Expression<int>? age,
    Expression<String>? token,
    Expression<bool>? isDownloadedInitData,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (email != null) 'email': email,
      if (age != null) 'age': age,
      if (token != null) 'token': token,
      if (isDownloadedInitData != null)
        'is_downloaded_init_data': isDownloadedInitData,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? username,
      Value<String?>? password,
      Value<String?>? email,
      Value<int>? age,
      Value<String>? token,
      Value<bool>? isDownloadedInitData}) {
    return UsersCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      age: age ?? this.age,
      token: token ?? this.token,
      isDownloadedInitData: isDownloadedInitData ?? this.isDownloadedInitData,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int>(cloudId.value);
    }
    if (syncCurd.present) {
      map['sync_curd'] = Variable<int?>(syncCurd.value);
    }
    if (syncUpdateColumns.present) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String?>(password.value);
    }
    if (email.present) {
      map['email'] = Variable<String?>(email.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (isDownloadedInitData.present) {
      map['is_downloaded_init_data'] =
          Variable<bool>(isDownloadedInitData.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('email: $email, ')
          ..write('age: $age, ')
          ..write('token: $token, ')
          ..write('isDownloadedInitData: $isDownloadedInitData')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _syncCurdMeta = const VerificationMeta('syncCurd');
  @override
  late final GeneratedColumn<int?> syncCurd = GeneratedColumn<int?>(
      'sync_curd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncUpdateColumnsMeta =
      const VerificationMeta('syncUpdateColumns');
  @override
  late final GeneratedColumn<String?> syncUpdateColumns =
      GeneratedColumn<String?>('sync_update_columns', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _usernameMeta = const VerificationMeta('username');
  @override
  late final GeneratedColumn<String?> username = GeneratedColumn<String?>(
      'username', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('异常用户名'));
  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  @override
  late final GeneratedColumn<String?> password = GeneratedColumn<String?>(
      'password', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String?> email = GeneratedColumn<String?>(
      'email', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int?> age = GeneratedColumn<int?>(
      'age', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(-1));
  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String?> token = GeneratedColumn<String?>(
      'token', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _isDownloadedInitDataMeta =
      const VerificationMeta('isDownloadedInitData');
  @override
  late final GeneratedColumn<bool?> isDownloadedInitData =
      GeneratedColumn<bool?>('is_downloaded_init_data', aliasedName, false,
          type: const BoolType(),
          requiredDuringInsert: false,
          defaultConstraints: 'CHECK (is_downloaded_init_data IN (0, 1))',
          defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        username,
        password,
        email,
        age,
        token,
        isDownloadedInitData
      ];
  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
    } else if (isInserting) {
      context.missing(_cloudIdMeta);
    }
    if (data.containsKey('sync_curd')) {
      context.handle(_syncCurdMeta,
          syncCurd.isAcceptableOrUnknown(data['sync_curd']!, _syncCurdMeta));
    }
    if (data.containsKey('sync_update_columns')) {
      context.handle(
          _syncUpdateColumnsMeta,
          syncUpdateColumns.isAcceptableOrUnknown(
              data['sync_update_columns']!, _syncUpdateColumnsMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('is_downloaded_init_data')) {
      context.handle(
          _isDownloadedInitDataMeta,
          isDownloadedInitData.isAcceptableOrUnknown(
              data['is_downloaded_init_data']!, _isDownloadedInitDataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    return User.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }
}

class PnRule extends DataClass implements Insertable<PnRule> {
  /// 可空。
  final int cloudId;

  /// 同步 curd 类型。为空则表示该行不需要进行同步。
  ///
  /// 值： null C-0 U-1 R-2 D-3
  ///
  /// 不为 null 的可能性：
  ///   1. 未上传更改。
  ///   2. 客户端上传数据后，客户端被断掉，从而未对服务器上传成功的消息进行接收。（若是服务器断掉，则客户端会收到失败的响应）
  ///
  /// 若客户端请求——服务器响应，这个流程成功则设为 null，失败则保持为 curd。
  /// 若为 2 的情况，应用会再次检索未上传的数据，再次进行上传，但无碍，因为服务端上传时，会对比 updatedAt。
  ///   - 若新旧相同，则服务端已同步过，响应客户端将其置空。
  ///   - 若新的晚于旧的，则需要服务端进行同步后，响应客户端将其置空。
  ///   - 若新的早于旧的，则 1. 可能客户端、服务端时间被篡改；2. 该条数据在其他客户端已经被同步过了 TODO: 可依据此处设计多客户端登陆方案。
  final int? syncCurd;

  /// 当 [syncCurd] 为 U-1 时，[syncUpdateColumns] 不能为空。
  ///
  /// 值为字段名，如："username,password"。
  final String? syncUpdateColumns;
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String? easyPosition;
  PnRule(
      {required this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.title,
      this.easyPosition});
  factory PnRule.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return PnRule(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id'])!,
      syncCurd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sync_curd']),
      syncUpdateColumns: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sync_update_columns']),
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      easyPosition: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}easy_position']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cloud_id'] = Variable<int>(cloudId);
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || easyPosition != null) {
      map['easy_position'] = Variable<String?>(easyPosition);
    }
    return map;
  }

  PnRulesCompanion toCompanion(bool nullToAbsent) {
    return PnRulesCompanion(
      cloudId: Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      title: Value(title),
      easyPosition: easyPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(easyPosition),
    );
  }

  factory PnRule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PnRule(
      cloudId: serializer.fromJson<int>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      title: serializer.fromJson<String>(json['title']),
      easyPosition: serializer.fromJson<String?>(json['easyPosition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'title': serializer.toJson<String>(title),
      'easyPosition': serializer.toJson<String?>(easyPosition),
    };
  }

  PnRule copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? title,
          String? easyPosition}) =>
      PnRule(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        title: title ?? this.title,
        easyPosition: easyPosition ?? this.easyPosition,
      );
  @override
  String toString() {
    return (StringBuffer('PnRule(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('easyPosition: $easyPosition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cloudId, syncCurd, syncUpdateColumns, id,
      createdAt, updatedAt, title, easyPosition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PnRule &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.title == this.title &&
          other.easyPosition == this.easyPosition);
}

class PnRulesCompanion extends UpdateCompanion<PnRule> {
  final Value<int> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> title;
  final Value<String?> easyPosition;
  const PnRulesCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.easyPosition = const Value.absent(),
  });
  PnRulesCompanion.insert({
    required int cloudId,
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.easyPosition = const Value.absent(),
  }) : cloudId = Value(cloudId);
  static Insertable<PnRule> custom({
    Expression<int>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? title,
    Expression<String?>? easyPosition,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (title != null) 'title': title,
      if (easyPosition != null) 'easy_position': easyPosition,
    });
  }

  PnRulesCompanion copyWith(
      {Value<int>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? title,
      Value<String?>? easyPosition}) {
    return PnRulesCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      easyPosition: easyPosition ?? this.easyPosition,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int>(cloudId.value);
    }
    if (syncCurd.present) {
      map['sync_curd'] = Variable<int?>(syncCurd.value);
    }
    if (syncUpdateColumns.present) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (easyPosition.present) {
      map['easy_position'] = Variable<String?>(easyPosition.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PnRulesCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title, ')
          ..write('easyPosition: $easyPosition')
          ..write(')'))
        .toString();
  }
}

class $PnRulesTable extends PnRules with TableInfo<$PnRulesTable, PnRule> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PnRulesTable(this._db, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _syncCurdMeta = const VerificationMeta('syncCurd');
  @override
  late final GeneratedColumn<int?> syncCurd = GeneratedColumn<int?>(
      'sync_curd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncUpdateColumnsMeta =
      const VerificationMeta('syncUpdateColumns');
  @override
  late final GeneratedColumn<String?> syncUpdateColumns =
      GeneratedColumn<String?>('sync_update_columns', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('未命名'));
  final VerificationMeta _easyPositionMeta =
      const VerificationMeta('easyPosition');
  @override
  late final GeneratedColumn<String?> easyPosition = GeneratedColumn<String?>(
      'easy_position', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        title,
        easyPosition
      ];
  @override
  String get aliasedName => _alias ?? 'pn_rules';
  @override
  String get actualTableName => 'pn_rules';
  @override
  VerificationContext validateIntegrity(Insertable<PnRule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
    } else if (isInserting) {
      context.missing(_cloudIdMeta);
    }
    if (data.containsKey('sync_curd')) {
      context.handle(_syncCurdMeta,
          syncCurd.isAcceptableOrUnknown(data['sync_curd']!, _syncCurdMeta));
    }
    if (data.containsKey('sync_update_columns')) {
      context.handle(
          _syncUpdateColumnsMeta,
          syncUpdateColumns.isAcceptableOrUnknown(
              data['sync_update_columns']!, _syncUpdateColumnsMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('easy_position')) {
      context.handle(
          _easyPositionMeta,
          easyPosition.isAcceptableOrUnknown(
              data['easy_position']!, _easyPositionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PnRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    return PnRule.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PnRulesTable createAlias(String alias) {
    return $PnRulesTable(_db, alias);
  }
}

class PnComplete extends DataClass implements Insertable<PnComplete> {
  /// 可空。
  final int cloudId;

  /// 同步 curd 类型。为空则表示该行不需要进行同步。
  ///
  /// 值： null C-0 U-1 R-2 D-3
  ///
  /// 不为 null 的可能性：
  ///   1. 未上传更改。
  ///   2. 客户端上传数据后，客户端被断掉，从而未对服务器上传成功的消息进行接收。（若是服务器断掉，则客户端会收到失败的响应）
  ///
  /// 若客户端请求——服务器响应，这个流程成功则设为 null，失败则保持为 curd。
  /// 若为 2 的情况，应用会再次检索未上传的数据，再次进行上传，但无碍，因为服务端上传时，会对比 updatedAt。
  ///   - 若新旧相同，则服务端已同步过，响应客户端将其置空。
  ///   - 若新的晚于旧的，则需要服务端进行同步后，响应客户端将其置空。
  ///   - 若新的早于旧的，则 1. 可能客户端、服务端时间被篡改；2. 该条数据在其他客户端已经被同步过了 TODO: 可依据此处设计多客户端登陆方案。
  final int? syncCurd;

  /// 当 [syncCurd] 为 U-1 时，[syncUpdateColumns] 不能为空。
  ///
  /// 值为字段名，如："username,password"。
  final String? syncUpdateColumns;
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? ruleId;
  final int? ruleCid;
  final String title;
  final String? easyPosition;
  PnComplete(
      {required this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.ruleId,
      this.ruleCid,
      required this.title,
      this.easyPosition});
  factory PnComplete.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return PnComplete(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id'])!,
      syncCurd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sync_curd']),
      syncUpdateColumns: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sync_update_columns']),
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      ruleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_id']),
      ruleCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_cid']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      easyPosition: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}easy_position']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cloud_id'] = Variable<int>(cloudId);
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<int?>(ruleId);
    }
    if (!nullToAbsent || ruleCid != null) {
      map['rule_cid'] = Variable<int?>(ruleCid);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || easyPosition != null) {
      map['easy_position'] = Variable<String?>(easyPosition);
    }
    return map;
  }

  PnCompletesCompanion toCompanion(bool nullToAbsent) {
    return PnCompletesCompanion(
      cloudId: Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      ruleId:
          ruleId == null && nullToAbsent ? const Value.absent() : Value(ruleId),
      ruleCid: ruleCid == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleCid),
      title: Value(title),
      easyPosition: easyPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(easyPosition),
    );
  }

  factory PnComplete.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PnComplete(
      cloudId: serializer.fromJson<int>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      ruleId: serializer.fromJson<int?>(json['ruleId']),
      ruleCid: serializer.fromJson<int?>(json['ruleCid']),
      title: serializer.fromJson<String>(json['title']),
      easyPosition: serializer.fromJson<String?>(json['easyPosition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'ruleId': serializer.toJson<int?>(ruleId),
      'ruleCid': serializer.toJson<int?>(ruleCid),
      'title': serializer.toJson<String>(title),
      'easyPosition': serializer.toJson<String?>(easyPosition),
    };
  }

  PnComplete copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? ruleId,
          int? ruleCid,
          String? title,
          String? easyPosition}) =>
      PnComplete(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        ruleId: ruleId ?? this.ruleId,
        ruleCid: ruleCid ?? this.ruleCid,
        title: title ?? this.title,
        easyPosition: easyPosition ?? this.easyPosition,
      );
  @override
  String toString() {
    return (StringBuffer('PnComplete(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title, ')
          ..write('easyPosition: $easyPosition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cloudId, syncCurd, syncUpdateColumns, id,
      createdAt, updatedAt, ruleId, ruleCid, title, easyPosition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PnComplete &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.ruleId == this.ruleId &&
          other.ruleCid == this.ruleCid &&
          other.title == this.title &&
          other.easyPosition == this.easyPosition);
}

class PnCompletesCompanion extends UpdateCompanion<PnComplete> {
  final Value<int> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> ruleId;
  final Value<int?> ruleCid;
  final Value<String> title;
  final Value<String?> easyPosition;
  const PnCompletesCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
    this.easyPosition = const Value.absent(),
  });
  PnCompletesCompanion.insert({
    required int cloudId,
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
    this.easyPosition = const Value.absent(),
  }) : cloudId = Value(cloudId);
  static Insertable<PnComplete> custom({
    Expression<int>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? ruleId,
    Expression<int?>? ruleCid,
    Expression<String>? title,
    Expression<String?>? easyPosition,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (ruleId != null) 'rule_id': ruleId,
      if (ruleCid != null) 'rule_cid': ruleCid,
      if (title != null) 'title': title,
      if (easyPosition != null) 'easy_position': easyPosition,
    });
  }

  PnCompletesCompanion copyWith(
      {Value<int>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? ruleId,
      Value<int?>? ruleCid,
      Value<String>? title,
      Value<String?>? easyPosition}) {
    return PnCompletesCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ruleId: ruleId ?? this.ruleId,
      ruleCid: ruleCid ?? this.ruleCid,
      title: title ?? this.title,
      easyPosition: easyPosition ?? this.easyPosition,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int>(cloudId.value);
    }
    if (syncCurd.present) {
      map['sync_curd'] = Variable<int?>(syncCurd.value);
    }
    if (syncUpdateColumns.present) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int?>(ruleId.value);
    }
    if (ruleCid.present) {
      map['rule_cid'] = Variable<int?>(ruleCid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (easyPosition.present) {
      map['easy_position'] = Variable<String?>(easyPosition.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PnCompletesCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title, ')
          ..write('easyPosition: $easyPosition')
          ..write(')'))
        .toString();
  }
}

class $PnCompletesTable extends PnCompletes
    with TableInfo<$PnCompletesTable, PnComplete> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PnCompletesTable(this._db, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _syncCurdMeta = const VerificationMeta('syncCurd');
  @override
  late final GeneratedColumn<int?> syncCurd = GeneratedColumn<int?>(
      'sync_curd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncUpdateColumnsMeta =
      const VerificationMeta('syncUpdateColumns');
  @override
  late final GeneratedColumn<String?> syncUpdateColumns =
      GeneratedColumn<String?>('sync_update_columns', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int?> ruleId = GeneratedColumn<int?>(
      'rule_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _ruleCidMeta = const VerificationMeta('ruleCid');
  @override
  late final GeneratedColumn<int?> ruleCid = GeneratedColumn<int?>(
      'rule_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('未命名'));
  final VerificationMeta _easyPositionMeta =
      const VerificationMeta('easyPosition');
  @override
  late final GeneratedColumn<String?> easyPosition = GeneratedColumn<String?>(
      'easy_position', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        ruleId,
        ruleCid,
        title,
        easyPosition
      ];
  @override
  String get aliasedName => _alias ?? 'pn_completes';
  @override
  String get actualTableName => 'pn_completes';
  @override
  VerificationContext validateIntegrity(Insertable<PnComplete> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
    } else if (isInserting) {
      context.missing(_cloudIdMeta);
    }
    if (data.containsKey('sync_curd')) {
      context.handle(_syncCurdMeta,
          syncCurd.isAcceptableOrUnknown(data['sync_curd']!, _syncCurdMeta));
    }
    if (data.containsKey('sync_update_columns')) {
      context.handle(
          _syncUpdateColumnsMeta,
          syncUpdateColumns.isAcceptableOrUnknown(
              data['sync_update_columns']!, _syncUpdateColumnsMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    }
    if (data.containsKey('rule_cid')) {
      context.handle(_ruleCidMeta,
          ruleCid.isAcceptableOrUnknown(data['rule_cid']!, _ruleCidMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('easy_position')) {
      context.handle(
          _easyPositionMeta,
          easyPosition.isAcceptableOrUnknown(
              data['easy_position']!, _easyPositionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PnComplete map(Map<String, dynamic> data, {String? tablePrefix}) {
    return PnComplete.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PnCompletesTable createAlias(String alias) {
    return $PnCompletesTable(_db, alias);
  }
}

class PnFragment extends DataClass implements Insertable<PnFragment> {
  /// 可空。
  final int cloudId;

  /// 同步 curd 类型。为空则表示该行不需要进行同步。
  ///
  /// 值： null C-0 U-1 R-2 D-3
  ///
  /// 不为 null 的可能性：
  ///   1. 未上传更改。
  ///   2. 客户端上传数据后，客户端被断掉，从而未对服务器上传成功的消息进行接收。（若是服务器断掉，则客户端会收到失败的响应）
  ///
  /// 若客户端请求——服务器响应，这个流程成功则设为 null，失败则保持为 curd。
  /// 若为 2 的情况，应用会再次检索未上传的数据，再次进行上传，但无碍，因为服务端上传时，会对比 updatedAt。
  ///   - 若新旧相同，则服务端已同步过，响应客户端将其置空。
  ///   - 若新的晚于旧的，则需要服务端进行同步后，响应客户端将其置空。
  ///   - 若新的早于旧的，则 1. 可能客户端、服务端时间被篡改；2. 该条数据在其他客户端已经被同步过了 TODO: 可依据此处设计多客户端登陆方案。
  final int? syncCurd;

  /// 当 [syncCurd] 为 U-1 时，[syncUpdateColumns] 不能为空。
  ///
  /// 值为字段名，如："username,password"。
  final String? syncUpdateColumns;
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? ruleId;
  final int? ruleCid;
  final String title;
  final String? easyPosition;
  PnFragment(
      {required this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.ruleId,
      this.ruleCid,
      required this.title,
      this.easyPosition});
  factory PnFragment.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return PnFragment(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id'])!,
      syncCurd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sync_curd']),
      syncUpdateColumns: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sync_update_columns']),
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      ruleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_id']),
      ruleCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_cid']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      easyPosition: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}easy_position']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cloud_id'] = Variable<int>(cloudId);
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<int?>(ruleId);
    }
    if (!nullToAbsent || ruleCid != null) {
      map['rule_cid'] = Variable<int?>(ruleCid);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || easyPosition != null) {
      map['easy_position'] = Variable<String?>(easyPosition);
    }
    return map;
  }

  PnFragmentsCompanion toCompanion(bool nullToAbsent) {
    return PnFragmentsCompanion(
      cloudId: Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      ruleId:
          ruleId == null && nullToAbsent ? const Value.absent() : Value(ruleId),
      ruleCid: ruleCid == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleCid),
      title: Value(title),
      easyPosition: easyPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(easyPosition),
    );
  }

  factory PnFragment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PnFragment(
      cloudId: serializer.fromJson<int>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      ruleId: serializer.fromJson<int?>(json['ruleId']),
      ruleCid: serializer.fromJson<int?>(json['ruleCid']),
      title: serializer.fromJson<String>(json['title']),
      easyPosition: serializer.fromJson<String?>(json['easyPosition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'ruleId': serializer.toJson<int?>(ruleId),
      'ruleCid': serializer.toJson<int?>(ruleCid),
      'title': serializer.toJson<String>(title),
      'easyPosition': serializer.toJson<String?>(easyPosition),
    };
  }

  PnFragment copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? ruleId,
          int? ruleCid,
          String? title,
          String? easyPosition}) =>
      PnFragment(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        ruleId: ruleId ?? this.ruleId,
        ruleCid: ruleCid ?? this.ruleCid,
        title: title ?? this.title,
        easyPosition: easyPosition ?? this.easyPosition,
      );
  @override
  String toString() {
    return (StringBuffer('PnFragment(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title, ')
          ..write('easyPosition: $easyPosition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cloudId, syncCurd, syncUpdateColumns, id,
      createdAt, updatedAt, ruleId, ruleCid, title, easyPosition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PnFragment &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.ruleId == this.ruleId &&
          other.ruleCid == this.ruleCid &&
          other.title == this.title &&
          other.easyPosition == this.easyPosition);
}

class PnFragmentsCompanion extends UpdateCompanion<PnFragment> {
  final Value<int> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> ruleId;
  final Value<int?> ruleCid;
  final Value<String> title;
  final Value<String?> easyPosition;
  const PnFragmentsCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
    this.easyPosition = const Value.absent(),
  });
  PnFragmentsCompanion.insert({
    required int cloudId,
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
    this.easyPosition = const Value.absent(),
  }) : cloudId = Value(cloudId);
  static Insertable<PnFragment> custom({
    Expression<int>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? ruleId,
    Expression<int?>? ruleCid,
    Expression<String>? title,
    Expression<String?>? easyPosition,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (ruleId != null) 'rule_id': ruleId,
      if (ruleCid != null) 'rule_cid': ruleCid,
      if (title != null) 'title': title,
      if (easyPosition != null) 'easy_position': easyPosition,
    });
  }

  PnFragmentsCompanion copyWith(
      {Value<int>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? ruleId,
      Value<int?>? ruleCid,
      Value<String>? title,
      Value<String?>? easyPosition}) {
    return PnFragmentsCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ruleId: ruleId ?? this.ruleId,
      ruleCid: ruleCid ?? this.ruleCid,
      title: title ?? this.title,
      easyPosition: easyPosition ?? this.easyPosition,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int>(cloudId.value);
    }
    if (syncCurd.present) {
      map['sync_curd'] = Variable<int?>(syncCurd.value);
    }
    if (syncUpdateColumns.present) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int?>(ruleId.value);
    }
    if (ruleCid.present) {
      map['rule_cid'] = Variable<int?>(ruleCid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (easyPosition.present) {
      map['easy_position'] = Variable<String?>(easyPosition.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PnFragmentsCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title, ')
          ..write('easyPosition: $easyPosition')
          ..write(')'))
        .toString();
  }
}

class $PnFragmentsTable extends PnFragments
    with TableInfo<$PnFragmentsTable, PnFragment> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PnFragmentsTable(this._db, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _syncCurdMeta = const VerificationMeta('syncCurd');
  @override
  late final GeneratedColumn<int?> syncCurd = GeneratedColumn<int?>(
      'sync_curd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncUpdateColumnsMeta =
      const VerificationMeta('syncUpdateColumns');
  @override
  late final GeneratedColumn<String?> syncUpdateColumns =
      GeneratedColumn<String?>('sync_update_columns', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int?> ruleId = GeneratedColumn<int?>(
      'rule_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _ruleCidMeta = const VerificationMeta('ruleCid');
  @override
  late final GeneratedColumn<int?> ruleCid = GeneratedColumn<int?>(
      'rule_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('未命名'));
  final VerificationMeta _easyPositionMeta =
      const VerificationMeta('easyPosition');
  @override
  late final GeneratedColumn<String?> easyPosition = GeneratedColumn<String?>(
      'easy_position', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        ruleId,
        ruleCid,
        title,
        easyPosition
      ];
  @override
  String get aliasedName => _alias ?? 'pn_fragments';
  @override
  String get actualTableName => 'pn_fragments';
  @override
  VerificationContext validateIntegrity(Insertable<PnFragment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
    } else if (isInserting) {
      context.missing(_cloudIdMeta);
    }
    if (data.containsKey('sync_curd')) {
      context.handle(_syncCurdMeta,
          syncCurd.isAcceptableOrUnknown(data['sync_curd']!, _syncCurdMeta));
    }
    if (data.containsKey('sync_update_columns')) {
      context.handle(
          _syncUpdateColumnsMeta,
          syncUpdateColumns.isAcceptableOrUnknown(
              data['sync_update_columns']!, _syncUpdateColumnsMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    }
    if (data.containsKey('rule_cid')) {
      context.handle(_ruleCidMeta,
          ruleCid.isAcceptableOrUnknown(data['rule_cid']!, _ruleCidMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('easy_position')) {
      context.handle(
          _easyPositionMeta,
          easyPosition.isAcceptableOrUnknown(
              data['easy_position']!, _easyPositionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PnFragment map(Map<String, dynamic> data, {String? tablePrefix}) {
    return PnFragment.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PnFragmentsTable createAlias(String alias) {
    return $PnFragmentsTable(_db, alias);
  }
}

class PnMemory extends DataClass implements Insertable<PnMemory> {
  /// 可空。
  final int cloudId;

  /// 同步 curd 类型。为空则表示该行不需要进行同步。
  ///
  /// 值： null C-0 U-1 R-2 D-3
  ///
  /// 不为 null 的可能性：
  ///   1. 未上传更改。
  ///   2. 客户端上传数据后，客户端被断掉，从而未对服务器上传成功的消息进行接收。（若是服务器断掉，则客户端会收到失败的响应）
  ///
  /// 若客户端请求——服务器响应，这个流程成功则设为 null，失败则保持为 curd。
  /// 若为 2 的情况，应用会再次检索未上传的数据，再次进行上传，但无碍，因为服务端上传时，会对比 updatedAt。
  ///   - 若新旧相同，则服务端已同步过，响应客户端将其置空。
  ///   - 若新的晚于旧的，则需要服务端进行同步后，响应客户端将其置空。
  ///   - 若新的早于旧的，则 1. 可能客户端、服务端时间被篡改；2. 该条数据在其他客户端已经被同步过了 TODO: 可依据此处设计多客户端登陆方案。
  final int? syncCurd;

  /// 当 [syncCurd] 为 U-1 时，[syncUpdateColumns] 不能为空。
  ///
  /// 值为字段名，如："username,password"。
  final String? syncUpdateColumns;
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? ruleId;
  final int? ruleCid;
  final String title;
  final String? easyPosition;
  PnMemory(
      {required this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.ruleId,
      this.ruleCid,
      required this.title,
      this.easyPosition});
  factory PnMemory.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return PnMemory(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id'])!,
      syncCurd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sync_curd']),
      syncUpdateColumns: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sync_update_columns']),
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      ruleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_id']),
      ruleCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_cid']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      easyPosition: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}easy_position']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cloud_id'] = Variable<int>(cloudId);
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<int?>(ruleId);
    }
    if (!nullToAbsent || ruleCid != null) {
      map['rule_cid'] = Variable<int?>(ruleCid);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || easyPosition != null) {
      map['easy_position'] = Variable<String?>(easyPosition);
    }
    return map;
  }

  PnMemorysCompanion toCompanion(bool nullToAbsent) {
    return PnMemorysCompanion(
      cloudId: Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      ruleId:
          ruleId == null && nullToAbsent ? const Value.absent() : Value(ruleId),
      ruleCid: ruleCid == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleCid),
      title: Value(title),
      easyPosition: easyPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(easyPosition),
    );
  }

  factory PnMemory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PnMemory(
      cloudId: serializer.fromJson<int>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      ruleId: serializer.fromJson<int?>(json['ruleId']),
      ruleCid: serializer.fromJson<int?>(json['ruleCid']),
      title: serializer.fromJson<String>(json['title']),
      easyPosition: serializer.fromJson<String?>(json['easyPosition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'ruleId': serializer.toJson<int?>(ruleId),
      'ruleCid': serializer.toJson<int?>(ruleCid),
      'title': serializer.toJson<String>(title),
      'easyPosition': serializer.toJson<String?>(easyPosition),
    };
  }

  PnMemory copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? ruleId,
          int? ruleCid,
          String? title,
          String? easyPosition}) =>
      PnMemory(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        ruleId: ruleId ?? this.ruleId,
        ruleCid: ruleCid ?? this.ruleCid,
        title: title ?? this.title,
        easyPosition: easyPosition ?? this.easyPosition,
      );
  @override
  String toString() {
    return (StringBuffer('PnMemory(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title, ')
          ..write('easyPosition: $easyPosition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cloudId, syncCurd, syncUpdateColumns, id,
      createdAt, updatedAt, ruleId, ruleCid, title, easyPosition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PnMemory &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.ruleId == this.ruleId &&
          other.ruleCid == this.ruleCid &&
          other.title == this.title &&
          other.easyPosition == this.easyPosition);
}

class PnMemorysCompanion extends UpdateCompanion<PnMemory> {
  final Value<int> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> ruleId;
  final Value<int?> ruleCid;
  final Value<String> title;
  final Value<String?> easyPosition;
  const PnMemorysCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
    this.easyPosition = const Value.absent(),
  });
  PnMemorysCompanion.insert({
    required int cloudId,
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
    this.easyPosition = const Value.absent(),
  }) : cloudId = Value(cloudId);
  static Insertable<PnMemory> custom({
    Expression<int>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? ruleId,
    Expression<int?>? ruleCid,
    Expression<String>? title,
    Expression<String?>? easyPosition,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (ruleId != null) 'rule_id': ruleId,
      if (ruleCid != null) 'rule_cid': ruleCid,
      if (title != null) 'title': title,
      if (easyPosition != null) 'easy_position': easyPosition,
    });
  }

  PnMemorysCompanion copyWith(
      {Value<int>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? ruleId,
      Value<int?>? ruleCid,
      Value<String>? title,
      Value<String?>? easyPosition}) {
    return PnMemorysCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ruleId: ruleId ?? this.ruleId,
      ruleCid: ruleCid ?? this.ruleCid,
      title: title ?? this.title,
      easyPosition: easyPosition ?? this.easyPosition,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int>(cloudId.value);
    }
    if (syncCurd.present) {
      map['sync_curd'] = Variable<int?>(syncCurd.value);
    }
    if (syncUpdateColumns.present) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int?>(ruleId.value);
    }
    if (ruleCid.present) {
      map['rule_cid'] = Variable<int?>(ruleCid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (easyPosition.present) {
      map['easy_position'] = Variable<String?>(easyPosition.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PnMemorysCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title, ')
          ..write('easyPosition: $easyPosition')
          ..write(')'))
        .toString();
  }
}

class $PnMemorysTable extends PnMemorys
    with TableInfo<$PnMemorysTable, PnMemory> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PnMemorysTable(this._db, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _syncCurdMeta = const VerificationMeta('syncCurd');
  @override
  late final GeneratedColumn<int?> syncCurd = GeneratedColumn<int?>(
      'sync_curd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncUpdateColumnsMeta =
      const VerificationMeta('syncUpdateColumns');
  @override
  late final GeneratedColumn<String?> syncUpdateColumns =
      GeneratedColumn<String?>('sync_update_columns', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int?> ruleId = GeneratedColumn<int?>(
      'rule_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _ruleCidMeta = const VerificationMeta('ruleCid');
  @override
  late final GeneratedColumn<int?> ruleCid = GeneratedColumn<int?>(
      'rule_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('未命名'));
  final VerificationMeta _easyPositionMeta =
      const VerificationMeta('easyPosition');
  @override
  late final GeneratedColumn<String?> easyPosition = GeneratedColumn<String?>(
      'easy_position', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        ruleId,
        ruleCid,
        title,
        easyPosition
      ];
  @override
  String get aliasedName => _alias ?? 'pn_memorys';
  @override
  String get actualTableName => 'pn_memorys';
  @override
  VerificationContext validateIntegrity(Insertable<PnMemory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
    } else if (isInserting) {
      context.missing(_cloudIdMeta);
    }
    if (data.containsKey('sync_curd')) {
      context.handle(_syncCurdMeta,
          syncCurd.isAcceptableOrUnknown(data['sync_curd']!, _syncCurdMeta));
    }
    if (data.containsKey('sync_update_columns')) {
      context.handle(
          _syncUpdateColumnsMeta,
          syncUpdateColumns.isAcceptableOrUnknown(
              data['sync_update_columns']!, _syncUpdateColumnsMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    }
    if (data.containsKey('rule_cid')) {
      context.handle(_ruleCidMeta,
          ruleCid.isAcceptableOrUnknown(data['rule_cid']!, _ruleCidMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('easy_position')) {
      context.handle(
          _easyPositionMeta,
          easyPosition.isAcceptableOrUnknown(
              data['easy_position']!, _easyPositionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PnMemory map(Map<String, dynamic> data, {String? tablePrefix}) {
    return PnMemory.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PnMemorysTable createAlias(String alias) {
    return $PnMemorysTable(_db, alias);
  }
}

class FRule extends DataClass implements Insertable<FRule> {
  /// 可空。
  final int cloudId;

  /// 同步 curd 类型。为空则表示该行不需要进行同步。
  ///
  /// 值： null C-0 U-1 R-2 D-3
  ///
  /// 不为 null 的可能性：
  ///   1. 未上传更改。
  ///   2. 客户端上传数据后，客户端被断掉，从而未对服务器上传成功的消息进行接收。（若是服务器断掉，则客户端会收到失败的响应）
  ///
  /// 若客户端请求——服务器响应，这个流程成功则设为 null，失败则保持为 curd。
  /// 若为 2 的情况，应用会再次检索未上传的数据，再次进行上传，但无碍，因为服务端上传时，会对比 updatedAt。
  ///   - 若新旧相同，则服务端已同步过，响应客户端将其置空。
  ///   - 若新的晚于旧的，则需要服务端进行同步后，响应客户端将其置空。
  ///   - 若新的早于旧的，则 1. 可能客户端、服务端时间被篡改；2. 该条数据在其他客户端已经被同步过了 TODO: 可依据此处设计多客户端登陆方案。
  final int? syncCurd;

  /// 当 [syncCurd] 为 U-1 时，[syncUpdateColumns] 不能为空。
  ///
  /// 值为字段名，如："username,password"。
  final String? syncUpdateColumns;
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? fatherRuleId;
  final int? fatherRuleCid;
  final int? nodeId;
  final int? nodeCid;
  final String title;
  FRule(
      {required this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.fatherRuleId,
      this.fatherRuleCid,
      this.nodeId,
      this.nodeCid,
      required this.title});
  factory FRule.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FRule(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id'])!,
      syncCurd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sync_curd']),
      syncUpdateColumns: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sync_update_columns']),
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      fatherRuleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}father_rule_id']),
      fatherRuleCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}father_rule_cid']),
      nodeId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_id']),
      nodeCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_cid']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cloud_id'] = Variable<int>(cloudId);
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || fatherRuleId != null) {
      map['father_rule_id'] = Variable<int?>(fatherRuleId);
    }
    if (!nullToAbsent || fatherRuleCid != null) {
      map['father_rule_cid'] = Variable<int?>(fatherRuleCid);
    }
    if (!nullToAbsent || nodeId != null) {
      map['node_id'] = Variable<int?>(nodeId);
    }
    if (!nullToAbsent || nodeCid != null) {
      map['node_cid'] = Variable<int?>(nodeCid);
    }
    map['title'] = Variable<String>(title);
    return map;
  }

  FRulesCompanion toCompanion(bool nullToAbsent) {
    return FRulesCompanion(
      cloudId: Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fatherRuleId: fatherRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherRuleId),
      fatherRuleCid: fatherRuleCid == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherRuleCid),
      nodeId:
          nodeId == null && nullToAbsent ? const Value.absent() : Value(nodeId),
      nodeCid: nodeCid == null && nullToAbsent
          ? const Value.absent()
          : Value(nodeCid),
      title: Value(title),
    );
  }

  factory FRule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FRule(
      cloudId: serializer.fromJson<int>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      fatherRuleId: serializer.fromJson<int?>(json['fatherRuleId']),
      fatherRuleCid: serializer.fromJson<int?>(json['fatherRuleCid']),
      nodeId: serializer.fromJson<int?>(json['nodeId']),
      nodeCid: serializer.fromJson<int?>(json['nodeCid']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'fatherRuleId': serializer.toJson<int?>(fatherRuleId),
      'fatherRuleCid': serializer.toJson<int?>(fatherRuleCid),
      'nodeId': serializer.toJson<int?>(nodeId),
      'nodeCid': serializer.toJson<int?>(nodeCid),
      'title': serializer.toJson<String>(title),
    };
  }

  FRule copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? fatherRuleId,
          int? fatherRuleCid,
          int? nodeId,
          int? nodeCid,
          String? title}) =>
      FRule(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        fatherRuleId: fatherRuleId ?? this.fatherRuleId,
        fatherRuleCid: fatherRuleCid ?? this.fatherRuleCid,
        nodeId: nodeId ?? this.nodeId,
        nodeCid: nodeCid ?? this.nodeCid,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('FRule(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fatherRuleId: $fatherRuleId, ')
          ..write('fatherRuleCid: $fatherRuleCid, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeCid: $nodeCid, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cloudId,
      syncCurd,
      syncUpdateColumns,
      id,
      createdAt,
      updatedAt,
      fatherRuleId,
      fatherRuleCid,
      nodeId,
      nodeCid,
      title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FRule &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fatherRuleId == this.fatherRuleId &&
          other.fatherRuleCid == this.fatherRuleCid &&
          other.nodeId == this.nodeId &&
          other.nodeCid == this.nodeCid &&
          other.title == this.title);
}

class FRulesCompanion extends UpdateCompanion<FRule> {
  final Value<int> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> fatherRuleId;
  final Value<int?> fatherRuleCid;
  final Value<int?> nodeId;
  final Value<int?> nodeCid;
  final Value<String> title;
  const FRulesCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fatherRuleId = const Value.absent(),
    this.fatherRuleCid = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeCid = const Value.absent(),
    this.title = const Value.absent(),
  });
  FRulesCompanion.insert({
    required int cloudId,
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fatherRuleId = const Value.absent(),
    this.fatherRuleCid = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeCid = const Value.absent(),
    this.title = const Value.absent(),
  }) : cloudId = Value(cloudId);
  static Insertable<FRule> custom({
    Expression<int>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? fatherRuleId,
    Expression<int?>? fatherRuleCid,
    Expression<int?>? nodeId,
    Expression<int?>? nodeCid,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fatherRuleId != null) 'father_rule_id': fatherRuleId,
      if (fatherRuleCid != null) 'father_rule_cid': fatherRuleCid,
      if (nodeId != null) 'node_id': nodeId,
      if (nodeCid != null) 'node_cid': nodeCid,
      if (title != null) 'title': title,
    });
  }

  FRulesCompanion copyWith(
      {Value<int>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? fatherRuleId,
      Value<int?>? fatherRuleCid,
      Value<int?>? nodeId,
      Value<int?>? nodeCid,
      Value<String>? title}) {
    return FRulesCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fatherRuleId: fatherRuleId ?? this.fatherRuleId,
      fatherRuleCid: fatherRuleCid ?? this.fatherRuleCid,
      nodeId: nodeId ?? this.nodeId,
      nodeCid: nodeCid ?? this.nodeCid,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int>(cloudId.value);
    }
    if (syncCurd.present) {
      map['sync_curd'] = Variable<int?>(syncCurd.value);
    }
    if (syncUpdateColumns.present) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (fatherRuleId.present) {
      map['father_rule_id'] = Variable<int?>(fatherRuleId.value);
    }
    if (fatherRuleCid.present) {
      map['father_rule_cid'] = Variable<int?>(fatherRuleCid.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int?>(nodeId.value);
    }
    if (nodeCid.present) {
      map['node_cid'] = Variable<int?>(nodeCid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FRulesCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fatherRuleId: $fatherRuleId, ')
          ..write('fatherRuleCid: $fatherRuleCid, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeCid: $nodeCid, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $FRulesTable extends FRules with TableInfo<$FRulesTable, FRule> {
  final GeneratedDatabase _db;
  final String? _alias;
  $FRulesTable(this._db, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _syncCurdMeta = const VerificationMeta('syncCurd');
  @override
  late final GeneratedColumn<int?> syncCurd = GeneratedColumn<int?>(
      'sync_curd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncUpdateColumnsMeta =
      const VerificationMeta('syncUpdateColumns');
  @override
  late final GeneratedColumn<String?> syncUpdateColumns =
      GeneratedColumn<String?>('sync_update_columns', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _fatherRuleIdMeta =
      const VerificationMeta('fatherRuleId');
  @override
  late final GeneratedColumn<int?> fatherRuleId = GeneratedColumn<int?>(
      'father_rule_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fatherRuleCidMeta =
      const VerificationMeta('fatherRuleCid');
  @override
  late final GeneratedColumn<int?> fatherRuleCid = GeneratedColumn<int?>(
      'father_rule_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int?> nodeId = GeneratedColumn<int?>(
      'node_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nodeCidMeta = const VerificationMeta('nodeCid');
  @override
  late final GeneratedColumn<int?> nodeCid = GeneratedColumn<int?>(
      'node_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('未命名'));
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        fatherRuleId,
        fatherRuleCid,
        nodeId,
        nodeCid,
        title
      ];
  @override
  String get aliasedName => _alias ?? 'f_rules';
  @override
  String get actualTableName => 'f_rules';
  @override
  VerificationContext validateIntegrity(Insertable<FRule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
    } else if (isInserting) {
      context.missing(_cloudIdMeta);
    }
    if (data.containsKey('sync_curd')) {
      context.handle(_syncCurdMeta,
          syncCurd.isAcceptableOrUnknown(data['sync_curd']!, _syncCurdMeta));
    }
    if (data.containsKey('sync_update_columns')) {
      context.handle(
          _syncUpdateColumnsMeta,
          syncUpdateColumns.isAcceptableOrUnknown(
              data['sync_update_columns']!, _syncUpdateColumnsMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('father_rule_id')) {
      context.handle(
          _fatherRuleIdMeta,
          fatherRuleId.isAcceptableOrUnknown(
              data['father_rule_id']!, _fatherRuleIdMeta));
    }
    if (data.containsKey('father_rule_cid')) {
      context.handle(
          _fatherRuleCidMeta,
          fatherRuleCid.isAcceptableOrUnknown(
              data['father_rule_cid']!, _fatherRuleCidMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    }
    if (data.containsKey('node_cid')) {
      context.handle(_nodeCidMeta,
          nodeCid.isAcceptableOrUnknown(data['node_cid']!, _nodeCidMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FRule.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FRulesTable createAlias(String alias) {
    return $FRulesTable(_db, alias);
  }
}

class FFragment extends DataClass implements Insertable<FFragment> {
  /// 可空。
  final int cloudId;

  /// 同步 curd 类型。为空则表示该行不需要进行同步。
  ///
  /// 值： null C-0 U-1 R-2 D-3
  ///
  /// 不为 null 的可能性：
  ///   1. 未上传更改。
  ///   2. 客户端上传数据后，客户端被断掉，从而未对服务器上传成功的消息进行接收。（若是服务器断掉，则客户端会收到失败的响应）
  ///
  /// 若客户端请求——服务器响应，这个流程成功则设为 null，失败则保持为 curd。
  /// 若为 2 的情况，应用会再次检索未上传的数据，再次进行上传，但无碍，因为服务端上传时，会对比 updatedAt。
  ///   - 若新旧相同，则服务端已同步过，响应客户端将其置空。
  ///   - 若新的晚于旧的，则需要服务端进行同步后，响应客户端将其置空。
  ///   - 若新的早于旧的，则 1. 可能客户端、服务端时间被篡改；2. 该条数据在其他客户端已经被同步过了 TODO: 可依据此处设计多客户端登陆方案。
  final int? syncCurd;

  /// 当 [syncCurd] 为 U-1 时，[syncUpdateColumns] 不能为空。
  ///
  /// 值为字段名，如："username,password"。
  final String? syncUpdateColumns;
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? fatherFragmentId;
  final int? fatherFragmentCid;
  final int? nodeId;
  final int? nodeCid;
  final int? ruleId;
  final int? ruleCid;
  final String title;
  FFragment(
      {required this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.fatherFragmentId,
      this.fatherFragmentCid,
      this.nodeId,
      this.nodeCid,
      this.ruleId,
      this.ruleCid,
      required this.title});
  factory FFragment.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FFragment(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id'])!,
      syncCurd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sync_curd']),
      syncUpdateColumns: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sync_update_columns']),
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      fatherFragmentId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}father_fragment_id']),
      fatherFragmentCid: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}father_fragment_cid']),
      nodeId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_id']),
      nodeCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_cid']),
      ruleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_id']),
      ruleCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_cid']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cloud_id'] = Variable<int>(cloudId);
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || fatherFragmentId != null) {
      map['father_fragment_id'] = Variable<int?>(fatherFragmentId);
    }
    if (!nullToAbsent || fatherFragmentCid != null) {
      map['father_fragment_cid'] = Variable<int?>(fatherFragmentCid);
    }
    if (!nullToAbsent || nodeId != null) {
      map['node_id'] = Variable<int?>(nodeId);
    }
    if (!nullToAbsent || nodeCid != null) {
      map['node_cid'] = Variable<int?>(nodeCid);
    }
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<int?>(ruleId);
    }
    if (!nullToAbsent || ruleCid != null) {
      map['rule_cid'] = Variable<int?>(ruleCid);
    }
    map['title'] = Variable<String>(title);
    return map;
  }

  FFragmentsCompanion toCompanion(bool nullToAbsent) {
    return FFragmentsCompanion(
      cloudId: Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fatherFragmentId: fatherFragmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherFragmentId),
      fatherFragmentCid: fatherFragmentCid == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherFragmentCid),
      nodeId:
          nodeId == null && nullToAbsent ? const Value.absent() : Value(nodeId),
      nodeCid: nodeCid == null && nullToAbsent
          ? const Value.absent()
          : Value(nodeCid),
      ruleId:
          ruleId == null && nullToAbsent ? const Value.absent() : Value(ruleId),
      ruleCid: ruleCid == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleCid),
      title: Value(title),
    );
  }

  factory FFragment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FFragment(
      cloudId: serializer.fromJson<int>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      fatherFragmentId: serializer.fromJson<int?>(json['fatherFragmentId']),
      fatherFragmentCid: serializer.fromJson<int?>(json['fatherFragmentCid']),
      nodeId: serializer.fromJson<int?>(json['nodeId']),
      nodeCid: serializer.fromJson<int?>(json['nodeCid']),
      ruleId: serializer.fromJson<int?>(json['ruleId']),
      ruleCid: serializer.fromJson<int?>(json['ruleCid']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'fatherFragmentId': serializer.toJson<int?>(fatherFragmentId),
      'fatherFragmentCid': serializer.toJson<int?>(fatherFragmentCid),
      'nodeId': serializer.toJson<int?>(nodeId),
      'nodeCid': serializer.toJson<int?>(nodeCid),
      'ruleId': serializer.toJson<int?>(ruleId),
      'ruleCid': serializer.toJson<int?>(ruleCid),
      'title': serializer.toJson<String>(title),
    };
  }

  FFragment copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? fatherFragmentId,
          int? fatherFragmentCid,
          int? nodeId,
          int? nodeCid,
          int? ruleId,
          int? ruleCid,
          String? title}) =>
      FFragment(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        fatherFragmentId: fatherFragmentId ?? this.fatherFragmentId,
        fatherFragmentCid: fatherFragmentCid ?? this.fatherFragmentCid,
        nodeId: nodeId ?? this.nodeId,
        nodeCid: nodeCid ?? this.nodeCid,
        ruleId: ruleId ?? this.ruleId,
        ruleCid: ruleCid ?? this.ruleCid,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('FFragment(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fatherFragmentId: $fatherFragmentId, ')
          ..write('fatherFragmentCid: $fatherFragmentCid, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeCid: $nodeCid, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cloudId,
      syncCurd,
      syncUpdateColumns,
      id,
      createdAt,
      updatedAt,
      fatherFragmentId,
      fatherFragmentCid,
      nodeId,
      nodeCid,
      ruleId,
      ruleCid,
      title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FFragment &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fatherFragmentId == this.fatherFragmentId &&
          other.fatherFragmentCid == this.fatherFragmentCid &&
          other.nodeId == this.nodeId &&
          other.nodeCid == this.nodeCid &&
          other.ruleId == this.ruleId &&
          other.ruleCid == this.ruleCid &&
          other.title == this.title);
}

class FFragmentsCompanion extends UpdateCompanion<FFragment> {
  final Value<int> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> fatherFragmentId;
  final Value<int?> fatherFragmentCid;
  final Value<int?> nodeId;
  final Value<int?> nodeCid;
  final Value<int?> ruleId;
  final Value<int?> ruleCid;
  final Value<String> title;
  const FFragmentsCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fatherFragmentId = const Value.absent(),
    this.fatherFragmentCid = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeCid = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
  });
  FFragmentsCompanion.insert({
    required int cloudId,
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fatherFragmentId = const Value.absent(),
    this.fatherFragmentCid = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeCid = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
  }) : cloudId = Value(cloudId);
  static Insertable<FFragment> custom({
    Expression<int>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? fatherFragmentId,
    Expression<int?>? fatherFragmentCid,
    Expression<int?>? nodeId,
    Expression<int?>? nodeCid,
    Expression<int?>? ruleId,
    Expression<int?>? ruleCid,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fatherFragmentId != null) 'father_fragment_id': fatherFragmentId,
      if (fatherFragmentCid != null) 'father_fragment_cid': fatherFragmentCid,
      if (nodeId != null) 'node_id': nodeId,
      if (nodeCid != null) 'node_cid': nodeCid,
      if (ruleId != null) 'rule_id': ruleId,
      if (ruleCid != null) 'rule_cid': ruleCid,
      if (title != null) 'title': title,
    });
  }

  FFragmentsCompanion copyWith(
      {Value<int>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? fatherFragmentId,
      Value<int?>? fatherFragmentCid,
      Value<int?>? nodeId,
      Value<int?>? nodeCid,
      Value<int?>? ruleId,
      Value<int?>? ruleCid,
      Value<String>? title}) {
    return FFragmentsCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fatherFragmentId: fatherFragmentId ?? this.fatherFragmentId,
      fatherFragmentCid: fatherFragmentCid ?? this.fatherFragmentCid,
      nodeId: nodeId ?? this.nodeId,
      nodeCid: nodeCid ?? this.nodeCid,
      ruleId: ruleId ?? this.ruleId,
      ruleCid: ruleCid ?? this.ruleCid,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int>(cloudId.value);
    }
    if (syncCurd.present) {
      map['sync_curd'] = Variable<int?>(syncCurd.value);
    }
    if (syncUpdateColumns.present) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (fatherFragmentId.present) {
      map['father_fragment_id'] = Variable<int?>(fatherFragmentId.value);
    }
    if (fatherFragmentCid.present) {
      map['father_fragment_cid'] = Variable<int?>(fatherFragmentCid.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int?>(nodeId.value);
    }
    if (nodeCid.present) {
      map['node_cid'] = Variable<int?>(nodeCid.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int?>(ruleId.value);
    }
    if (ruleCid.present) {
      map['rule_cid'] = Variable<int?>(ruleCid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FFragmentsCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fatherFragmentId: $fatherFragmentId, ')
          ..write('fatherFragmentCid: $fatherFragmentCid, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeCid: $nodeCid, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $FFragmentsTable extends FFragments
    with TableInfo<$FFragmentsTable, FFragment> {
  final GeneratedDatabase _db;
  final String? _alias;
  $FFragmentsTable(this._db, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _syncCurdMeta = const VerificationMeta('syncCurd');
  @override
  late final GeneratedColumn<int?> syncCurd = GeneratedColumn<int?>(
      'sync_curd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncUpdateColumnsMeta =
      const VerificationMeta('syncUpdateColumns');
  @override
  late final GeneratedColumn<String?> syncUpdateColumns =
      GeneratedColumn<String?>('sync_update_columns', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _fatherFragmentIdMeta =
      const VerificationMeta('fatherFragmentId');
  @override
  late final GeneratedColumn<int?> fatherFragmentId = GeneratedColumn<int?>(
      'father_fragment_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fatherFragmentCidMeta =
      const VerificationMeta('fatherFragmentCid');
  @override
  late final GeneratedColumn<int?> fatherFragmentCid = GeneratedColumn<int?>(
      'father_fragment_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int?> nodeId = GeneratedColumn<int?>(
      'node_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nodeCidMeta = const VerificationMeta('nodeCid');
  @override
  late final GeneratedColumn<int?> nodeCid = GeneratedColumn<int?>(
      'node_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int?> ruleId = GeneratedColumn<int?>(
      'rule_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _ruleCidMeta = const VerificationMeta('ruleCid');
  @override
  late final GeneratedColumn<int?> ruleCid = GeneratedColumn<int?>(
      'rule_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('未命名'));
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        fatherFragmentId,
        fatherFragmentCid,
        nodeId,
        nodeCid,
        ruleId,
        ruleCid,
        title
      ];
  @override
  String get aliasedName => _alias ?? 'f_fragments';
  @override
  String get actualTableName => 'f_fragments';
  @override
  VerificationContext validateIntegrity(Insertable<FFragment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
    } else if (isInserting) {
      context.missing(_cloudIdMeta);
    }
    if (data.containsKey('sync_curd')) {
      context.handle(_syncCurdMeta,
          syncCurd.isAcceptableOrUnknown(data['sync_curd']!, _syncCurdMeta));
    }
    if (data.containsKey('sync_update_columns')) {
      context.handle(
          _syncUpdateColumnsMeta,
          syncUpdateColumns.isAcceptableOrUnknown(
              data['sync_update_columns']!, _syncUpdateColumnsMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('father_fragment_id')) {
      context.handle(
          _fatherFragmentIdMeta,
          fatherFragmentId.isAcceptableOrUnknown(
              data['father_fragment_id']!, _fatherFragmentIdMeta));
    }
    if (data.containsKey('father_fragment_cid')) {
      context.handle(
          _fatherFragmentCidMeta,
          fatherFragmentCid.isAcceptableOrUnknown(
              data['father_fragment_cid']!, _fatherFragmentCidMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    }
    if (data.containsKey('node_cid')) {
      context.handle(_nodeCidMeta,
          nodeCid.isAcceptableOrUnknown(data['node_cid']!, _nodeCidMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    }
    if (data.containsKey('rule_cid')) {
      context.handle(_ruleCidMeta,
          ruleCid.isAcceptableOrUnknown(data['rule_cid']!, _ruleCidMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FFragment map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FFragment.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FFragmentsTable createAlias(String alias) {
    return $FFragmentsTable(_db, alias);
  }
}

class FComplete extends DataClass implements Insertable<FComplete> {
  /// 可空。
  final int cloudId;

  /// 同步 curd 类型。为空则表示该行不需要进行同步。
  ///
  /// 值： null C-0 U-1 R-2 D-3
  ///
  /// 不为 null 的可能性：
  ///   1. 未上传更改。
  ///   2. 客户端上传数据后，客户端被断掉，从而未对服务器上传成功的消息进行接收。（若是服务器断掉，则客户端会收到失败的响应）
  ///
  /// 若客户端请求——服务器响应，这个流程成功则设为 null，失败则保持为 curd。
  /// 若为 2 的情况，应用会再次检索未上传的数据，再次进行上传，但无碍，因为服务端上传时，会对比 updatedAt。
  ///   - 若新旧相同，则服务端已同步过，响应客户端将其置空。
  ///   - 若新的晚于旧的，则需要服务端进行同步后，响应客户端将其置空。
  ///   - 若新的早于旧的，则 1. 可能客户端、服务端时间被篡改；2. 该条数据在其他客户端已经被同步过了 TODO: 可依据此处设计多客户端登陆方案。
  final int? syncCurd;

  /// 当 [syncCurd] 为 U-1 时，[syncUpdateColumns] 不能为空。
  ///
  /// 值为字段名，如："username,password"。
  final String? syncUpdateColumns;
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? nodeId;
  final int? nodeCid;
  final int? fragmentId;
  final int? fragmentCid;
  final int? ruleId;
  final int? ruleCid;
  final String title;
  FComplete(
      {required this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.nodeId,
      this.nodeCid,
      this.fragmentId,
      this.fragmentCid,
      this.ruleId,
      this.ruleCid,
      required this.title});
  factory FComplete.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FComplete(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id'])!,
      syncCurd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sync_curd']),
      syncUpdateColumns: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sync_update_columns']),
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      nodeId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_id']),
      nodeCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_cid']),
      fragmentId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_id']),
      fragmentCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_cid']),
      ruleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_id']),
      ruleCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_cid']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cloud_id'] = Variable<int>(cloudId);
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || nodeId != null) {
      map['node_id'] = Variable<int?>(nodeId);
    }
    if (!nullToAbsent || nodeCid != null) {
      map['node_cid'] = Variable<int?>(nodeCid);
    }
    if (!nullToAbsent || fragmentId != null) {
      map['fragment_id'] = Variable<int?>(fragmentId);
    }
    if (!nullToAbsent || fragmentCid != null) {
      map['fragment_cid'] = Variable<int?>(fragmentCid);
    }
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<int?>(ruleId);
    }
    if (!nullToAbsent || ruleCid != null) {
      map['rule_cid'] = Variable<int?>(ruleCid);
    }
    map['title'] = Variable<String>(title);
    return map;
  }

  FCompletesCompanion toCompanion(bool nullToAbsent) {
    return FCompletesCompanion(
      cloudId: Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      nodeId:
          nodeId == null && nullToAbsent ? const Value.absent() : Value(nodeId),
      nodeCid: nodeCid == null && nullToAbsent
          ? const Value.absent()
          : Value(nodeCid),
      fragmentId: fragmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentId),
      fragmentCid: fragmentCid == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentCid),
      ruleId:
          ruleId == null && nullToAbsent ? const Value.absent() : Value(ruleId),
      ruleCid: ruleCid == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleCid),
      title: Value(title),
    );
  }

  factory FComplete.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FComplete(
      cloudId: serializer.fromJson<int>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      nodeId: serializer.fromJson<int?>(json['nodeId']),
      nodeCid: serializer.fromJson<int?>(json['nodeCid']),
      fragmentId: serializer.fromJson<int?>(json['fragmentId']),
      fragmentCid: serializer.fromJson<int?>(json['fragmentCid']),
      ruleId: serializer.fromJson<int?>(json['ruleId']),
      ruleCid: serializer.fromJson<int?>(json['ruleCid']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'nodeId': serializer.toJson<int?>(nodeId),
      'nodeCid': serializer.toJson<int?>(nodeCid),
      'fragmentId': serializer.toJson<int?>(fragmentId),
      'fragmentCid': serializer.toJson<int?>(fragmentCid),
      'ruleId': serializer.toJson<int?>(ruleId),
      'ruleCid': serializer.toJson<int?>(ruleCid),
      'title': serializer.toJson<String>(title),
    };
  }

  FComplete copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? nodeId,
          int? nodeCid,
          int? fragmentId,
          int? fragmentCid,
          int? ruleId,
          int? ruleCid,
          String? title}) =>
      FComplete(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        nodeId: nodeId ?? this.nodeId,
        nodeCid: nodeCid ?? this.nodeCid,
        fragmentId: fragmentId ?? this.fragmentId,
        fragmentCid: fragmentCid ?? this.fragmentCid,
        ruleId: ruleId ?? this.ruleId,
        ruleCid: ruleCid ?? this.ruleCid,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('FComplete(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeCid: $nodeCid, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCid: $fragmentCid, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cloudId,
      syncCurd,
      syncUpdateColumns,
      id,
      createdAt,
      updatedAt,
      nodeId,
      nodeCid,
      fragmentId,
      fragmentCid,
      ruleId,
      ruleCid,
      title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FComplete &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.nodeId == this.nodeId &&
          other.nodeCid == this.nodeCid &&
          other.fragmentId == this.fragmentId &&
          other.fragmentCid == this.fragmentCid &&
          other.ruleId == this.ruleId &&
          other.ruleCid == this.ruleCid &&
          other.title == this.title);
}

class FCompletesCompanion extends UpdateCompanion<FComplete> {
  final Value<int> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> nodeId;
  final Value<int?> nodeCid;
  final Value<int?> fragmentId;
  final Value<int?> fragmentCid;
  final Value<int?> ruleId;
  final Value<int?> ruleCid;
  final Value<String> title;
  const FCompletesCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeCid = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCid = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
  });
  FCompletesCompanion.insert({
    required int cloudId,
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeCid = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCid = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
  }) : cloudId = Value(cloudId);
  static Insertable<FComplete> custom({
    Expression<int>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? nodeId,
    Expression<int?>? nodeCid,
    Expression<int?>? fragmentId,
    Expression<int?>? fragmentCid,
    Expression<int?>? ruleId,
    Expression<int?>? ruleCid,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (nodeId != null) 'node_id': nodeId,
      if (nodeCid != null) 'node_cid': nodeCid,
      if (fragmentId != null) 'fragment_id': fragmentId,
      if (fragmentCid != null) 'fragment_cid': fragmentCid,
      if (ruleId != null) 'rule_id': ruleId,
      if (ruleCid != null) 'rule_cid': ruleCid,
      if (title != null) 'title': title,
    });
  }

  FCompletesCompanion copyWith(
      {Value<int>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? nodeId,
      Value<int?>? nodeCid,
      Value<int?>? fragmentId,
      Value<int?>? fragmentCid,
      Value<int?>? ruleId,
      Value<int?>? ruleCid,
      Value<String>? title}) {
    return FCompletesCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nodeId: nodeId ?? this.nodeId,
      nodeCid: nodeCid ?? this.nodeCid,
      fragmentId: fragmentId ?? this.fragmentId,
      fragmentCid: fragmentCid ?? this.fragmentCid,
      ruleId: ruleId ?? this.ruleId,
      ruleCid: ruleCid ?? this.ruleCid,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int>(cloudId.value);
    }
    if (syncCurd.present) {
      map['sync_curd'] = Variable<int?>(syncCurd.value);
    }
    if (syncUpdateColumns.present) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int?>(nodeId.value);
    }
    if (nodeCid.present) {
      map['node_cid'] = Variable<int?>(nodeCid.value);
    }
    if (fragmentId.present) {
      map['fragment_id'] = Variable<int?>(fragmentId.value);
    }
    if (fragmentCid.present) {
      map['fragment_cid'] = Variable<int?>(fragmentCid.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int?>(ruleId.value);
    }
    if (ruleCid.present) {
      map['rule_cid'] = Variable<int?>(ruleCid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FCompletesCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeCid: $nodeCid, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCid: $fragmentCid, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $FCompletesTable extends FCompletes
    with TableInfo<$FCompletesTable, FComplete> {
  final GeneratedDatabase _db;
  final String? _alias;
  $FCompletesTable(this._db, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _syncCurdMeta = const VerificationMeta('syncCurd');
  @override
  late final GeneratedColumn<int?> syncCurd = GeneratedColumn<int?>(
      'sync_curd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncUpdateColumnsMeta =
      const VerificationMeta('syncUpdateColumns');
  @override
  late final GeneratedColumn<String?> syncUpdateColumns =
      GeneratedColumn<String?>('sync_update_columns', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int?> nodeId = GeneratedColumn<int?>(
      'node_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nodeCidMeta = const VerificationMeta('nodeCid');
  @override
  late final GeneratedColumn<int?> nodeCid = GeneratedColumn<int?>(
      'node_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentIdMeta = const VerificationMeta('fragmentId');
  @override
  late final GeneratedColumn<int?> fragmentId = GeneratedColumn<int?>(
      'fragment_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentCidMeta =
      const VerificationMeta('fragmentCid');
  @override
  late final GeneratedColumn<int?> fragmentCid = GeneratedColumn<int?>(
      'fragment_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int?> ruleId = GeneratedColumn<int?>(
      'rule_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _ruleCidMeta = const VerificationMeta('ruleCid');
  @override
  late final GeneratedColumn<int?> ruleCid = GeneratedColumn<int?>(
      'rule_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('未命名'));
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        nodeId,
        nodeCid,
        fragmentId,
        fragmentCid,
        ruleId,
        ruleCid,
        title
      ];
  @override
  String get aliasedName => _alias ?? 'f_completes';
  @override
  String get actualTableName => 'f_completes';
  @override
  VerificationContext validateIntegrity(Insertable<FComplete> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
    } else if (isInserting) {
      context.missing(_cloudIdMeta);
    }
    if (data.containsKey('sync_curd')) {
      context.handle(_syncCurdMeta,
          syncCurd.isAcceptableOrUnknown(data['sync_curd']!, _syncCurdMeta));
    }
    if (data.containsKey('sync_update_columns')) {
      context.handle(
          _syncUpdateColumnsMeta,
          syncUpdateColumns.isAcceptableOrUnknown(
              data['sync_update_columns']!, _syncUpdateColumnsMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    }
    if (data.containsKey('node_cid')) {
      context.handle(_nodeCidMeta,
          nodeCid.isAcceptableOrUnknown(data['node_cid']!, _nodeCidMeta));
    }
    if (data.containsKey('fragment_id')) {
      context.handle(
          _fragmentIdMeta,
          fragmentId.isAcceptableOrUnknown(
              data['fragment_id']!, _fragmentIdMeta));
    }
    if (data.containsKey('fragment_cid')) {
      context.handle(
          _fragmentCidMeta,
          fragmentCid.isAcceptableOrUnknown(
              data['fragment_cid']!, _fragmentCidMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    }
    if (data.containsKey('rule_cid')) {
      context.handle(_ruleCidMeta,
          ruleCid.isAcceptableOrUnknown(data['rule_cid']!, _ruleCidMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FComplete map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FComplete.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FCompletesTable createAlias(String alias) {
    return $FCompletesTable(_db, alias);
  }
}

class FMemory extends DataClass implements Insertable<FMemory> {
  /// 可空。
  final int cloudId;

  /// 同步 curd 类型。为空则表示该行不需要进行同步。
  ///
  /// 值： null C-0 U-1 R-2 D-3
  ///
  /// 不为 null 的可能性：
  ///   1. 未上传更改。
  ///   2. 客户端上传数据后，客户端被断掉，从而未对服务器上传成功的消息进行接收。（若是服务器断掉，则客户端会收到失败的响应）
  ///
  /// 若客户端请求——服务器响应，这个流程成功则设为 null，失败则保持为 curd。
  /// 若为 2 的情况，应用会再次检索未上传的数据，再次进行上传，但无碍，因为服务端上传时，会对比 updatedAt。
  ///   - 若新旧相同，则服务端已同步过，响应客户端将其置空。
  ///   - 若新的晚于旧的，则需要服务端进行同步后，响应客户端将其置空。
  ///   - 若新的早于旧的，则 1. 可能客户端、服务端时间被篡改；2. 该条数据在其他客户端已经被同步过了 TODO: 可依据此处设计多客户端登陆方案。
  final int? syncCurd;

  /// 当 [syncCurd] 为 U-1 时，[syncUpdateColumns] 不能为空。
  ///
  /// 值为字段名，如："username,password"。
  final String? syncUpdateColumns;
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? nodeId;
  final int? nodeCid;
  final int? fragmentId;
  final int? fragmentCid;
  final int? ruleId;
  final int? ruleCid;
  final String title;
  FMemory(
      {required this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.nodeId,
      this.nodeCid,
      this.fragmentId,
      this.fragmentCid,
      this.ruleId,
      this.ruleCid,
      required this.title});
  factory FMemory.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FMemory(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id'])!,
      syncCurd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sync_curd']),
      syncUpdateColumns: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}sync_update_columns']),
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      nodeId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_id']),
      nodeCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}node_cid']),
      fragmentId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_id']),
      fragmentCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_cid']),
      ruleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_id']),
      ruleCid: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rule_cid']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cloud_id'] = Variable<int>(cloudId);
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || nodeId != null) {
      map['node_id'] = Variable<int?>(nodeId);
    }
    if (!nullToAbsent || nodeCid != null) {
      map['node_cid'] = Variable<int?>(nodeCid);
    }
    if (!nullToAbsent || fragmentId != null) {
      map['fragment_id'] = Variable<int?>(fragmentId);
    }
    if (!nullToAbsent || fragmentCid != null) {
      map['fragment_cid'] = Variable<int?>(fragmentCid);
    }
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<int?>(ruleId);
    }
    if (!nullToAbsent || ruleCid != null) {
      map['rule_cid'] = Variable<int?>(ruleCid);
    }
    map['title'] = Variable<String>(title);
    return map;
  }

  FMemorysCompanion toCompanion(bool nullToAbsent) {
    return FMemorysCompanion(
      cloudId: Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      nodeId:
          nodeId == null && nullToAbsent ? const Value.absent() : Value(nodeId),
      nodeCid: nodeCid == null && nullToAbsent
          ? const Value.absent()
          : Value(nodeCid),
      fragmentId: fragmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentId),
      fragmentCid: fragmentCid == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentCid),
      ruleId:
          ruleId == null && nullToAbsent ? const Value.absent() : Value(ruleId),
      ruleCid: ruleCid == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleCid),
      title: Value(title),
    );
  }

  factory FMemory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FMemory(
      cloudId: serializer.fromJson<int>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      nodeId: serializer.fromJson<int?>(json['nodeId']),
      nodeCid: serializer.fromJson<int?>(json['nodeCid']),
      fragmentId: serializer.fromJson<int?>(json['fragmentId']),
      fragmentCid: serializer.fromJson<int?>(json['fragmentCid']),
      ruleId: serializer.fromJson<int?>(json['ruleId']),
      ruleCid: serializer.fromJson<int?>(json['ruleCid']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'nodeId': serializer.toJson<int?>(nodeId),
      'nodeCid': serializer.toJson<int?>(nodeCid),
      'fragmentId': serializer.toJson<int?>(fragmentId),
      'fragmentCid': serializer.toJson<int?>(fragmentCid),
      'ruleId': serializer.toJson<int?>(ruleId),
      'ruleCid': serializer.toJson<int?>(ruleCid),
      'title': serializer.toJson<String>(title),
    };
  }

  FMemory copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? nodeId,
          int? nodeCid,
          int? fragmentId,
          int? fragmentCid,
          int? ruleId,
          int? ruleCid,
          String? title}) =>
      FMemory(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        nodeId: nodeId ?? this.nodeId,
        nodeCid: nodeCid ?? this.nodeCid,
        fragmentId: fragmentId ?? this.fragmentId,
        fragmentCid: fragmentCid ?? this.fragmentCid,
        ruleId: ruleId ?? this.ruleId,
        ruleCid: ruleCid ?? this.ruleCid,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('FMemory(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeCid: $nodeCid, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCid: $fragmentCid, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cloudId,
      syncCurd,
      syncUpdateColumns,
      id,
      createdAt,
      updatedAt,
      nodeId,
      nodeCid,
      fragmentId,
      fragmentCid,
      ruleId,
      ruleCid,
      title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FMemory &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.nodeId == this.nodeId &&
          other.nodeCid == this.nodeCid &&
          other.fragmentId == this.fragmentId &&
          other.fragmentCid == this.fragmentCid &&
          other.ruleId == this.ruleId &&
          other.ruleCid == this.ruleCid &&
          other.title == this.title);
}

class FMemorysCompanion extends UpdateCompanion<FMemory> {
  final Value<int> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> nodeId;
  final Value<int?> nodeCid;
  final Value<int?> fragmentId;
  final Value<int?> fragmentCid;
  final Value<int?> ruleId;
  final Value<int?> ruleCid;
  final Value<String> title;
  const FMemorysCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeCid = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCid = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
  });
  FMemorysCompanion.insert({
    required int cloudId,
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.nodeCid = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCid = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleCid = const Value.absent(),
    this.title = const Value.absent(),
  }) : cloudId = Value(cloudId);
  static Insertable<FMemory> custom({
    Expression<int>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? nodeId,
    Expression<int?>? nodeCid,
    Expression<int?>? fragmentId,
    Expression<int?>? fragmentCid,
    Expression<int?>? ruleId,
    Expression<int?>? ruleCid,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (nodeId != null) 'node_id': nodeId,
      if (nodeCid != null) 'node_cid': nodeCid,
      if (fragmentId != null) 'fragment_id': fragmentId,
      if (fragmentCid != null) 'fragment_cid': fragmentCid,
      if (ruleId != null) 'rule_id': ruleId,
      if (ruleCid != null) 'rule_cid': ruleCid,
      if (title != null) 'title': title,
    });
  }

  FMemorysCompanion copyWith(
      {Value<int>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? nodeId,
      Value<int?>? nodeCid,
      Value<int?>? fragmentId,
      Value<int?>? fragmentCid,
      Value<int?>? ruleId,
      Value<int?>? ruleCid,
      Value<String>? title}) {
    return FMemorysCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nodeId: nodeId ?? this.nodeId,
      nodeCid: nodeCid ?? this.nodeCid,
      fragmentId: fragmentId ?? this.fragmentId,
      fragmentCid: fragmentCid ?? this.fragmentCid,
      ruleId: ruleId ?? this.ruleId,
      ruleCid: ruleCid ?? this.ruleCid,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int>(cloudId.value);
    }
    if (syncCurd.present) {
      map['sync_curd'] = Variable<int?>(syncCurd.value);
    }
    if (syncUpdateColumns.present) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<int?>(nodeId.value);
    }
    if (nodeCid.present) {
      map['node_cid'] = Variable<int?>(nodeCid.value);
    }
    if (fragmentId.present) {
      map['fragment_id'] = Variable<int?>(fragmentId.value);
    }
    if (fragmentCid.present) {
      map['fragment_cid'] = Variable<int?>(fragmentCid.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<int?>(ruleId.value);
    }
    if (ruleCid.present) {
      map['rule_cid'] = Variable<int?>(ruleCid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FMemorysCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('nodeId: $nodeId, ')
          ..write('nodeCid: $nodeCid, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCid: $fragmentCid, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleCid: $ruleCid, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $FMemorysTable extends FMemorys with TableInfo<$FMemorysTable, FMemory> {
  final GeneratedDatabase _db;
  final String? _alias;
  $FMemorysTable(this._db, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _syncCurdMeta = const VerificationMeta('syncCurd');
  @override
  late final GeneratedColumn<int?> syncCurd = GeneratedColumn<int?>(
      'sync_curd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _syncUpdateColumnsMeta =
      const VerificationMeta('syncUpdateColumns');
  @override
  late final GeneratedColumn<String?> syncUpdateColumns =
      GeneratedColumn<String?>('sync_update_columns', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  final VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<int?> nodeId = GeneratedColumn<int?>(
      'node_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nodeCidMeta = const VerificationMeta('nodeCid');
  @override
  late final GeneratedColumn<int?> nodeCid = GeneratedColumn<int?>(
      'node_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentIdMeta = const VerificationMeta('fragmentId');
  @override
  late final GeneratedColumn<int?> fragmentId = GeneratedColumn<int?>(
      'fragment_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentCidMeta =
      const VerificationMeta('fragmentCid');
  @override
  late final GeneratedColumn<int?> fragmentCid = GeneratedColumn<int?>(
      'fragment_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int?> ruleId = GeneratedColumn<int?>(
      'rule_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _ruleCidMeta = const VerificationMeta('ruleCid');
  @override
  late final GeneratedColumn<int?> ruleCid = GeneratedColumn<int?>(
      'rule_cid', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: false,
      defaultValue: const Constant('未命名'));
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        nodeId,
        nodeCid,
        fragmentId,
        fragmentCid,
        ruleId,
        ruleCid,
        title
      ];
  @override
  String get aliasedName => _alias ?? 'f_memorys';
  @override
  String get actualTableName => 'f_memorys';
  @override
  VerificationContext validateIntegrity(Insertable<FMemory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
    } else if (isInserting) {
      context.missing(_cloudIdMeta);
    }
    if (data.containsKey('sync_curd')) {
      context.handle(_syncCurdMeta,
          syncCurd.isAcceptableOrUnknown(data['sync_curd']!, _syncCurdMeta));
    }
    if (data.containsKey('sync_update_columns')) {
      context.handle(
          _syncUpdateColumnsMeta,
          syncUpdateColumns.isAcceptableOrUnknown(
              data['sync_update_columns']!, _syncUpdateColumnsMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('node_id')) {
      context.handle(_nodeIdMeta,
          nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta));
    }
    if (data.containsKey('node_cid')) {
      context.handle(_nodeCidMeta,
          nodeCid.isAcceptableOrUnknown(data['node_cid']!, _nodeCidMeta));
    }
    if (data.containsKey('fragment_id')) {
      context.handle(
          _fragmentIdMeta,
          fragmentId.isAcceptableOrUnknown(
              data['fragment_id']!, _fragmentIdMeta));
    }
    if (data.containsKey('fragment_cid')) {
      context.handle(
          _fragmentCidMeta,
          fragmentCid.isAcceptableOrUnknown(
              data['fragment_cid']!, _fragmentCidMeta));
    }
    if (data.containsKey('rule_id')) {
      context.handle(_ruleIdMeta,
          ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta));
    }
    if (data.containsKey('rule_cid')) {
      context.handle(_ruleCidMeta,
          ruleCid.isAcceptableOrUnknown(data['rule_cid']!, _ruleCidMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FMemory map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FMemory.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FMemorysTable createAlias(String alias) {
    return $FMemorysTable(_db, alias);
  }
}

abstract class _$DriftDb extends GeneratedDatabase {
  _$DriftDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $AppVersionInfosTable appVersionInfos =
      $AppVersionInfosTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PnRulesTable pnRules = $PnRulesTable(this);
  late final $PnCompletesTable pnCompletes = $PnCompletesTable(this);
  late final $PnFragmentsTable pnFragments = $PnFragmentsTable(this);
  late final $PnMemorysTable pnMemorys = $PnMemorysTable(this);
  late final $FRulesTable fRules = $FRulesTable(this);
  late final $FFragmentsTable fFragments = $FFragmentsTable(this);
  late final $FCompletesTable fCompletes = $FCompletesTable(this);
  late final $FMemorysTable fMemorys = $FMemorysTable(this);
  late final EasyDAO easyDAO = EasyDAO(this as DriftDb);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        appVersionInfos,
        users,
        pnRules,
        pnCompletes,
        pnFragments,
        pnMemorys,
        fRules,
        fFragments,
        fCompletes,
        fMemorys
      ];
}
