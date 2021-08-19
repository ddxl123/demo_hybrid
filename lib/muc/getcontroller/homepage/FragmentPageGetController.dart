import 'package:hybrid/muc/update/homepage/FragmentPageUpdate.dart';

import '../GetControllerBase.dart';

class FragmentPageGetController extends GetControllerBase<FragmentPageGetController, FragmentPageUpdate> {
  FragmentPageGetController() : super(FragmentPageUpdate());

  int? currentFragmentAiid;
  String? currentFragmentUuid;
}
