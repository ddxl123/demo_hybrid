class SbPopResult {
  SbPopResult({required this.popResultSelect, required this.value});

  PopResultSelect popResultSelect;
  Object? value;

  @override
  String toString() {
    return 'popResultSelect: $popResultSelect, value: $value';
  }
}

enum PopResultSelect {
  clickBackground,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  eleven,
  twelve,
}
