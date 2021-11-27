// ignore_for_file: non_constant_identifier_names

import 'package:hybrid/data/mysql/httpstore/write/HttpStoreManager.dart';

import 'HttpStoreWriteWrapper.dart';

void main() {
  HttpStoreManager.setStoreConfig(
    WriteConfigWrapper(
      // TODO: 使用 https
      baseUrl: 'http://8.134.133.105:7777/',
      connectTimeout: 20000,
      receiveTimeout: 20000,
    ),
  );
  HttpStoreManager.createStores(
    <WriteStoreWrapper>[
      WriteStoreWrapper(
        method: WriteMethodType.POST,
        path: '/login_and_register_by_email/send_email',
        pathType: WritePathType.no_jwt,
        requestHeadersVOKeys: [],
        requestParamsVOKeys: [],
        requestDataVOKeys: <WriteVOWrapper>[
          WriteVOWrapper(keyName: 'email', type: WriteDataType.STRING, isRequired: true),
        ],
        responseHeadersVOKeys: [],
        responseDataVOKeys: [],
        responseCodeCollect: <WriteCodeWrapper>[
          WriteCodeWrapper(code: 2010101, tip: '邮箱已发送, 请注意查收!'),
        ],
      ),
      WriteStoreWrapper(
        method: WriteMethodType.POST,
        path: '/login_and_register_by_email/verify_email',
        pathType: WritePathType.no_jwt,
        requestHeadersVOKeys: [],
        requestParamsVOKeys: [],
        requestDataVOKeys: <WriteVOWrapper>[
          WriteVOWrapper(keyName: 'email', type: WriteDataType.STRING, isRequired: true),
          WriteVOWrapper(keyName: 'code', type: WriteDataType.INT, isRequired: true),
        ],
        responseHeadersVOKeys: [],
        responseDataVOKeys: <WriteVOWrapper>[
          WriteVOWrapper(keyName: 'user_id', type: WriteDataType.INT, isRequired: true),
          WriteVOWrapper(keyName: 'token', type: WriteDataType.STRING, isRequired: true),
        ],
        responseCodeCollect: <WriteCodeWrapper>[
          WriteCodeWrapper(code: 2010201, tip: '邮箱注册成功！'),
          WriteCodeWrapper(code: 2010202, tip: '邮箱登陆成功！'),
        ],
      ),
      WriteStoreWrapper(
        method: WriteMethodType.POST,
        path: '/verify_token',
        pathType: WritePathType.no_jwt,
        requestHeadersVOKeys: [],
        requestParamsVOKeys: [],
        requestDataVOKeys: <WriteVOWrapper>[
          WriteVOWrapper(keyName: 'token', type: WriteDataType.STRING, isRequired: true),
        ],
        responseHeadersVOKeys: [],
        responseDataVOKeys: <WriteVOWrapper>[
          WriteVOWrapper(keyName: 'new_token', type: WriteDataType.STRING, isRequired: true),
        ],
        responseCodeCollect: [],
      ),
    ],
  );
  HttpStoreManager.run();
}
