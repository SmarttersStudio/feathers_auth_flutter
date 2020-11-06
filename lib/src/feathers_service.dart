part of feathers_auth_flutter;

enum RequestMethod { get, post, patch, delete }

abstract class FeathersService {
  ///
  /// Required FeathersApp
  ///
  FlutterFeathersApp app;

  ///
  /// Path for custom service
  ///
  String servicePath;

  ///
  /// Dio client for handling APi calls
  ///
  Dio dio;

  FeathersService(this.app, this.servicePath, this.dio);

  ///
  /// Full path/url for api calls
  ///
  String get path => app.baseUrl + path;

  ///
  /// GET method request with optional queryParameters
  ///
  Future<Response<T>> get<T>({Map<String, dynamic> queryParameters});

  ///
  /// FIND method request with required id and optional queryParameters
  ///
  Future<Response<T>> find<T>(String id,
      {Map<String, dynamic> queryParameters});

  ///
  /// CREATE method request with and optional body and query Parameters
  ///
  Future<Response<T>> create<T>(
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters});

  ///
  /// FIND method request with required id and optional queryParameters
  ///
  Future<Response<T>> update<T>(String id,
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters});

  ///
  /// PATCH method request with required id and optional queryParameters
  ///
  Future<Response<T>> patch<T>(String id,
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters});

  ///
  /// DELETE method request with required id and optional queryParameters
  ///
  Future<Response<T>> delete<T>(String id,
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters});
}

class FlutterFeatherService extends FeathersService {
  FlutterFeathersApp app;
  String servicePath;
  Dio dio;
  FlutterFeatherService(this.app, this.servicePath, this.dio)
      : super(app, servicePath, dio);

  @override
  String get path => app.baseUrl + path;

  @override
  Future<Response<T>> get<T>({Map<String, dynamic> queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  @override
  Future<Response<T>> find<T>(String id,
      {Map<String, dynamic> queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  @override
  Future<Response<T>> create<T>(
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters}) async {
    try {
      final response = await dio.post(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  @override
  Future<Response<T>> update<T>(String id,
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters}) async {
    try {
      final response = await dio.patch(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  @override
  Future<Response<T>> patch<T>(String id,
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters}) async {
    try {
      final response = await dio.patch(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  @override
  Future<Response<T>> delete<T>(String id,
      {Map<String, dynamic> body, Map<String, dynamic> queryParameters}) async {
    try {
      final response = await dio.delete(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  Future _handleError(error) {
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
