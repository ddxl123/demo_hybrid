    // ignore_for_file: directives_ordering
        import 'ModelBase.dart';
          import 'MAppVersionInfo.dart';
            import 'MUpload.dart';
            import 'MUser.dart';
            import 'MPnRule.dart';
            import 'MFRule.dart';
            import 'MPnComplete.dart';
            import 'MPnFragment.dart';
            import 'MFFragment.dart';
            import 'MFComplete.dart';
            import 'MPnMemory.dart';
            import 'MFMemory.dart';
      
    
    class ModelManager {
          static T createEmptyModelByTableName<T extends ModelBase>(String tableName) {
      switch (tableName) {
              case 'app_version_info':
        return MAppVersionInfo() as T;
            case 'upload':
        return MUpload() as T;
            case 'user':
        return MUser() as T;
            case 'pn_rule':
        return MPnRule() as T;
            case 'f_rule':
        return MFRule() as T;
            case 'pn_complete':
        return MPnComplete() as T;
            case 'pn_fragment':
        return MPnFragment() as T;
            case 'f_fragment':
        return MFFragment() as T;
            case 'f_complete':
        return MFComplete() as T;
            case 'pn_memory':
        return MPnMemory() as T;
            case 'f_memory':
        return MFMemory() as T;
      
        default:
          throw 'unknown tableName: ' + tableName;
      }
    }
    
    }
    