// ignore_for_file: non_constant_identifier_names

import 'HttpStoreWriter.dart';

void Storer() {
  StoreWrapperPost(
    pathType: WritePathType.no_jwt,
    path: '/login_and_register_by_email/send_email',
    requestDataVOKeys: <DataVOWrapper>[
      DataVOWrapper(keyName: 'email', type: DataVOType.STRING, isRequired: true),
    ],
    responseDataVOKeys: <DataVOWrapper>[],
    responseCodeCollect: <CodeWrapper>[
      CodeWrapper(code: 2010101, tip: '邮箱已发送, 请注意查收!'),
    ],
  );

  StoreWrapperPost(
    pathType: WritePathType.no_jwt,
    path: '/login_and_register_by_email/verify_email',
    requestDataVOKeys: <DataVOWrapper>[
      DataVOWrapper(keyName: 'email', type: DataVOType.STRING, isRequired: true),
      DataVOWrapper(keyName: 'code', type: DataVOType.INT, isRequired: true),
    ],
    responseDataVOKeys: <DataVOWrapper>[
      DataVOWrapper(keyName: 'user_id', type: DataVOType.INT, isRequired: true),
      DataVOWrapper(keyName: 'token', type: DataVOType.STRING, isRequired: true),
    ],
    responseCodeCollect: <CodeWrapper>[
      CodeWrapper(code: 2010201, tip: '注册成功。'),
      CodeWrapper(code: 2010202, tip: '登陆成功。'),
      CodeWrapper(code: 2010203, tip: '邮箱重复异常，请联系管理员！'),
      CodeWrapper(code: 2010204, tip: '验证码不正确！'),
    ],
  );

  StoreWrapperPost(
    pathType: WritePathType.no_jwt,
    path: '/verify_token',
    requestDataVOKeys: <DataVOWrapper>[
      DataVOWrapper(keyName: 'token', type: DataVOType.STRING, isRequired: true),
    ],
    responseDataVOKeys: <DataVOWrapper>[
      DataVOWrapper(keyName: 'new_token', type: DataVOType.STRING, isRequired: true),
    ],
    responseCodeCollect: <CodeWrapper>[],
  );
}
