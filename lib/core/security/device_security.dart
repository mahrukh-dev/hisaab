import 'package:flutter/services.dart';

class DeviceSecurity {
  const DeviceSecurity._();

  static const MethodChannel _channel = MethodChannel('hisaab/security');

  static Future<void> setSecureMode({required bool enabled}) async {
    try {
      await _channel.invokeMethod<void>('setSecureMode', {'enabled': enabled});
    } on MissingPluginException {
      // Ignore when the plugin is unavailable in test or non-Android environments.
    }
  }
}
