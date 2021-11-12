void main() {
  a();
}

void a() {
  Object? aa = <Object, Object?>{};
  Object? o = <String, Object?>{'a': aa};
  print((o as Map)['a']['mm']);
}
