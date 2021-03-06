// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'DriftDb.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class AppInfo extends DataClass implements Insertable<AppInfo> {
  final int id;

  /// 必须是本地时间，不可空。
  final DateTime createdAt;
  final DateTime updatedAt;
  final String savedAppVersion;
  AppInfo(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.savedAppVersion});
  factory AppInfo.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return AppInfo(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
      savedAppVersion: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}saved_app_version'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['saved_app_version'] = Variable<String>(savedAppVersion);
    return map;
  }

  AppInfosCompanion toCompanion(bool nullToAbsent) {
    return AppInfosCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      savedAppVersion: Value(savedAppVersion),
    );
  }

  factory AppInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppInfo(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      savedAppVersion: serializer.fromJson<String>(json['savedAppVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'savedAppVersion': serializer.toJson<String>(savedAppVersion),
    };
  }

  AppInfo copyWith(
          {int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? savedAppVersion}) =>
      AppInfo(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        savedAppVersion: savedAppVersion ?? this.savedAppVersion,
      );
  @override
  String toString() {
    return (StringBuffer('AppInfo(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('savedAppVersion: $savedAppVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, savedAppVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppInfo &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.savedAppVersion == this.savedAppVersion);
}

class AppInfosCompanion extends UpdateCompanion<AppInfo> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> savedAppVersion;
  const AppInfosCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.savedAppVersion = const Value.absent(),
  });
  AppInfosCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String savedAppVersion,
  }) : savedAppVersion = Value(savedAppVersion);
  static Insertable<AppInfo> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? savedAppVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (savedAppVersion != null) 'saved_app_version': savedAppVersion,
    });
  }

  AppInfosCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? savedAppVersion}) {
    return AppInfosCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      savedAppVersion: savedAppVersion ?? this.savedAppVersion,
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
    if (savedAppVersion.present) {
      map['saved_app_version'] = Variable<String>(savedAppVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppInfosCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('savedAppVersion: $savedAppVersion')
          ..write(')'))
        .toString();
  }
}

class $AppInfosTable extends AppInfos with TableInfo<$AppInfosTable, AppInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppInfosTable(this.attachedDatabase, [this._alias]);
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
  final VerificationMeta _savedAppVersionMeta =
      const VerificationMeta('savedAppVersion');
  @override
  late final GeneratedColumn<String?> savedAppVersion =
      GeneratedColumn<String?>('saved_app_version', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, updatedAt, savedAppVersion];
  @override
  String get aliasedName => _alias ?? 'app_infos';
  @override
  String get actualTableName => 'app_infos';
  @override
  VerificationContext validateIntegrity(Insertable<AppInfo> instance,
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
    if (data.containsKey('saved_app_version')) {
      context.handle(
          _savedAppVersionMeta,
          savedAppVersion.isAcceptableOrUnknown(
              data['saved_app_version']!, _savedAppVersionMeta));
    } else if (isInserting) {
      context.missing(_savedAppVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    return AppInfo.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AppInfosTable createAlias(String alias) {
    return $AppInfosTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  /// 可空。
  final int? cloudId;

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
      {this.cloudId,
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
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id']),
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
    if (!nullToAbsent || cloudId != null) {
      map['cloud_id'] = Variable<int?>(cloudId);
    }
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
      cloudId: cloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudId),
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
      cloudId: serializer.fromJson<int?>(json['cloudId']),
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
      'cloudId': serializer.toJson<int?>(cloudId),
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
  final Value<int?> cloudId;
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
    required String token,
    this.isDownloadedInitData = const Value.absent(),
  }) : token = Value(token);
  static Insertable<User> custom({
    Expression<int?>? cloudId,
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
      {Value<int?>? cloudId,
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
      map['cloud_id'] = Variable<int?>(cloudId.value);
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
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
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
      defaultValue: const Constant('还没名字'));
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
    return $UsersTable(attachedDatabase, alias);
  }
}

class Folder extends DataClass implements Insertable<Folder> {
  /// 可空。
  final int? cloudId;

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
  final String? title;
  Folder(
      {this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.title});
  factory Folder.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Folder(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id']),
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
          .mapFromDatabaseResponse(data['${effectivePrefix}title']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || cloudId != null) {
      map['cloud_id'] = Variable<int?>(cloudId);
    }
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String?>(title);
    }
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      cloudId: cloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      cloudId: serializer.fromJson<int?>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      title: serializer.fromJson<String?>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int?>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'title': serializer.toJson<String?>(title),
    };
  }

  Folder copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? title}) =>
      Folder(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cloudId, syncCurd, syncUpdateColumns, id, createdAt, updatedAt, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.title == this.title);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<int?> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> title;
  const FoldersCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
  });
  static Insertable<Folder> custom({
    Expression<int?>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String?>? title,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (title != null) 'title': title,
    });
  }

  FoldersCompanion copyWith(
      {Value<int?>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? title}) {
    return FoldersCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int?>(cloudId.value);
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
      map['title'] = Variable<String?>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
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
      'title', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [cloudId, syncCurd, syncUpdateColumns, id, createdAt, updatedAt, title];
  @override
  String get aliasedName => _alias ?? 'folders';
  @override
  String get actualTableName => 'folders';
  @override
  VerificationContext validateIntegrity(Insertable<Folder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Folder.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class Fragment extends DataClass implements Insertable<Fragment> {
  /// 可空。
  final int? cloudId;

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
  final String? question;
  final String? answer;
  final String? description;
  Fragment(
      {this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.question,
      this.answer,
      this.description});
  factory Fragment.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Fragment(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id']),
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
      question: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}question']),
      answer: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}answer']),
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || cloudId != null) {
      map['cloud_id'] = Variable<int?>(cloudId);
    }
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || question != null) {
      map['question'] = Variable<String?>(question);
    }
    if (!nullToAbsent || answer != null) {
      map['answer'] = Variable<String?>(answer);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String?>(description);
    }
    return map;
  }

  FragmentsCompanion toCompanion(bool nullToAbsent) {
    return FragmentsCompanion(
      cloudId: cloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      question: question == null && nullToAbsent
          ? const Value.absent()
          : Value(question),
      answer:
          answer == null && nullToAbsent ? const Value.absent() : Value(answer),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Fragment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Fragment(
      cloudId: serializer.fromJson<int?>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      question: serializer.fromJson<String?>(json['question']),
      answer: serializer.fromJson<String?>(json['answer']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int?>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'question': serializer.toJson<String?>(question),
      'answer': serializer.toJson<String?>(answer),
      'description': serializer.toJson<String?>(description),
    };
  }

  Fragment copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? question,
          String? answer,
          String? description}) =>
      Fragment(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Fragment(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cloudId, syncCurd, syncUpdateColumns, id,
      createdAt, updatedAt, question, answer, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Fragment &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.description == this.description);
}

