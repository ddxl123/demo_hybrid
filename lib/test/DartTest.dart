import 'dart:async';

void main() {
  a();
}

void a() async {
  runZoned(
    () {},
  );
  try {
    await b();
  } catch (e) {
    print(e);
  }
}

Future<void> b() async {
  throw Exception('err');
}
