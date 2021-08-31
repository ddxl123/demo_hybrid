        import './creator/ModelCreator.dart';
    
              import '../cmodel/local/CAppVersionInfo.dart';
            import '../cmodel/local/CUpload.dart';
            import '../cmodel/nonlocal/CUser.dart';
            import '../cmodel/nonlocal/f/CFComplete.dart';
            import '../cmodel/nonlocal/f/CFFragment.dart';
            import '../cmodel/nonlocal/f/CFMemory.dart';
            import '../cmodel/nonlocal/f/CFRule.dart';
            import '../cmodel/nonlocal/pn/CPnComplete.dart';
            import '../cmodel/nonlocal/pn/CPnFragment.dart';
            import '../cmodel/nonlocal/pn/CPnMemory.dart';
            import '../cmodel/nonlocal/pn/CPnRule.dart';
      
    class ModelList{
      List<ModelCreator> modelCreators = <ModelCreator>[
            CAppVersionInfo(),
            CUpload(),
            CUser(),
            CFComplete(),
            CFFragment(),
            CFMemory(),
            CFRule(),
            CPnComplete(),
            CPnFragment(),
            CPnMemory(),
            CPnRule(),
      
      ];
    }

    