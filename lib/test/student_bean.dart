import 'package:json_annotation/json_annotation.dart';

part 'student_bean.g.dart';

@JsonSerializable()
class Student {
  Student({this.name, this.age, required this.list, required this.map, required this.mapInt, required this.studentBean, required this.ii});

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

  String? name;

  int? age;

  List<II>? list;

  Map<String, Object?>? map;

  Map<String, int>? mapInt;

  Student? studentBean;

  II? ii;

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  void a() {}
}

@JsonSerializable()
class II {
  II({required this.i});

  factory II.fromJson(Map<String, dynamic> json) => _$IIFromJson(json);

  Map<String, dynamic> toJson() => _$IIToJson(this);
  int i = 1;
}
