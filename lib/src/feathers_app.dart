part of feathers_auth_flutter;

abstract class FeathersApp {
  String baseUrl;
  AuthConfig authConfig;
  String accessToken;
  Dio dio;
  SharedPreferences preferences;

  FeathersApp(this.baseUrl, {this.authConfig});

  void configure({String baseUrl, AuthConfig authConfig});
  void initialize();
  FlutterFeatherService service(String path);
  Future<Response<T>> authenticate<T>(
      Map<String, dynamic> body, Map<String, dynamic> queryParameters);
  reAuthenticate(AuthMode authMode);
}

class FlutterFeathersApp extends FeathersApp {
  String baseUrl;
  AuthConfig authConfig;
  String _accessToken;
  Dio _dio;
  SharedPreferences _preferences;

  FlutterFeathersApp(this.baseUrl, {this.authConfig})
      : super(baseUrl, authConfig: authConfig);

  @override
  void configure({String baseUrl, AuthConfig authConfig}) {
    this.baseUrl = baseUrl;
    this.authConfig = authConfig;
  }

  @override
  void initialize() async {
    _dio = Dio();
    _preferences = await SharedPreferences.getInstance();
    super.dio = _dio;
    super.preferences = _preferences;
    if (authConfig != null) {
      this._accessToken = _preferences.getString(authConfig.sharedPrefKey);
      super.accessToken = _accessToken;
    }
  }

  @override
  FlutterFeatherService service(String path) {
    _dio.options.headers['Authorization'] = accessToken;
    return FlutterFeatherService(this, path, _dio);
  }

  @override
  Future<Response<T>> authenticate<T>(
      Map<String, dynamic> body, Map<String, dynamic> queryParameters) async {
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

  String get accessToken => _accessToken;

  set accessToken(String accessToken) {
    _accessToken = accessToken;
    _preferences.setString(authConfig.sharedPrefKey, accessToken);
  }

  Dio get rawDio => _dio;
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
