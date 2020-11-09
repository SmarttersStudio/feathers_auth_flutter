part of feathers_auth_flutter;

abstract class FeathersApp {
  ///
  /// Base url
  ///
  String baseUrl;

  ///
  /// Authentication configurations
  ///
  AuthConfig authConfig;

  ///
  /// Access token is authorised
  ///
  String accessToken;

  ///
  /// Dio client
  ///
  Dio _dio;

  ///
  /// Shared preference for storing token
  ///
  SharedPreferences preferences;

  ///
  /// Socket io client to manage bi-directional event based communication
  ///
  SocketIO _socket;

  ///
  /// Socket manager to connect client to a given server
  ///
  SocketIOManager _socketManager;

  FeathersApp(this.baseUrl, {this.authConfig});

  ///
  /// Configure app using base url and authentication configurations
  ///
  void configure({String baseUrl, AuthConfig authConfig});

  ///
  /// Initialize app
  ///
  void initialize();

  FlutterFeatherService service(String path);

  ///
  /// Authenticate your app and store access token to your shared preference with provided key
  ///
  Future<Response<T>> authenticate<T>(
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters});

  ///
  /// Re-authenticate app and update access token
  ///
  reAuthenticate(AuthMode authMode);

  ///
  /// Configure Socket with [FeathersSocketOptions] and optional event listeners
  ///
  void configureSocket(FeathersSocketOptions options,
      {Function(SocketIO socket) initEventListeners});

  ///
  /// Connect to the socket with some optional connection listeners
  ///
  void connectToSocket(
      {Function(dynamic data) onConnect,
      Function(dynamic data) onConnectError,
      Function(dynamic data) onConnecting,
      Function(dynamic data) onConnectionTimeOut,
      Function(dynamic data) onDisconnect,
      Function(dynamic data) onReconnect,
      Function(dynamic data) onReconnecting,
      Function(dynamic data) onReconnectError,
      Function(dynamic data) onReconnectFailed,
      Function(dynamic data) onError,
      Function(dynamic data) onPing,
      Function(dynamic data) onPong});

  ///
  /// Dispose socket
  ///
  void disposeSocket([List<String> events]);
}

///
/// Implementation of FeathersApp
///
class FlutterFeathersApp extends FeathersApp {
  FlutterFeathersApp(String baseUrl, {AuthConfig authConfig})
      : super(baseUrl, authConfig: authConfig);

  @override
  void configure({String baseUrl, AuthConfig authConfig}) {
    this.baseUrl = baseUrl;
    this.authConfig = authConfig;
  }

  @override
  void initialize() async {
    _dio = Dio();
    preferences = await SharedPreferences.getInstance();
    super._dio = _dio;
    super.preferences = preferences;
    if (authConfig != null) {
      this.accessToken = preferences.getString(authConfig.sharedPrefKey);
      super.accessToken = accessToken;
    }
  }

  ///
  /// Returns a FeatherService with provided path
  /// included access token in header of Dio client
  ///
  @override
  FlutterFeatherService service(String path) {
    _dio.options.headers['Authorization'] = accessToken;
    return FlutterFeatherService(this, path, _dio);
  }

