import 'package:flutter/services.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

const BasicMessageChannel<Object?> _basicMessageChannel = BasicMessageChannel<Object?>('data_channel', StandardMessageCodec());

// class DataChannel {
//   DataChannel(this.sendEntry, this.receiveEntry, this.key, this.data);
//
//   Future<T> send<T>() async {
//     _basicMessageChannel.send()
//   }
//
//   String sendEntry;
//   String receiveEntry;
//   String key;
//   Map<dynamic, dynamic> data;
// }

Future<void> send() async {
  SbLogger(code: null, viewMessage: 'send', data: null, description: null, exception: null, stackTrace: null);
  final Object? result = await _basicMessageChannel.send(<String, Object?>{'message_key': 'message_value'});
  SbLogger(code: null, viewMessage: result.toString(), data: result, description: null, exception: null, stackTrace: null);
}

Future<void> receive({required Future<Object?> Function(Object? message) handler}) async {
  _basicMessageChannel.setMessageHandler(handler);
}
