import 'package:flutter/services.dart';

Future<List<T>> defaultAssetChoice360<T>({required Future<T> Function(String question, String answer) single}) async {
  var nativeContent = await rootBundle.loadString('assets/choice_360');

  List<T> singles = [];

  Map<String, String> resultMap = {};
  List<int> indexs = [];
  List<String> contents = [];

  RegExp numRegExp = RegExp(r"\d*");
  // 获取每道题序号的第一位 index
  numRegExp.allMatches(nativeContent).forEach(
    (value) {
      if (nativeContent.substring(value.start, value.end).isNotEmpty) {
        indexs.add(value.start);
      }
    },
  );

  // 获取每道题全部内容
  for (int i = 0; i < indexs.length; i++) {
    if (i + 1 == indexs.length) {
      contents.add(nativeContent.substring(indexs[i]));
    } else {
      contents.add(nativeContent.substring(indexs[i], indexs[i + 1]));
    }
  }

  for (var element in contents) {
    List<int> abcdIndexs = [];
    RegExp abcdRegExp = RegExp(r"[ABCD]");
    abcdRegExp.allMatches(element).forEach(
      (abcd) {
        abcdIndexs.add(abcd.start);
      },
    );
    String question = element.substring(0, abcdIndexs.first).replaceAll(RegExp(r'\s'), '').replaceAll('．', '.').replaceAll('.', '. ');
    resultMap.addAll({question: ''});
    String? a;
    String? b;
    String? c;
    String? d;
    String? e;
    for (int i = 0; i < abcdIndexs.length; i++) {
      if (i + 1 == abcdIndexs.length) {
        String willSort = element.substring(abcdIndexs[i]).replaceAll(RegExp(r'\s'), '') + '\n';
        if (willSort[0] == 'A' || willSort[0] == 'a') {
          a = willSort;
        }
        if (willSort[0] == 'B' || willSort[0] == 'b') {
          b = willSort;
        }
        if (willSort[0] == 'C' || willSort[0] == 'c') {
          c = willSort;
        }
        if (willSort[0] == 'D' || willSort[0] == 'd') {
          d = willSort;
        }
        if (willSort[0] == 'E' || willSort[0] == 'e') {
          e = willSort;
        }
      } else {
        String willSort = element.substring(abcdIndexs[i], abcdIndexs[i + 1]).replaceAll(RegExp(r'\s'), '') + '\n';
        if (willSort[0] == 'A' || willSort[0] == 'a') {
          a = willSort;
        }
        if (willSort[0] == 'B' || willSort[0] == 'b') {
          b = willSort;
        }
        if (willSort[0] == 'C' || willSort[0] == 'c') {
          c = willSort;
        }
        if (willSort[0] == 'D' || willSort[0] == 'd') {
          d = willSort;
        }
        if (willSort[0] == 'E' || willSort[0] == 'e') {
          e = willSort;
        }
      }
    }
    resultMap[question] = (a ?? '') + (b ?? '') + (c ?? '') + (d ?? '') + (e ?? '');
    singles.add(await single(question, resultMap[question]!));
  }
  return singles;
}

Future<List<T>> defaultAssetAncientPoems200<T>({required Future<T> Function(String question) single}) async {
  var nativeContent = await rootBundle.loadString('assets/ancient_poem_200');
  List<String> result = nativeContent.split(RegExp(r'\r\n'));

  List<T> singles = [];
  for (var element in result) {
    singles.add(await single(element));
  }
  return singles;
}

Future<List<T>> defaultAssetJudge200<T>({required Future<T> Function(String question) single}) async {
  var nativeContent = await rootBundle.loadString('assets/judge_200');
  List<String> result = nativeContent.split(RegExp(r'\r\n'));

  List<T> singles = [];
  for (var element in result) {
    singles.add(await single(element));
  }
  return singles;
}

Future<List<T>> wordMeaningAnalysis<T>({required String content, required Future<T> Function(String question, String answer) single}) async {
  List<String> groups = content.trim().split('|');

  List<T> singles = [];
  for (var group in groups) {
    String answer = group;
    String question = '';
    List<String> wordAndMeans = group.split(RegExp(r'\n'));
    for (var value in wordAndMeans) {
      question += value.split('-').first + '\n';
    }
    answer = answer.trim();
    question = question.trim();
    singles.add(await single(question, answer));
  }
  return singles;
}

Future<List<T>> wordMeaning<T>({required String content, required Future<T> Function(String question, String answer) single}) async {
  List<String> wordMeanings = content.trim().split(RegExp('\n'));
  List<T> singles = [];
  for (var wordMeaning in wordMeanings) {
    List<String> qa = wordMeaning.split('-');
    singles.add(await single(qa.first.trim(), qa.last.trim()));
  }
  return singles;
}
