import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../services/storage_service.dart';

class ApiClient {
  final dio.Dio _dio;
  static ApiClient? _instance;

  factory ApiClient() => _instance ??= ApiClient._internal();

  ApiClient._internal()
    : _dio = dio.Dio(
        dio.BaseOptions(
          baseUrl: const String.fromEnvironment(
            'BASE_URL',
            defaultValue: 'https://churchsmartly.com',
          ),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
          responseType: dio.ResponseType.json,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=utf-8',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      ) {
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final storage = Get.find<StorageService>();
            final token = await storage.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (_) {
            // StorageService might not be ready; ignore and continue
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (dio.DioException e, handler) {
          handler.next(e);
        },
      ),
    );
  }

  Future<dio.Response> get(String path, {Map<String, dynamic>? params}) async {
    return _dio.get(path, queryParameters: params);
  }

  /// Download raw bytes from a full URL (used for file downloads).
  Future<dio.Response> getBytes(
    String url, {
    Map<String, dynamic>? params,
  }) async {
    return _dio.get(
      url,
      queryParameters: params,
      options: dio.Options(responseType: dio.ResponseType.bytes),
    );
  }

  Future<dio.Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return _dio.post(path, data: data, queryParameters: params);
  }
}