  @override
  Future<Response<T>> authenticate<T>(
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters}) async {
    try {
      // _dio.options.headers['Authorization'] = null;
      final response = await _dio.post('$baseUrl${authConfig.authPath}',
          queryParameters: queryParameters);
      accessToken = response.data['accessToken'];
      return response;
    } catch (error) {
      if (error.response == null) {
        return Future.error(FeathersError.noInternet());
      } else if (error is DioError) {
        return Future.error(FeathersError.fromJson(error.response.data));
      } else {
        return Future.error(FeathersError(
            message: error.toString(), name: 'Some error occurred'));
      }
    }
  }

  ///
  /// Re-authenticate app and update access token if provided authentication mode
  ///
  @override
  reAuthenticate(AuthMode mode) {
    if (accessToken?.isEmpty ?? true) {
      // authenticate(body, queryParameters);
    } else {
      switch (mode) {
        case AuthMode.forceAuthenticate:
          break;
        case AuthMode.neverAuthenticate:
          break;
        case AuthMode.authenticateOnExpire:
          break;
      }
    }
  }

  ///
  /// Configures the socket with required [FeathersSocketOptions]
  /// Also takes some event listeners as optional named parameter
  ///
  @override
  Future<void> configureSocket(FeathersSocketOptions options,
      {Function(SocketIO socket) initEventListeners}) async {
    List<Transports> transports = [];
    options.transports.forEach((element) {
      if (element == TransportType.WEB_SOCKET) {
        transports.add(Transports.WEB_SOCKET);
      } else if (element == TransportType.POLLING) {
        transports.add(Transports.POLLING);
      }
    });
    _socketManager = SocketIOManager();
    _socket = await _socketManager.createInstance(SocketOptions(options.uri,
        query: options.query,
        enableLogging: options.enableLogging,
        nameSpace: options.nameSpace,
        path: options.path,
        transports: transports));
    super._socketManager = _socketManager;
    super._socket = _socket;
    initEventListeners(_socket);
  }

  ///
  /// Connects to socket with some optional connection listeners
  ///
  @override
  Future<void> connectToSocket({
    Function(dynamic data) onConnect,
    Function(dynamic data) onConnectError,
    Function(dynamic data) onConnecting,
    Function(dynamic data) onConnectionTimeOut,
    Function(dynamic data) onDisconnect,
    Function(dynamic data) onReconnect,
    Function(dynamic data) onReconnecting,
    Function(dynamic data) onReconnectError,
    Function(dynamic data) onReconnectFailed,
    Function(dynamic data) onError,
    Function(dynamic data) onPing,
    Function(dynamic data) onPong,
  }) async {
    if (await _socket?.isConnected()) {
      _socketManager?.clearInstance(_socket);
    }
    _socket?.onConnecting(onConnecting);
    _socket?.onConnect(onConnect);
    _socket?.onConnectError(onConnectError);
    _socket?.onConnectTimeout(onConnectionTimeOut);
    _socket?.onDisconnect(onDisconnect);
    _socket?.onReconnect(onReconnect);
    _socket?.onReconnecting(onReconnecting);
    _socket?.onReconnectError(onReconnectError);
    _socket?.onReconnectFailed(onReconnectFailed);
    _socket?.onError(onError);
    _socket?.onPing(onPing);
    _socket?.onPong(onPong);
    _socket?.connect();
  }

  ///
  /// Dispose all event listeners and socket io client
  ///
  @override
  Future<void> disposeSocket([List<String> events]) async {
    events.forEach((event) {
      _socket?.off(event);
    });
    if (await _socket?.isConnected()) {
      _socketManager?.clearInstance(_socket);
    }
  }

  ///
  /// Get access token if authenticated otherwise return null
  ///
  String get accessToken => accessToken;

  ///
  /// Set the access token and update to shared preference
  ///
  set accessToken(String accessToken) {
    accessToken = accessToken;
    preferences.setString(authConfig.sharedPrefKey, accessToken);
  }

  ///
  /// Raw dio client for other api calls
  ///
  Dio get rawDio => _dio;

  ///
  /// Raw Socket IO client for other operations
  ///
  SocketIO get rawSocket => _socket;

  ///
  /// Raw Socket IO Manager for other operations
  ///
  SocketIOManager get rawSocketManager => _socketManager;
}

class AuthConfig {
  String authPath;
  String sharedPrefKey;
  AuthMode authMode;

  AuthConfig(this.authPath,
      {this.sharedPrefKey = '', this.authMode = AuthMode.authenticateOnExpire})
      : assert(authPath != null, 'Authentication path must not be null'),
        assert(sharedPrefKey != null, 'Shared preference key must not be null'),
        assert(authMode != null, 'Authentication mode must not be null');
}

enum AuthMode { forceAuthenticate, neverAuthenticate, authenticateOnExpire }
