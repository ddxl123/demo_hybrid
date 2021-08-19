// ignore_for_file: non_constant_identifier_names

/// 将 demo_texts 形式转化成 DemoText 形式;
String toCamelCase(String text) {
  final List<String> split = text.split('_');
  for (int i = 0; i < split.length; i++) {
    split[i] = split[i][0].toUpperCase() + split[i].substring(1);
  }
  return split.join('');
}
