part of feathers_auth_flutter;

enum RequestMethod { get, post, patch, delete }

class FeatherService {
  FeathersApp app;
  String servicePath;
  Dio dio;
  FeatherService(this.app, this.servicePath, this.dio);
  String get path => app.baseUrl + path;

  Future<Response<T>> get<T>(
      Map<String, dynamic> body, Map<String, dynamic> queryParameters) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<Response<T>> find<T>(
      Map<String, dynamic> body, Map<String, dynamic> queryParameters) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<Response<T>> create<T>(
      Map<String, dynamic> body, Map<String, dynamic> queryParameters) async {
    try {
      final response = await dio.post(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<Response<T>> update<T>(
      Map<String, dynamic> body, Map<String, dynamic> queryParameters) async {
    try {
      final response = await dio.patch(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<Response<T>> patch<T>(
      Map<String, dynamic> body, Map<String, dynamic> queryParameters) async {
    try {
      final response = await dio.patch(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<Response<T>> delete<T>(
      Map<String, dynamic> body, Map<String, dynamic> queryParameters) async {
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
