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

  ///
  /// Configure socket with FeathersSocketOptions and initialize all your event listeners
  ///
  app.configureSocket(
      FeathersSocketOptions('demo.com',
          nameSpace: "/",
          query: {"Authorization": "accssToken"},
          enableLogging: false,
          transports: [TransportType.WEB_SOCKET]),
      initEventListeners: (socket) {
    socket.on('event_1', (data) {
      print("event_1");
    });
    socket.on('event_2', (data) {
      print("event_2");
    });
  });

  ///
  /// Connects to socket
  /// on successful connection an emit authenticate event is fired with enabled acknowledgement
  /// on failure we are getting a callback
  /// like above callbacks, we are getting a few more connection callbacks also
  /// you can also use those as per your requirements
  ///
  app.connectToSocket(onConnect: (data) {
    print("connected...");

    /// emits through socket which takes event name and data as List<dynamic> as its arguments
    app.emitThroughSocket(
        'authenticate',
        [
          {
            "accessToken": "accessToken",
            "strategy": "jwt",
          }
        ],
        withAck: true);
  }, onConnectError: (data) {
    print("some connection error occured");
  });

  ///
  /// First it disposes all the event listeners which you have created at the time of configuration
  /// Then it disposes the socket itself
  /// It takes event names as argument
  ///
  app.disposeSocket(['event_1', 'event_2']);

  ///
  /// Raw Socket io client for more customization
  ///
  app.rawSocket.emitWithAck('event', []);
}
