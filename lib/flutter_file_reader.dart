import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'file_reader.dart';

class FlutterFileReader {
  static const MethodChannel _channel = const MethodChannel(channelName);

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///
  /// 初始化 Tencent X5
  /// 插件已实现，自动化加载，此方法仅在您所需要时使用
  ///
  /// only Android, iOS Ignore
  ///
  static Future<bool> initX5() async {
    if (Platform.isAndroid) {
      bool flag = await _channel.invokeMethod('flutterUse');
      return flag;
    }

    // 非Android 返回false
    return false;
  }

  ///
  /// 获取 X5内核 当前状态
  ///
  /// only Android, iOS Ignore
  ///
  static Future<EX5Status?> getX5Status() async {
    if (Platform.isAndroid) {
      int i = await _channel.invokeMethod('initX5Status');
      return EX5StatusExtension.getTypeValue(i);
    }

    // 非Android 返回null
    return null;
  }
}
