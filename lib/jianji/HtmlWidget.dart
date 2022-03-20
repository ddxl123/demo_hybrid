import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/HtmlJudge.dart';
import 'package:hybrid/jianji/HtmlSelection1.dart';
import 'package:hybrid/jianji/HtmlSelection2.dart';
import 'package:hybrid/jianji/HtmlSelection3.dart';
import 'package:hybrid/jianji/HtmlSelection4.dart';

enum QuestionType {
  selection360,
  judge200,
}

class HtmlWidget extends StatefulWidget {
  const HtmlWidget({Key? key, required this.fragment, required this.questionType}) : super(key: key);
  final QuestionType questionType;
  final Fragment fragment;

  @override
  State<HtmlWidget> createState() => _HtmlWidgetState();
}

class _HtmlWidgetState extends State<HtmlWidget> {
  @override
  void initState() {
    super.initState();
    EasyLoading.showToast('请在已截取的数题中自行翻阅答案！');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fragment.question.toString(),
          style: const TextStyle(fontSize: 12),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Html(
          data: () {
            String? result = () {
              try {
                if (widget.questionType == QuestionType.selection360) {
                  List<String> dataList = widget.fragment.question!.split('.');
                  int number = int.parse(dataList.first.trim());
                  if (number > 0 && number <= 100) {
                    return htmlSelection1();
                  } else if (number > 100 && number <= 200) {
                    return htmlSelection2();
                  } else if (number > 200 && number <= 300) {
                    return htmlSelection3();
                  } else if (number > 300 && number <= 400) {
                    return htmlSelection4();
                  }
                } else if (widget.questionType == QuestionType.judge200) {
                  return htmlJudge();
                }
              } catch (e, st) {
                log(e.toString());
                return null;
              }
            }();
            return result ?? '无答案';
          }(),
        ),
      ),
    );
  }
}

void showByType({required BuildContext context, required Fragment fragment}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      void push(QuestionType typeResult) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HtmlWidget(questionType: typeResult, fragment: fragment),
          ),
        );
      }

      return Column(
        children: [
          const SizedBox(height: 10),
          const Text('请选择该问题的类型，以便查询答案：', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('其他类型问题可长按并选中文本进行搜索，以查询答案。', style: TextStyle(color: Colors.grey)),
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    push(QuestionType.selection360);
                  },
                  child: const Text('语文 360 道选择题', style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    push(QuestionType.judge200);
                  },
                  child: const Text('语文 200 道判断题', style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
