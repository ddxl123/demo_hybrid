// ignore_for_file: non_constant_identifier_names

import 'HttpStoreWriter.dart';

void Storer() {
  StoreWrapper(
    method: WriteMethodType.POST,
    path: '/login_and_register_by_email/send_email',
    pathType: WritePathType.no_jwt,
    requestHeadersVOKeys: [],
    requestParamsVOKeys: [],
    requestDataVOKeys: <VOWrapper>[
      VOWrapper(keyName: 'email', type: WriteDataType.STRING, isRequired: true),
    ],
    responseHeadersVOKeys: [],
    responseDataVOKeys: [],
    responseCodeCollect: <CodeWrapper>[
      CodeWrapper(code: 2010101, tip: '邮箱已发送, 请注意查收!'),
    ],
  );

  StoreWrapper(
    method: WriteMethodType.POST,
    path: '/login_and_register_by_email/verify_email',
    pathType: WritePathType.no_jwt,
    requestHeadersVOKeys: [],
    requestParamsVOKeys: [],
    requestDataVOKeys: <VOWrapper>[
      VOWrapper(keyName: 'email', type: WriteDataType.STRING, isRequired: true),
      VOWrapper(keyName: 'code', type: WriteDataType.INT, isRequired: true),
    ],
    responseHeadersVOKeys: [],
    responseDataVOKeys: <VOWrapper>[
      VOWrapper(keyName: 'user_id', type: WriteDataType.INT, isRequired: true),
      VOWrapper(keyName: 'token', type: WriteDataType.STRING, isRequired: true),
    ],
    responseCodeCollect: <CodeWrapper>[
      CodeWrapper(code: 2010201, tip: '注册成功。'),
      CodeWrapper(code: 2010202, tip: '登陆成功。'),
      CodeWrapper(code: 2010203, tip: '邮箱重复异常，请联系管理员！'),
      CodeWrapper(code: 2010204, tip: '验证码不正确！'),
    ],
  );

  StoreWrapper(
    method: WriteMethodType.POST,
    path: '/verify_token',
    pathType: WritePathType.no_jwt,
    requestHeadersVOKeys: [],
    requestParamsVOKeys: [],
    requestDataVOKeys: <VOWrapper>[
      VOWrapper(keyName: 'token', type: WriteDataType.STRING, isRequired: true),
    ],
    responseHeadersVOKeys: [],
    responseDataVOKeys: <VOWrapper>[
      VOWrapper(keyName: 'new_token', type: WriteDataType.STRING, isRequired: true),
    ],
    responseCodeCollect: [],
  );
}
