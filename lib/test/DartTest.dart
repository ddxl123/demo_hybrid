void main() {
  a<TestClass>();
}

void a<T>() {
  print(T.runtimeType);
  print(T.toString());
}

class TestClass {}
