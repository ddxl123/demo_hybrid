void main() {
  a();
}

void a() {
  Object? o = <String,Object?>{};
  if(o is Map){
    print(o);
  }
}
