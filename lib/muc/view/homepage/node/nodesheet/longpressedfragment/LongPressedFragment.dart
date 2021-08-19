

import 'package:hybrid/data/sqlite/mmodel/MFComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MFFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MFMemory.dart';
import 'package:hybrid/data/sqlite/mmodel/MFRule.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/entry/AbstractNodeSheetRoute.dart';

import 'AbstractLongPressedFragment.dart';

class LongPressedFragmentForFragment extends AbstractLongPressedFragment<MFFragment> {
  LongPressedFragmentForFragment(AbstractNodeSheetRoute<MFFragment> fatherRoute, MFFragment currentFragmentModel) : super(fatherRoute, currentFragmentModel);
}

class LongPressedFragmentForMemory extends AbstractLongPressedFragment<MFMemory> {
  LongPressedFragmentForMemory(AbstractNodeSheetRoute<MFMemory> fatherRoute, MFMemory currentFragmentModel) : super(fatherRoute, currentFragmentModel);
}

class LongPressedFragmentForComplete extends AbstractLongPressedFragment<MFComplete> {
  LongPressedFragmentForComplete(AbstractNodeSheetRoute<MFComplete> fatherRoute, MFComplete currentFragmentModel) : super(fatherRoute, currentFragmentModel);
}

class LongPressedFragmentForRule extends AbstractLongPressedFragment<MFRule> {
  LongPressedFragmentForRule(AbstractNodeSheetRoute<MFRule> fatherRoute, MFRule currentFragmentModel) : super(fatherRoute, currentFragmentModel);
}
