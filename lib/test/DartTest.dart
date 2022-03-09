import 'dart:io';

Future<void> selects() async {
  var allString = await File('D:\\project\\hybrid\\lib\\test\\aa.txt').readAsString();
  Map<String, String> resultMap = {};
  List<int> indexs = [];
  List<String> contents = [];

  RegExp numRegExp = RegExp(r"\d*");
  // 获取每道题序号的第一位 index
  numRegExp.allMatches(allString).forEach(
    (value) {
      if (allString.substring(value.start, value.end).isNotEmpty) {
        indexs.add(value.start);
      }
    },
  );

  // 获取每道题全部内容
  for (int i = 0; i < indexs.length; i++) {
    if (i + 1 == indexs.length) {
      contents.add(allString.substring(indexs[i]));
    } else {
      contents.add(allString.substring(indexs[i], indexs[i + 1]));
    }
  }

  for (var element in contents) {
    Map<String, String> singleResult = {};
    List<int> abcdIndexs = [];
    RegExp abcdRegExp = RegExp(r"[ABCD]");
    abcdRegExp.allMatches(element).forEach(
      (abcd) {
        abcdIndexs.add(abcd.start);
      },
    );
    String question = element.substring(0, abcdIndexs.first).replaceAll(RegExp(r'\s'), '');
    singleResult.addAll({question: ''});
    for (int i = 0; i < abcdIndexs.length; i++) {
      if (i + 1 == abcdIndexs.length) {
        singleResult[question] = singleResult[question]! + element.substring(abcdIndexs[i]);
      } else {
        singleResult[question] = singleResult[question]! + element.substring(abcdIndexs[i], abcdIndexs[i + 1]);
      }
    }
    singleResult[question] = singleResult[question]!.replaceAll(RegExp(r'\s'), '');
    resultMap.addAll(singleResult);
  }
  return resultMap;
}

void main() {
  selects();
}
