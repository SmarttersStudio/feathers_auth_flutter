part of feathers_auth_flutter;

class FeathersApp {
  String baseUrl;
  AuthConfig authConfig;
  String _accessToken;
  Dio _dio;
  SharedPreferences _preferences;

  FeathersApp(this.baseUrl, {this.authConfig});

  void configure({String baseUrl, AuthConfig authConfig}) {
    this.baseUrl = baseUrl;
    this.authConfig = authConfig;
  }

  void initialize() async {
    _dio = Dio();
    _preferences = await SharedPreferences.getInstance();
    if (authConfig != null) {
      this._accessToken = _preferences.getString(authConfig.sharedPrefKey);
    }
  }

  FeatherService service(String path) {
    _dio.options.headers['Authorization'] = accessToken;
    return FeatherService(this, path, _dio);
  }

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
