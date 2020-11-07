import 'dart:developer';
import 'dart:async';
import 'package:feathers_auth_flutter/feathers_auth_flutter.dart';

Future<void> main() async {
  ///
  /// Initialize app with your base url and authentication configs if any
  ///
  FlutterFeathersApp app = FlutterFeathersApp('<base url>',
      authConfig: AuthConfig('<authentication path>',
          authMode: AuthMode.authenticateOnExpire,
          sharedPrefKey: 'accessToken'));

  app.initialize();

  ///
  /// Authenticate your app
  ///
  app.authenticate(body: {}, queryParameters: {});

  ///
  /// Re-authenticate your app if needed
  ///
  app.reAuthenticate(AuthMode.authenticateOnExpire);

  ///
  /// If you need to access any other api rather than your base url
  /// app.rawDio you provide you raw Dio client without access token attached to header
  ///
  final res = await app.rawDio.get<String>('<any outside urls>');
  log('RAW GET ${res.data}');

  ///
  /// Create you service providing service path
  ///
  final FlutterFeatherService userService = app.service('users');

  ///
  /// Get response from service
  ///
  final usersRes = await userService.get<String>();
  log('USER SERVICE GET ${usersRes.data}');
}
