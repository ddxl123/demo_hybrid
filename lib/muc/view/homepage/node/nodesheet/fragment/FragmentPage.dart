import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/muc/getcontroller/homepage/FragmentPageGetController.dart';

class FragmentPage extends StatelessWidget {
  FragmentPage(int? currentFragmentAiid, String? currentFragmentUuid) {
    fragmentPageGetController.currentFragmentAiid = currentFragmentAiid;
    fragmentPageGetController.currentFragmentUuid = currentFragmentUuid;
  }

  final FragmentPageGetController fragmentPageGetController = Get.put(FragmentPageGetController());

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('data'),
    );
  }
}
