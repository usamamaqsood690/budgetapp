/// API Client - Singleton Pattern Implementation
/// Handles all HTTP requests with interceptors, error handling, and logging
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/envirnment/envirnment_config.dart';
import 'package:wealthnxai/presentation/modules/auth/page/session_expire/controller/session_expired_controller.dart';
import '../services/storage_service.dart';
import '../services/teams_webhook_service.dart';

class ApiClient {
  static ApiClient? _instance;
  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  late dio.Dio _dio;
  final StorageService _storageService = StorageService.instance;
  final SessionExpiredController _sessionExpiredController =
      SessionExpiredController.instance;

  // Private constructor
  ApiClient._internal() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: EnvironmentConfig.getBaseUrl(),
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _initializeInterceptors();
  }

  /// Update base URL when environment changes
  void updateBaseUrl() {
    _dio.options.baseUrl = EnvironmentConfig.getBaseUrl();
    if (kDebugMode) {
      print('🔄 API Base URL updated to: ${_dio.options.baseUrl}');
    }
  }

  /// Initialize interceptors for logging and token injection
  void _initializeInterceptors() {
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Let Dio set Content-Type automatically for FormData
          if (options.data is dio.FormData) {
            options.headers.remove('Content-Type');
          }

          if (kDebugMode) {
            print(
              '🚀 REQUEST[${options.method}] => ${EnvironmentConfig.getBaseUrl()}${options.path}',
            );
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              '✅ RESPONSE[${response.statusCode}] => ${EnvironmentConfig.getBaseUrl()}${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print(
              '❌ ERROR[${error.response?.statusCode}] => ${EnvironmentConfig.getBaseUrl()}${error.requestOptions.path}',
            );
          }

          // Delegate unauthorized (401) handling to session-expired controller
          // Skip auth endpoints like login / signup – those are handled in the UI.
          if (error.response?.statusCode == 401 &&
              !_isAuthEndpoint(error.requestOptions.path)) {
            await _sessionExpiredController.handleUnauthorized();
          }

          // Send error notification to Teams webhook (non-blocking)
          TeamsWebhookService.instance.sendErrorNotification(error);
          return handler.next(error);
        },
      ),
    );
  }

  /// Returns true if the given path is an auth endpoint that should NOT
  /// trigger the global session-expired dialog (e.g. login, signup).
  bool _isAuthEndpoint(String path) {
    // Ensure we're only comparing the path segment (no base URL).
    // ApiConstants paths already start with a leading slash.
    return path == ApiConstants.login || path == ApiConstants.register;
  }

  /// Build path with optional user ID
  Future<String> _buildPath(String path, bool includeUserId) async {
    if (includeUserId) {
      final userId = await _storageService.getUserId();
      if (userId != null && userId.isNotEmpty) {
        final normalizedPath = path.startsWith('/') ? path : '/$path';
        return '/$userId$normalizedPath';
      }
    }
    return path;
  }

  Future<dio.Response> get(
    String path, {
    bool includeUserId = false,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) async {
    try {
      final finalPath = await _buildPath(path, includeUserId);
      return await _dio.get(
        finalPath,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> post(
    String path, {
    bool includeUserId = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) async {
    try {
      final finalPath = await _buildPath(path, includeUserId);
      return await _dio.post(
        finalPath,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> put(
    String path, {
    bool includeUserId = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) async {
    try {
      final finalPath = await _buildPath(path, includeUserId);
      return await _dio.put(
        finalPath,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> delete(
    String path, {
    bool includeUserId = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) async {
    try {
      final finalPath = await _buildPath(path, includeUserId);
      return await _dio.delete(
        finalPath,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }
}
