import 'dart:async';

import 'package:flutter/services.dart';

class FlutterFileReader {
  static const MethodChannel _channel =
      const MethodChannel('flutter_file_reader');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