class FragmentsCompanion extends UpdateCompanion<Fragment> {
  final Value<int?> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> question;
  final Value<String?> answer;
  final Value<String?> description;
  const FragmentsCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.description = const Value.absent(),
  });
  FragmentsCompanion.insert({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.description = const Value.absent(),
  });
  static Insertable<Fragment> custom({
    Expression<int?>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String?>? question,
    Expression<String?>? answer,
    Expression<String?>? description,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (description != null) 'description': description,
    });
  }

  FragmentsCompanion copyWith(
      {Value<int?>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? question,
      Value<String?>? answer,
      Value<String?>? description}) {
    return FragmentsCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int?>(cloudId.value);
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
    if (question.present) {
      map['question'] = Variable<String?>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String?>(answer.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FragmentsCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $FragmentsTable extends Fragments
    with TableInfo<$FragmentsTable, Fragment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FragmentsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
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
  final VerificationMeta _questionMeta = const VerificationMeta('question');
  @override
  late final GeneratedColumn<String?> question = GeneratedColumn<String?>(
      'question', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String?> answer = GeneratedColumn<String?>(
      'answer', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        question,
        answer,
        description
      ];
  @override
  String get aliasedName => _alias ?? 'fragments';
  @override
  String get actualTableName => 'fragments';
  @override
  VerificationContext validateIntegrity(Insertable<Fragment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
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
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Fragment map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Fragment.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FragmentsTable createAlias(String alias) {
    return $FragmentsTable(attachedDatabase, alias);
  }
}

class MemoryGroup extends DataClass implements Insertable<MemoryGroup> {
  /// 可空。
  final int? cloudId;

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
  final String? title;
  MemoryGroup(
      {this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.title});
  factory MemoryGroup.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return MemoryGroup(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id']),
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
          .mapFromDatabaseResponse(data['${effectivePrefix}title']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || cloudId != null) {
      map['cloud_id'] = Variable<int?>(cloudId);
    }
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String?>(title);
    }
    return map;
  }

  MemoryGroupsCompanion toCompanion(bool nullToAbsent) {
    return MemoryGroupsCompanion(
      cloudId: cloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
    );
  }

  factory MemoryGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryGroup(
      cloudId: serializer.fromJson<int?>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      title: serializer.fromJson<String?>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int?>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'title': serializer.toJson<String?>(title),
    };
  }

  MemoryGroup copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? title}) =>
      MemoryGroup(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('MemoryGroup(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      cloudId, syncCurd, syncUpdateColumns, id, createdAt, updatedAt, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryGroup &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.title == this.title);
}

class MemoryGroupsCompanion extends UpdateCompanion<MemoryGroup> {
  final Value<int?> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> title;
  const MemoryGroupsCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
  });
  MemoryGroupsCompanion.insert({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.title = const Value.absent(),
  });
  static Insertable<MemoryGroup> custom({
    Expression<int?>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String?>? title,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (title != null) 'title': title,
    });
  }

  MemoryGroupsCompanion copyWith(
      {Value<int?>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? title}) {
    return MemoryGroupsCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int?>(cloudId.value);
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
      map['title'] = Variable<String?>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryGroupsCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $MemoryGroupsTable extends MemoryGroups
    with TableInfo<$MemoryGroupsTable, MemoryGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryGroupsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
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
      'title', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [cloudId, syncCurd, syncUpdateColumns, id, createdAt, updatedAt, title];
  @override
  String get aliasedName => _alias ?? 'memory_groups';
  @override
  String get actualTableName => 'memory_groups';
  @override
  VerificationContext validateIntegrity(Insertable<MemoryGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    return MemoryGroup.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MemoryGroupsTable createAlias(String alias) {
    return $MemoryGroupsTable(attachedDatabase, alias);
  }
}

class Folder2Fragment extends DataClass implements Insertable<Folder2Fragment> {
  /// 可空。
  final int? cloudId;

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
  final int? folderId;
  final int? folderCloudId;
  final int? fragmentId;
  final int? fragmentCloudId;
  Folder2Fragment(
      {this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.folderId,
      this.folderCloudId,
      this.fragmentId,
      this.fragmentCloudId});
  factory Folder2Fragment.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Folder2Fragment(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id']),
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
      folderId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}folder_id']),
      folderCloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}folder_cloud_id']),
      fragmentId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_id']),
      fragmentCloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_cloud_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || cloudId != null) {
      map['cloud_id'] = Variable<int?>(cloudId);
    }
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<int?>(folderId);
    }
    if (!nullToAbsent || folderCloudId != null) {
      map['folder_cloud_id'] = Variable<int?>(folderCloudId);
    }
    if (!nullToAbsent || fragmentId != null) {
      map['fragment_id'] = Variable<int?>(fragmentId);
    }
    if (!nullToAbsent || fragmentCloudId != null) {
      map['fragment_cloud_id'] = Variable<int?>(fragmentCloudId);
    }
    return map;
  }

  Folder2FragmentsCompanion toCompanion(bool nullToAbsent) {
    return Folder2FragmentsCompanion(
      cloudId: cloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      folderCloudId: folderCloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderCloudId),
      fragmentId: fragmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentId),
      fragmentCloudId: fragmentCloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentCloudId),
    );
  }

  factory Folder2Fragment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder2Fragment(
      cloudId: serializer.fromJson<int?>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      folderId: serializer.fromJson<int?>(json['folderId']),
      folderCloudId: serializer.fromJson<int?>(json['folderCloudId']),
      fragmentId: serializer.fromJson<int?>(json['fragmentId']),
      fragmentCloudId: serializer.fromJson<int?>(json['fragmentCloudId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int?>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'folderId': serializer.toJson<int?>(folderId),
      'folderCloudId': serializer.toJson<int?>(folderCloudId),
      'fragmentId': serializer.toJson<int?>(fragmentId),
      'fragmentCloudId': serializer.toJson<int?>(fragmentCloudId),
    };
  }

  Folder2Fragment copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? folderId,
          int? folderCloudId,
          int? fragmentId,
          int? fragmentCloudId}) =>
      Folder2Fragment(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        folderId: folderId ?? this.folderId,
        folderCloudId: folderCloudId ?? this.folderCloudId,
        fragmentId: fragmentId ?? this.fragmentId,
        fragmentCloudId: fragmentCloudId ?? this.fragmentCloudId,
      );
  @override
  String toString() {
    return (StringBuffer('Folder2Fragment(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('folderId: $folderId, ')
          ..write('folderCloudId: $folderCloudId, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCloudId: $fragmentCloudId')
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
      folderId,
      folderCloudId,
      fragmentId,
      fragmentCloudId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder2Fragment &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.folderId == this.folderId &&
          other.folderCloudId == this.folderCloudId &&
          other.fragmentId == this.fragmentId &&
          other.fragmentCloudId == this.fragmentCloudId);
}

class Folder2FragmentsCompanion extends UpdateCompanion<Folder2Fragment> {
  final Value<int?> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> folderId;
  final Value<int?> folderCloudId;
  final Value<int?> fragmentId;
  final Value<int?> fragmentCloudId;
  const Folder2FragmentsCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.folderId = const Value.absent(),
    this.folderCloudId = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCloudId = const Value.absent(),
  });
  Folder2FragmentsCompanion.insert({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.folderId = const Value.absent(),
    this.folderCloudId = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCloudId = const Value.absent(),
  });
  static Insertable<Folder2Fragment> custom({
    Expression<int?>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? folderId,
    Expression<int?>? folderCloudId,
    Expression<int?>? fragmentId,
    Expression<int?>? fragmentCloudId,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (folderId != null) 'folder_id': folderId,
      if (folderCloudId != null) 'folder_cloud_id': folderCloudId,
      if (fragmentId != null) 'fragment_id': fragmentId,
      if (fragmentCloudId != null) 'fragment_cloud_id': fragmentCloudId,
    });
  }

  Folder2FragmentsCompanion copyWith(
      {Value<int?>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? folderId,
      Value<int?>? folderCloudId,
      Value<int?>? fragmentId,
      Value<int?>? fragmentCloudId}) {
    return Folder2FragmentsCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      folderId: folderId ?? this.folderId,
      folderCloudId: folderCloudId ?? this.folderCloudId,
      fragmentId: fragmentId ?? this.fragmentId,
      fragmentCloudId: fragmentCloudId ?? this.fragmentCloudId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int?>(cloudId.value);
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
    if (folderId.present) {
      map['folder_id'] = Variable<int?>(folderId.value);
    }
    if (folderCloudId.present) {
      map['folder_cloud_id'] = Variable<int?>(folderCloudId.value);
    }
    if (fragmentId.present) {
      map['fragment_id'] = Variable<int?>(fragmentId.value);
    }
    if (fragmentCloudId.present) {
      map['fragment_cloud_id'] = Variable<int?>(fragmentCloudId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('Folder2FragmentsCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('folderId: $folderId, ')
          ..write('folderCloudId: $folderCloudId, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCloudId: $fragmentCloudId')
          ..write(')'))
        .toString();
  }
}

class $Folder2FragmentsTable extends Folder2Fragments
    with TableInfo<$Folder2FragmentsTable, Folder2Fragment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $Folder2FragmentsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
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
  final VerificationMeta _folderIdMeta = const VerificationMeta('folderId');
  @override
  late final GeneratedColumn<int?> folderId = GeneratedColumn<int?>(
      'folder_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _folderCloudIdMeta =
      const VerificationMeta('folderCloudId');
  @override
  late final GeneratedColumn<int?> folderCloudId = GeneratedColumn<int?>(
      'folder_cloud_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentIdMeta = const VerificationMeta('fragmentId');
  @override
  late final GeneratedColumn<int?> fragmentId = GeneratedColumn<int?>(
      'fragment_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentCloudIdMeta =
      const VerificationMeta('fragmentCloudId');
  @override
  late final GeneratedColumn<int?> fragmentCloudId = GeneratedColumn<int?>(
      'fragment_cloud_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        folderId,
        folderCloudId,
        fragmentId,
        fragmentCloudId
      ];
  @override
  String get aliasedName => _alias ?? 'folder2_fragments';
  @override
  String get actualTableName => 'folder2_fragments';
  @override
  VerificationContext validateIntegrity(Insertable<Folder2Fragment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
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
    if (data.containsKey('folder_id')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta));
    }
    if (data.containsKey('folder_cloud_id')) {
      context.handle(
          _folderCloudIdMeta,
          folderCloudId.isAcceptableOrUnknown(
              data['folder_cloud_id']!, _folderCloudIdMeta));
    }
    if (data.containsKey('fragment_id')) {
      context.handle(
          _fragmentIdMeta,
          fragmentId.isAcceptableOrUnknown(
              data['fragment_id']!, _fragmentIdMeta));
    }
    if (data.containsKey('fragment_cloud_id')) {
      context.handle(
          _fragmentCloudIdMeta,
          fragmentCloudId.isAcceptableOrUnknown(
              data['fragment_cloud_id']!, _fragmentCloudIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder2Fragment map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Folder2Fragment.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $Folder2FragmentsTable createAlias(String alias) {
    return $Folder2FragmentsTable(attachedDatabase, alias);
  }
}

class MemoryGroup2Fragment extends DataClass
    implements Insertable<MemoryGroup2Fragment> {
  /// 可空。
  final int? cloudId;

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
  final int? memoryGroupId;
  final int? memoryGroupCloudId;
  final int? fragmentId;
  final int? fragmentCloudId;
  MemoryGroup2Fragment(
      {this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.memoryGroupId,
      this.memoryGroupCloudId,
      this.fragmentId,
      this.fragmentCloudId});
  factory MemoryGroup2Fragment.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return MemoryGroup2Fragment(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id']),
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
      memoryGroupId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}memory_group_id']),
      memoryGroupCloudId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}memory_group_cloud_id']),
      fragmentId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_id']),
      fragmentCloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_cloud_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || cloudId != null) {
      map['cloud_id'] = Variable<int?>(cloudId);
    }
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || memoryGroupId != null) {
      map['memory_group_id'] = Variable<int?>(memoryGroupId);
    }
    if (!nullToAbsent || memoryGroupCloudId != null) {
      map['memory_group_cloud_id'] = Variable<int?>(memoryGroupCloudId);
    }
    if (!nullToAbsent || fragmentId != null) {
      map['fragment_id'] = Variable<int?>(fragmentId);
    }
    if (!nullToAbsent || fragmentCloudId != null) {
      map['fragment_cloud_id'] = Variable<int?>(fragmentCloudId);
    }
    return map;
  }

  MemoryGroup2FragmentsCompanion toCompanion(bool nullToAbsent) {
    return MemoryGroup2FragmentsCompanion(
      cloudId: cloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      memoryGroupId: memoryGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(memoryGroupId),
      memoryGroupCloudId: memoryGroupCloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(memoryGroupCloudId),
      fragmentId: fragmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentId),
      fragmentCloudId: fragmentCloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentCloudId),
    );
  }

  factory MemoryGroup2Fragment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryGroup2Fragment(
      cloudId: serializer.fromJson<int?>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      memoryGroupId: serializer.fromJson<int?>(json['memoryGroupId']),
      memoryGroupCloudId: serializer.fromJson<int?>(json['memoryGroupCloudId']),
      fragmentId: serializer.fromJson<int?>(json['fragmentId']),
      fragmentCloudId: serializer.fromJson<int?>(json['fragmentCloudId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int?>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'memoryGroupId': serializer.toJson<int?>(memoryGroupId),
      'memoryGroupCloudId': serializer.toJson<int?>(memoryGroupCloudId),
      'fragmentId': serializer.toJson<int?>(fragmentId),
      'fragmentCloudId': serializer.toJson<int?>(fragmentCloudId),
    };
  }

  MemoryGroup2Fragment copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? memoryGroupId,
          int? memoryGroupCloudId,
          int? fragmentId,
          int? fragmentCloudId}) =>
      MemoryGroup2Fragment(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        memoryGroupId: memoryGroupId ?? this.memoryGroupId,
        memoryGroupCloudId: memoryGroupCloudId ?? this.memoryGroupCloudId,
        fragmentId: fragmentId ?? this.fragmentId,
        fragmentCloudId: fragmentCloudId ?? this.fragmentCloudId,
      );
  @override
  String toString() {
    return (StringBuffer('MemoryGroup2Fragment(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('memoryGroupId: $memoryGroupId, ')
          ..write('memoryGroupCloudId: $memoryGroupCloudId, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCloudId: $fragmentCloudId')
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
      memoryGroupId,
      memoryGroupCloudId,
      fragmentId,
      fragmentCloudId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryGroup2Fragment &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.memoryGroupId == this.memoryGroupId &&
          other.memoryGroupCloudId == this.memoryGroupCloudId &&
          other.fragmentId == this.fragmentId &&
          other.fragmentCloudId == this.fragmentCloudId);
}

class MemoryGroup2FragmentsCompanion
    extends UpdateCompanion<MemoryGroup2Fragment> {
  final Value<int?> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> memoryGroupId;
  final Value<int?> memoryGroupCloudId;
  final Value<int?> fragmentId;
  final Value<int?> fragmentCloudId;
  const MemoryGroup2FragmentsCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.memoryGroupId = const Value.absent(),
    this.memoryGroupCloudId = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCloudId = const Value.absent(),
  });
  MemoryGroup2FragmentsCompanion.insert({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.memoryGroupId = const Value.absent(),
    this.memoryGroupCloudId = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCloudId = const Value.absent(),
  });
  static Insertable<MemoryGroup2Fragment> custom({
    Expression<int?>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? memoryGroupId,
    Expression<int?>? memoryGroupCloudId,
    Expression<int?>? fragmentId,
    Expression<int?>? fragmentCloudId,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (memoryGroupId != null) 'memory_group_id': memoryGroupId,
      if (memoryGroupCloudId != null)
        'memory_group_cloud_id': memoryGroupCloudId,
      if (fragmentId != null) 'fragment_id': fragmentId,
      if (fragmentCloudId != null) 'fragment_cloud_id': fragmentCloudId,
    });
  }

  MemoryGroup2FragmentsCompanion copyWith(
      {Value<int?>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? memoryGroupId,
      Value<int?>? memoryGroupCloudId,
      Value<int?>? fragmentId,
      Value<int?>? fragmentCloudId}) {
    return MemoryGroup2FragmentsCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      memoryGroupId: memoryGroupId ?? this.memoryGroupId,
      memoryGroupCloudId: memoryGroupCloudId ?? this.memoryGroupCloudId,
      fragmentId: fragmentId ?? this.fragmentId,
      fragmentCloudId: fragmentCloudId ?? this.fragmentCloudId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int?>(cloudId.value);
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
    if (memoryGroupId.present) {
      map['memory_group_id'] = Variable<int?>(memoryGroupId.value);
    }
    if (memoryGroupCloudId.present) {
      map['memory_group_cloud_id'] = Variable<int?>(memoryGroupCloudId.value);
    }
    if (fragmentId.present) {
      map['fragment_id'] = Variable<int?>(fragmentId.value);
    }
    if (fragmentCloudId.present) {
      map['fragment_cloud_id'] = Variable<int?>(fragmentCloudId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryGroup2FragmentsCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('memoryGroupId: $memoryGroupId, ')
          ..write('memoryGroupCloudId: $memoryGroupCloudId, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCloudId: $fragmentCloudId')
          ..write(')'))
        .toString();
  }
}

