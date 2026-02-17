import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  ApiClient._internal()
    : dio = Dio(
        BaseOptions(
          baseUrl: const String.fromEnvironment(
            'BASE_URL',
            defaultValue: 'https://api.example.com',
          ),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add common headers here if needed
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioError e, handler) {
          handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    return dio.get(path, queryParameters: params);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return dio.post(path, data: data, queryParameters: params);
  }
}
