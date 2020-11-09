# feathers_auth_flutter

Feathers client for Dart

## Features
- Automatically stores access token to shared preference
- Re-authenticate app if access token expires
- Custom service
- Access to handle other outside api calls

## Get Started

### Add dependency

```yaml
dependencies:
  feathers_auth_flutter: #latest version
```

### Import plugin class to your file
```dart
import 'package:feathers_auth_flutter/feathers_auth_flutter.dart';
```

### Initialize
```dart
final FlutterFeathersApp app = FlutterFeathersApp('<base url>',
    authConfig: AuthConfig('<authentication path>',
        authMode: AuthMode.authenticateOnExpire,
        sharedPrefKey: 'accessToken'));

app.initialize();
```

### Authenticate (if required)
```dart
app.authenticate(body: {}, queryParameters: {});
```

### Re-authenticate (if required)
```dart
app.reAuthenticate(AuthMode.authenticateOnExpire);
```

### Create a service
```dart
final FlutterFeatherService userService = app.service('users');
```

### Access your service methods
```dart
final usersRes = await userService.get<String>();
log('USER SERVICE GET ${usersRes.data}');
```

### Additional : Any other apis
```dart
final res = await app.rawDio.get<String>('<any outside urls>');
log('RAW GET ${res.data}');
```

### Configure A Socket
```dart
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
```

### Connect To A Socket
```dart
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
```

### Dispose A Socket
```dart
app.disposeSocket(['event_1', 'event_2']);
```

### For more customization on socket
```dart
app.rawSocket.emitWithAck('event', []);
```