class $MemoryGroup2FragmentsTable extends MemoryGroup2Fragments
    with TableInfo<$MemoryGroup2FragmentsTable, MemoryGroup2Fragment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryGroup2FragmentsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
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
  final VerificationMeta _memoryGroupIdMeta =
      const VerificationMeta('memoryGroupId');
  @override
  late final GeneratedColumn<int?> memoryGroupId = GeneratedColumn<int?>(
      'memory_group_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _memoryGroupCloudIdMeta =
      const VerificationMeta('memoryGroupCloudId');
  @override
  late final GeneratedColumn<int?> memoryGroupCloudId = GeneratedColumn<int?>(
      'memory_group_cloud_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentIdMeta = const VerificationMeta('fragmentId');
  @override
  late final GeneratedColumn<int?> fragmentId = GeneratedColumn<int?>(
      'fragment_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentCloudIdMeta =
      const VerificationMeta('fragmentCloudId');
  @override
  late final GeneratedColumn<int?> fragmentCloudId = GeneratedColumn<int?>(
      'fragment_cloud_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        memoryGroupId,
        memoryGroupCloudId,
        fragmentId,
        fragmentCloudId
      ];
  @override
  String get aliasedName => _alias ?? 'memory_group2_fragments';
  @override
  String get actualTableName => 'memory_group2_fragments';
  @override
  VerificationContext validateIntegrity(
      Insertable<MemoryGroup2Fragment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
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
    if (data.containsKey('memory_group_id')) {
      context.handle(
          _memoryGroupIdMeta,
          memoryGroupId.isAcceptableOrUnknown(
              data['memory_group_id']!, _memoryGroupIdMeta));
    }
    if (data.containsKey('memory_group_cloud_id')) {
      context.handle(
          _memoryGroupCloudIdMeta,
          memoryGroupCloudId.isAcceptableOrUnknown(
              data['memory_group_cloud_id']!, _memoryGroupCloudIdMeta));
    }
    if (data.containsKey('fragment_id')) {
      context.handle(
          _fragmentIdMeta,
          fragmentId.isAcceptableOrUnknown(
              data['fragment_id']!, _fragmentIdMeta));
    }
    if (data.containsKey('fragment_cloud_id')) {
      context.handle(
          _fragmentCloudIdMeta,
          fragmentCloudId.isAcceptableOrUnknown(
              data['fragment_cloud_id']!, _fragmentCloudIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryGroup2Fragment map(Map<String, dynamic> data, {String? tablePrefix}) {
    return MemoryGroup2Fragment.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MemoryGroup2FragmentsTable createAlias(String alias) {
    return $MemoryGroup2FragmentsTable(attachedDatabase, alias);
  }
}

class SimilarFragment extends DataClass implements Insertable<SimilarFragment> {
  /// 可空。
  final int? cloudId;

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
  final int? fragmentAId;
  final int? fragmentACloudId;
  final int? fragmentBId;
  final int? fragmentBCloudId;
  SimilarFragment(
      {this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.fragmentAId,
      this.fragmentACloudId,
      this.fragmentBId,
      this.fragmentBCloudId});
  factory SimilarFragment.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return SimilarFragment(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id']),
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
      fragmentAId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_a_id']),
      fragmentACloudId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}fragment_a_cloud_id']),
      fragmentBId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_b_id']),
      fragmentBCloudId: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}fragment_b_cloud_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || cloudId != null) {
      map['cloud_id'] = Variable<int?>(cloudId);
    }
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || fragmentAId != null) {
      map['fragment_a_id'] = Variable<int?>(fragmentAId);
    }
    if (!nullToAbsent || fragmentACloudId != null) {
      map['fragment_a_cloud_id'] = Variable<int?>(fragmentACloudId);
    }
    if (!nullToAbsent || fragmentBId != null) {
      map['fragment_b_id'] = Variable<int?>(fragmentBId);
    }
    if (!nullToAbsent || fragmentBCloudId != null) {
      map['fragment_b_cloud_id'] = Variable<int?>(fragmentBCloudId);
    }
    return map;
  }

  SimilarFragmentsCompanion toCompanion(bool nullToAbsent) {
    return SimilarFragmentsCompanion(
      cloudId: cloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fragmentAId: fragmentAId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentAId),
      fragmentACloudId: fragmentACloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentACloudId),
      fragmentBId: fragmentBId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentBId),
      fragmentBCloudId: fragmentBCloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentBCloudId),
    );
  }

  factory SimilarFragment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SimilarFragment(
      cloudId: serializer.fromJson<int?>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      fragmentAId: serializer.fromJson<int?>(json['fragmentAId']),
      fragmentACloudId: serializer.fromJson<int?>(json['fragmentACloudId']),
      fragmentBId: serializer.fromJson<int?>(json['fragmentBId']),
      fragmentBCloudId: serializer.fromJson<int?>(json['fragmentBCloudId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int?>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'fragmentAId': serializer.toJson<int?>(fragmentAId),
      'fragmentACloudId': serializer.toJson<int?>(fragmentACloudId),
      'fragmentBId': serializer.toJson<int?>(fragmentBId),
      'fragmentBCloudId': serializer.toJson<int?>(fragmentBCloudId),
    };
  }

  SimilarFragment copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? fragmentAId,
          int? fragmentACloudId,
          int? fragmentBId,
          int? fragmentBCloudId}) =>
      SimilarFragment(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        fragmentAId: fragmentAId ?? this.fragmentAId,
        fragmentACloudId: fragmentACloudId ?? this.fragmentACloudId,
        fragmentBId: fragmentBId ?? this.fragmentBId,
        fragmentBCloudId: fragmentBCloudId ?? this.fragmentBCloudId,
      );
  @override
  String toString() {
    return (StringBuffer('SimilarFragment(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fragmentAId: $fragmentAId, ')
          ..write('fragmentACloudId: $fragmentACloudId, ')
          ..write('fragmentBId: $fragmentBId, ')
          ..write('fragmentBCloudId: $fragmentBCloudId')
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
      fragmentAId,
      fragmentACloudId,
      fragmentBId,
      fragmentBCloudId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SimilarFragment &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fragmentAId == this.fragmentAId &&
          other.fragmentACloudId == this.fragmentACloudId &&
          other.fragmentBId == this.fragmentBId &&
          other.fragmentBCloudId == this.fragmentBCloudId);
}

