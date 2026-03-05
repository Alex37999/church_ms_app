import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../services/storage_service.dart';

class ApiClient {
  final dio.Dio _dio;
  static ApiClient? _instance;
  static bool _handlingAuthFailure = false;

  factory ApiClient() => _instance ??= ApiClient._internal();

  ApiClient._internal()
    : _dio = dio.Dio(
        dio.BaseOptions(
          baseUrl: const String.fromEnvironment(
            'BASE_URL',
            defaultValue: 'https://churchsmartly.com',
          ),
          // Treat 4xx responses as non-errors so callers can inspect response bodies
          validateStatus: (status) => status != null && status < 500,
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
    Future<void> handleUnauthenticated() async {
      if (_handlingAuthFailure) return;
      _handlingAuthFailure = true;

      try {
        if (Get.isRegistered<StorageService>()) {
          await Get.find<StorageService>().clearSession();
        }
      } catch (_) {
        // ignore
      }

      try {
        // Avoid tight loops if we're already on login.
        if (Get.currentRoute != '/login') {
          Get.offAllNamed('/login');
        }
      } catch (_) {
        // ignore
      } finally {
        _handlingAuthFailure = false;
      }
    }

    bool isUnauthenticatedResponse(dio.Response response) {
      try {
        if (response.statusCode == 401) return true;
        final data = response.data;
        if (data is Map) {
          final msg = data['message']?.toString().toLowerCase().trim();
          if (msg != null && msg.contains('unauthenticated')) return true;
        }
      } catch (_) {}
      return false;
    }

    // Add verbose logging to aid debugging (enable in debug builds)
    _dio.interceptors.add(
      dio.LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) {
          // Use Get.log so logs appear in Flutter's logging output
          try {
            Get.log(obj.toString());
          } catch (_) {
            // fallback
            // ignore: avoid_print
            print(obj);
          }
        },
      ),
    );
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
          if (isUnauthenticatedResponse(response)) {
            // When validateStatus allows 4xx responses, Dio won't throw for 401.
            // Handle it here so the app doesn't just show empty/missing data.
            handleUnauthenticated();
          }
          handler.next(response);
        },
        onError: (dio.DioException e, handler) {
          // If the token is invalid/expired, clear local session and return to login.
          // This avoids the app looking "empty" after a cold restart.
          final status = e.response?.statusCode;
          if (status == 401) {
            handleUnauthenticated();
          }
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

  Future<dio.Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return _dio.delete(path, data: data, queryParameters: params);
  }

  /// Build a full URL for a relative API path using the configured baseUrl.
  String buildUrl(String path) {
    final base = _dio.options.baseUrl;
    if (path.startsWith('/')) return base + path;
    return '$base/$path';
  }
}
