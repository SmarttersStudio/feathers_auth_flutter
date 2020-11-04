
import 'dart:async';

import 'package:flutter/services.dart';

class FeathersAuthFlutter {
  static const MethodChannel _channel =
      const MethodChannel('feathers_auth_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