class SimilarFragmentsCompanion extends UpdateCompanion<SimilarFragment> {
  final Value<int?> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> fragmentAId;
  final Value<int?> fragmentACloudId;
  final Value<int?> fragmentBId;
  final Value<int?> fragmentBCloudId;
  const SimilarFragmentsCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fragmentAId = const Value.absent(),
    this.fragmentACloudId = const Value.absent(),
    this.fragmentBId = const Value.absent(),
    this.fragmentBCloudId = const Value.absent(),
  });
  SimilarFragmentsCompanion.insert({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fragmentAId = const Value.absent(),
    this.fragmentACloudId = const Value.absent(),
    this.fragmentBId = const Value.absent(),
    this.fragmentBCloudId = const Value.absent(),
  });
  static Insertable<SimilarFragment> custom({
    Expression<int?>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? fragmentAId,
    Expression<int?>? fragmentACloudId,
    Expression<int?>? fragmentBId,
    Expression<int?>? fragmentBCloudId,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fragmentAId != null) 'fragment_a_id': fragmentAId,
      if (fragmentACloudId != null) 'fragment_a_cloud_id': fragmentACloudId,
      if (fragmentBId != null) 'fragment_b_id': fragmentBId,
      if (fragmentBCloudId != null) 'fragment_b_cloud_id': fragmentBCloudId,
    });
  }

  SimilarFragmentsCompanion copyWith(
      {Value<int?>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? fragmentAId,
      Value<int?>? fragmentACloudId,
      Value<int?>? fragmentBId,
      Value<int?>? fragmentBCloudId}) {
    return SimilarFragmentsCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fragmentAId: fragmentAId ?? this.fragmentAId,
      fragmentACloudId: fragmentACloudId ?? this.fragmentACloudId,
      fragmentBId: fragmentBId ?? this.fragmentBId,
      fragmentBCloudId: fragmentBCloudId ?? this.fragmentBCloudId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int?>(cloudId.value);
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
    if (fragmentAId.present) {
      map['fragment_a_id'] = Variable<int?>(fragmentAId.value);
    }
    if (fragmentACloudId.present) {
      map['fragment_a_cloud_id'] = Variable<int?>(fragmentACloudId.value);
    }
    if (fragmentBId.present) {
      map['fragment_b_id'] = Variable<int?>(fragmentBId.value);
    }
    if (fragmentBCloudId.present) {
      map['fragment_b_cloud_id'] = Variable<int?>(fragmentBCloudId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SimilarFragmentsCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fragmentAId: $fragmentAId, ')
          ..write('fragmentACloudId: $fragmentACloudId, ')
          ..write('fragmentBId: $fragmentBId, ')
          ..write('fragmentBCloudId: $fragmentBCloudId')
          ..write(')'))
        .toString();
  }
}

class $SimilarFragmentsTable extends SimilarFragments
    with TableInfo<$SimilarFragmentsTable, SimilarFragment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SimilarFragmentsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
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
  final VerificationMeta _fragmentAIdMeta =
      const VerificationMeta('fragmentAId');
  @override
  late final GeneratedColumn<int?> fragmentAId = GeneratedColumn<int?>(
      'fragment_a_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentACloudIdMeta =
      const VerificationMeta('fragmentACloudId');
  @override
  late final GeneratedColumn<int?> fragmentACloudId = GeneratedColumn<int?>(
      'fragment_a_cloud_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentBIdMeta =
      const VerificationMeta('fragmentBId');
  @override
  late final GeneratedColumn<int?> fragmentBId = GeneratedColumn<int?>(
      'fragment_b_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentBCloudIdMeta =
      const VerificationMeta('fragmentBCloudId');
  @override
  late final GeneratedColumn<int?> fragmentBCloudId = GeneratedColumn<int?>(
      'fragment_b_cloud_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        fragmentAId,
        fragmentACloudId,
        fragmentBId,
        fragmentBCloudId
      ];
  @override
  String get aliasedName => _alias ?? 'similar_fragments';
  @override
  String get actualTableName => 'similar_fragments';
  @override
  VerificationContext validateIntegrity(Insertable<SimilarFragment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
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
    if (data.containsKey('fragment_a_id')) {
      context.handle(
          _fragmentAIdMeta,
          fragmentAId.isAcceptableOrUnknown(
              data['fragment_a_id']!, _fragmentAIdMeta));
    }
    if (data.containsKey('fragment_a_cloud_id')) {
      context.handle(
          _fragmentACloudIdMeta,
          fragmentACloudId.isAcceptableOrUnknown(
              data['fragment_a_cloud_id']!, _fragmentACloudIdMeta));
    }
    if (data.containsKey('fragment_b_id')) {
      context.handle(
          _fragmentBIdMeta,
          fragmentBId.isAcceptableOrUnknown(
              data['fragment_b_id']!, _fragmentBIdMeta));
    }
    if (data.containsKey('fragment_b_cloud_id')) {
      context.handle(
          _fragmentBCloudIdMeta,
          fragmentBCloudId.isAcceptableOrUnknown(
              data['fragment_b_cloud_id']!, _fragmentBCloudIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SimilarFragment map(Map<String, dynamic> data, {String? tablePrefix}) {
    return SimilarFragment.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $SimilarFragmentsTable createAlias(String alias) {
    return $SimilarFragmentsTable(attachedDatabase, alias);
  }
}

class Remember extends DataClass implements Insertable<Remember> {
  /// 可空。
  final int? cloudId;

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
  final int? fragmentId;
  final int? fragmentCloudId;

  /// 记忆次数。
  final int rememberTimes;

  /// 对应 [RememberStatus]，所有 rows 只能存在一个不为 [RememberStatus.none]。
  final int status;
  Remember(
      {this.cloudId,
      this.syncCurd,
      this.syncUpdateColumns,
      required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.fragmentId,
      this.fragmentCloudId,
      required this.rememberTimes,
      required this.status});
  factory Remember.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Remember(
      cloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cloud_id']),
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
      fragmentId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_id']),
      fragmentCloudId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fragment_cloud_id']),
      rememberTimes: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}remember_times'])!,
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || cloudId != null) {
      map['cloud_id'] = Variable<int?>(cloudId);
    }
    if (!nullToAbsent || syncCurd != null) {
      map['sync_curd'] = Variable<int?>(syncCurd);
    }
    if (!nullToAbsent || syncUpdateColumns != null) {
      map['sync_update_columns'] = Variable<String?>(syncUpdateColumns);
    }
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || fragmentId != null) {
      map['fragment_id'] = Variable<int?>(fragmentId);
    }
    if (!nullToAbsent || fragmentCloudId != null) {
      map['fragment_cloud_id'] = Variable<int?>(fragmentCloudId);
    }
    map['remember_times'] = Variable<int>(rememberTimes);
    map['status'] = Variable<int>(status);
    return map;
  }

  RemembersCompanion toCompanion(bool nullToAbsent) {
    return RemembersCompanion(
      cloudId: cloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudId),
      syncCurd: syncCurd == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCurd),
      syncUpdateColumns: syncUpdateColumns == null && nullToAbsent
          ? const Value.absent()
          : Value(syncUpdateColumns),
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      fragmentId: fragmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentId),
      fragmentCloudId: fragmentCloudId == null && nullToAbsent
          ? const Value.absent()
          : Value(fragmentCloudId),
      rememberTimes: Value(rememberTimes),
      status: Value(status),
    );
  }

  factory Remember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Remember(
      cloudId: serializer.fromJson<int?>(json['cloudId']),
      syncCurd: serializer.fromJson<int?>(json['syncCurd']),
      syncUpdateColumns:
          serializer.fromJson<String?>(json['syncUpdateColumns']),
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      fragmentId: serializer.fromJson<int?>(json['fragmentId']),
      fragmentCloudId: serializer.fromJson<int?>(json['fragmentCloudId']),
      rememberTimes: serializer.fromJson<int>(json['rememberTimes']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cloudId': serializer.toJson<int?>(cloudId),
      'syncCurd': serializer.toJson<int?>(syncCurd),
      'syncUpdateColumns': serializer.toJson<String?>(syncUpdateColumns),
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'fragmentId': serializer.toJson<int?>(fragmentId),
      'fragmentCloudId': serializer.toJson<int?>(fragmentCloudId),
      'rememberTimes': serializer.toJson<int>(rememberTimes),
      'status': serializer.toJson<int>(status),
    };
  }

  Remember copyWith(
          {int? cloudId,
          int? syncCurd,
          String? syncUpdateColumns,
          int? id,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? fragmentId,
          int? fragmentCloudId,
          int? rememberTimes,
          int? status}) =>
      Remember(
        cloudId: cloudId ?? this.cloudId,
        syncCurd: syncCurd ?? this.syncCurd,
        syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        fragmentId: fragmentId ?? this.fragmentId,
        fragmentCloudId: fragmentCloudId ?? this.fragmentCloudId,
        rememberTimes: rememberTimes ?? this.rememberTimes,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('Remember(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCloudId: $fragmentCloudId, ')
          ..write('rememberTimes: $rememberTimes, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cloudId, syncCurd, syncUpdateColumns, id,
      createdAt, updatedAt, fragmentId, fragmentCloudId, rememberTimes, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Remember &&
          other.cloudId == this.cloudId &&
          other.syncCurd == this.syncCurd &&
          other.syncUpdateColumns == this.syncUpdateColumns &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.fragmentId == this.fragmentId &&
          other.fragmentCloudId == this.fragmentCloudId &&
          other.rememberTimes == this.rememberTimes &&
          other.status == this.status);
}

class RemembersCompanion extends UpdateCompanion<Remember> {
  final Value<int?> cloudId;
  final Value<int?> syncCurd;
  final Value<String?> syncUpdateColumns;
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> fragmentId;
  final Value<int?> fragmentCloudId;
  final Value<int> rememberTimes;
  final Value<int> status;
  const RemembersCompanion({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCloudId = const Value.absent(),
    this.rememberTimes = const Value.absent(),
    this.status = const Value.absent(),
  });
  RemembersCompanion.insert({
    this.cloudId = const Value.absent(),
    this.syncCurd = const Value.absent(),
    this.syncUpdateColumns = const Value.absent(),
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.fragmentId = const Value.absent(),
    this.fragmentCloudId = const Value.absent(),
    this.rememberTimes = const Value.absent(),
    this.status = const Value.absent(),
  });
  static Insertable<Remember> custom({
    Expression<int?>? cloudId,
    Expression<int?>? syncCurd,
    Expression<String?>? syncUpdateColumns,
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int?>? fragmentId,
    Expression<int?>? fragmentCloudId,
    Expression<int>? rememberTimes,
    Expression<int>? status,
  }) {
    return RawValuesInsertable({
      if (cloudId != null) 'cloud_id': cloudId,
      if (syncCurd != null) 'sync_curd': syncCurd,
      if (syncUpdateColumns != null) 'sync_update_columns': syncUpdateColumns,
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (fragmentId != null) 'fragment_id': fragmentId,
      if (fragmentCloudId != null) 'fragment_cloud_id': fragmentCloudId,
      if (rememberTimes != null) 'remember_times': rememberTimes,
      if (status != null) 'status': status,
    });
  }

  RemembersCompanion copyWith(
      {Value<int?>? cloudId,
      Value<int?>? syncCurd,
      Value<String?>? syncUpdateColumns,
      Value<int>? id,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? fragmentId,
      Value<int?>? fragmentCloudId,
      Value<int>? rememberTimes,
      Value<int>? status}) {
    return RemembersCompanion(
      cloudId: cloudId ?? this.cloudId,
      syncCurd: syncCurd ?? this.syncCurd,
      syncUpdateColumns: syncUpdateColumns ?? this.syncUpdateColumns,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fragmentId: fragmentId ?? this.fragmentId,
      fragmentCloudId: fragmentCloudId ?? this.fragmentCloudId,
      rememberTimes: rememberTimes ?? this.rememberTimes,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cloudId.present) {
      map['cloud_id'] = Variable<int?>(cloudId.value);
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
    if (fragmentId.present) {
      map['fragment_id'] = Variable<int?>(fragmentId.value);
    }
    if (fragmentCloudId.present) {
      map['fragment_cloud_id'] = Variable<int?>(fragmentCloudId.value);
    }
    if (rememberTimes.present) {
      map['remember_times'] = Variable<int>(rememberTimes.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemembersCompanion(')
          ..write('cloudId: $cloudId, ')
          ..write('syncCurd: $syncCurd, ')
          ..write('syncUpdateColumns: $syncUpdateColumns, ')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('fragmentId: $fragmentId, ')
          ..write('fragmentCloudId: $fragmentCloudId, ')
          ..write('rememberTimes: $rememberTimes, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $RemembersTable extends Remembers
    with TableInfo<$RemembersTable, Remember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemembersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _cloudIdMeta = const VerificationMeta('cloudId');
  @override
  late final GeneratedColumn<int?> cloudId = GeneratedColumn<int?>(
      'cloud_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
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
  final VerificationMeta _fragmentIdMeta = const VerificationMeta('fragmentId');
  @override
  late final GeneratedColumn<int?> fragmentId = GeneratedColumn<int?>(
      'fragment_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _fragmentCloudIdMeta =
      const VerificationMeta('fragmentCloudId');
  @override
  late final GeneratedColumn<int?> fragmentCloudId = GeneratedColumn<int?>(
      'fragment_cloud_id', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _rememberTimesMeta =
      const VerificationMeta('rememberTimes');
  @override
  late final GeneratedColumn<int?> rememberTimes = GeneratedColumn<int?>(
      'remember_times', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        cloudId,
        syncCurd,
        syncUpdateColumns,
        id,
        createdAt,
        updatedAt,
        fragmentId,
        fragmentCloudId,
        rememberTimes,
        status
      ];
  @override
  String get aliasedName => _alias ?? 'remembers';
  @override
  String get actualTableName => 'remembers';
  @override
  VerificationContext validateIntegrity(Insertable<Remember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cloud_id')) {
      context.handle(_cloudIdMeta,
          cloudId.isAcceptableOrUnknown(data['cloud_id']!, _cloudIdMeta));
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
    if (data.containsKey('fragment_id')) {
      context.handle(
          _fragmentIdMeta,
          fragmentId.isAcceptableOrUnknown(
              data['fragment_id']!, _fragmentIdMeta));
    }
    if (data.containsKey('fragment_cloud_id')) {
      context.handle(
          _fragmentCloudIdMeta,
          fragmentCloudId.isAcceptableOrUnknown(
              data['fragment_cloud_id']!, _fragmentCloudIdMeta));
    }
    if (data.containsKey('remember_times')) {
      context.handle(
          _rememberTimesMeta,
          rememberTimes.isAcceptableOrUnknown(
              data['remember_times']!, _rememberTimesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Remember map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Remember.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $RemembersTable createAlias(String alias) {
    return $RemembersTable(attachedDatabase, alias);
  }
}

abstract class _$DriftDb extends GeneratedDatabase {
  _$DriftDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $AppInfosTable appInfos = $AppInfosTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $FragmentsTable fragments = $FragmentsTable(this);
  late final $MemoryGroupsTable memoryGroups = $MemoryGroupsTable(this);
  late final $Folder2FragmentsTable folder2Fragments =
      $Folder2FragmentsTable(this);
  late final $MemoryGroup2FragmentsTable memoryGroup2Fragments =
      $MemoryGroup2FragmentsTable(this);
  late final $SimilarFragmentsTable similarFragments =
      $SimilarFragmentsTable(this);
  late final $RemembersTable remembers = $RemembersTable(this);
  late final InsertDAO insertDAO = InsertDAO(this as DriftDb);
  late final DeleteDAO deleteDAO = DeleteDAO(this as DriftDb);
  late final UpdateDAO updateDAO = UpdateDAO(this as DriftDb);
  late final RetrieveDAO retrieveDAO = RetrieveDAO(this as DriftDb);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        appInfos,
        users,
        folders,
        fragments,
        memoryGroups,
        folder2Fragments,
        memoryGroup2Fragments,
        similarFragments,
        remembers
      ];
}
