/// Teams Webhook Service - Sends error notifications to Microsoft Teams
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/envirnment/envirnment_config.dart';
import 'package:wealthnxai/core/services/storage_service.dart';

class TeamsWebhookService {
  static TeamsWebhookService? _instance;
  static TeamsWebhookService get instance {
    _instance ??= TeamsWebhookService._internal();
    return _instance!;
  }

  TeamsWebhookService._internal();

  final Dio _dio = Dio();
  final StorageService _storageService = StorageService.instance;
  final Connectivity _connectivity = Connectivity();
  DeviceInfoPlugin? _deviceInfo;
  PackageInfo? _packageInfo;

  /// Initialize device info (call this once at app startup)
  Future<void> initialize() async {
    try {
      _deviceInfo = DeviceInfoPlugin();
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to initialize TeamsWebhookService: $e');
      }
    }
  }

  /// Send error notification to Teams webhook
  Future<void> sendErrorNotification(DioException error) async {
    try {
      final webhookUrl = ApiConstants.teamsWebhookUrl;

      // Skip if webhook URL is not configured
      if (webhookUrl == null || webhookUrl.isEmpty) {
        if (kDebugMode) {
          print(
            '⚠️ Teams webhook URL not configured. Skipping error notification.',
          );
        }
        return;
      }

      // Collect error details
      final errorDetails = await _collectErrorDetails(error);

      // Format message for Teams
      final message = _formatTeamsMessage(errorDetails);

      // Send to Teams webhook
      await _dio.post(
        webhookUrl,
        data: jsonEncode(message),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500, // Accept 2xx, 3xx, 4xx
        ),
      );
    } catch (e) {
      // Silently fail - we don't want webhook errors to break the app
      if (kDebugMode) {
        print('⚠️ Failed to send Teams webhook notification: $e');
      }
    }
  }

  /// Collect comprehensive error details
  Future<Map<String, dynamic>> _collectErrorDetails(DioException error) async {
    final requestOptions = error.requestOptions;
    final response = error.response;

    // Get device info
    Map<String, dynamic> deviceInfo = {};
    try {
      if (_deviceInfo != null) {
        if (Platform.isAndroid) {
          final androidInfo = await _deviceInfo!.androidInfo;
          deviceInfo = {
            'platform': 'Android',
            'model': androidInfo.model,
            'manufacturer': androidInfo.manufacturer,
            'brand': androidInfo.brand,
            'device': androidInfo.device,
            'androidId': androidInfo.id,
            'version': {
              'sdkInt': androidInfo.version.sdkInt,
              'release': androidInfo.version.release,
              'codename': androidInfo.version.codename,
            },
            'isPhysicalDevice': androidInfo.isPhysicalDevice,
          };
        } else if (Platform.isIOS) {
          final iosInfo = await _deviceInfo!.iosInfo;
          deviceInfo = {
            'platform': 'iOS',
            'name': iosInfo.name,
            'model': iosInfo.model,
            'systemName': iosInfo.systemName,
            'systemVersion': iosInfo.systemVersion,
            'identifierForVendor': iosInfo.identifierForVendor,
            'isPhysicalDevice': iosInfo.isPhysicalDevice,
            'utsname': {
              'machine': iosInfo.utsname.machine,
              'nodename': iosInfo.utsname.nodename,
              'release': iosInfo.utsname.release,
              'sysname': iosInfo.utsname.sysname,
              'version': iosInfo.utsname.version,
            },
          };
        }
      }
    } catch (e) {
      deviceInfo = {'error': 'Failed to get device info: $e'};
    }

    // Get app info
    Map<String, dynamic> appInfo = {};
    try {
      if (_packageInfo != null) {
        appInfo = {
          'appName': _packageInfo!.appName,
          'packageName': _packageInfo!.packageName,
          'version': _packageInfo!.version,
          'buildNumber': _packageInfo!.buildNumber,
        };
      }
    } catch (e) {
      appInfo = {'error': 'Failed to get app info: $e'};
    }

    // Get user info
    String? userId;
    String? userEmail;
    try {
      userId = await _storageService.getUserId();
      userEmail = await _storageService.getUserEmail();
    } catch (e) {
      // Ignore errors
    }

    // Sanitize headers (remove sensitive data)
    final sanitizedHeaders = _sanitizeHeaders(requestOptions.headers);

    // Sanitize request data
    final sanitizedRequestData = _sanitizeData(requestOptions.data);

    // Get response data
    dynamic responseData;
    int? responseDataSize;
    try {
      responseData = response?.data;
      if (responseData is Map || responseData is List) {
        final jsonStr = jsonEncode(responseData);
        responseData = jsonStr;
        responseDataSize = jsonStr.length;
      } else if (responseData is String) {
        responseDataSize = responseData.length;
      }
    } catch (e) {
      responseData =
          response?.data?.toString() ?? 'Unable to parse response data';
    }

    // Get network connectivity status
    Map<String, dynamic> networkInfo = {};
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      networkInfo = {
        'isConnected':
            connectivityResult.isNotEmpty &&
            !connectivityResult.contains(ConnectivityResult.none),
        'connectionTypes': connectivityResult.map((e) => e.toString()).toList(),
        'hasWifi': connectivityResult.contains(ConnectivityResult.wifi),
        'hasMobile': connectivityResult.contains(ConnectivityResult.mobile),
        'hasEthernet': connectivityResult.contains(ConnectivityResult.ethernet),
      };
    } catch (e) {
      networkInfo = {'error': 'Failed to get network info: $e'};
    }

    // Calculate request data size
    int? requestDataSize;
    try {
      if (sanitizedRequestData != null) {
        if (sanitizedRequestData is String) {
          requestDataSize = sanitizedRequestData.length;
        } else if (sanitizedRequestData is Map ||
            sanitizedRequestData is List) {
          requestDataSize = jsonEncode(sanitizedRequestData).length;
        }
      }
    } catch (e) {
      // Ignore
    }

    // Get error category
    String errorCategory = 'Unknown';
    String errorSeverity = 'Medium';
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      errorCategory = 'Timeout';
      errorSeverity = 'High';
    } else if (error.type == DioExceptionType.connectionError) {
      errorCategory = 'Connection Error';
      errorSeverity = 'High';
    } else if (error.type == DioExceptionType.badResponse) {
      errorCategory = 'HTTP Error';
      if (response?.statusCode != null) {
        if (response!.statusCode! >= 500) {
          errorSeverity = 'Critical';
        } else if (response.statusCode! >= 400) {
          errorSeverity = 'High';
        }
      }
    } else if (error.type == DioExceptionType.cancel) {
      errorCategory = 'Cancelled';
      errorSeverity = 'Low';
    } else if (error.type == DioExceptionType.badCertificate) {
      errorCategory = 'Certificate Error';
      errorSeverity = 'High';
    } else if (error.type == DioExceptionType.unknown) {
      errorCategory = 'Unknown Error';
      errorSeverity = 'Medium';
    }

    return {
      'timestamp': DateTime.now().toIso8601String(),
      'environment': EnvironmentConfig.getEnvironmentDisplayName(
        EnvironmentConfig.current,
      ),
      'errorType': error.type.toString(),
      'errorCategory': errorCategory,
      'errorSeverity': errorSeverity,
      'errorMessage': error.message ?? 'Unknown error',
      'statusCode': response?.statusCode,
      'request': {
        'method': requestOptions.method,
        'baseUrl': requestOptions.baseUrl,
        'path': requestOptions.path,
        'url': '${requestOptions.baseUrl}${requestOptions.path}',
        'fullUrl': requestOptions.uri.toString(),
        'scheme': requestOptions.uri.scheme,
        'host': requestOptions.uri.host,
        'port': requestOptions.uri.port,
        'uriPath': requestOptions.uri.path,
        'query': requestOptions.uri.query,
        'headers': sanitizedHeaders,
        'headersCount': sanitizedHeaders.length,
        'queryParameters': requestOptions.queryParameters,
        'queryParametersCount': requestOptions.queryParameters.length,
        'data': sanitizedRequestData,
        'dataSize': requestDataSize,
        'contentType': requestOptions.contentType,
        'responseType': requestOptions.responseType.toString(),
        'followRedirects': requestOptions.followRedirects,
        'maxRedirects': requestOptions.maxRedirects,
        'connectTimeout': requestOptions.connectTimeout?.inMilliseconds,
        'receiveTimeout': requestOptions.receiveTimeout?.inMilliseconds,
        'sendTimeout': requestOptions.sendTimeout?.inMilliseconds,
        'extra': requestOptions.extra,
      },
      'response': {
        'statusCode': response?.statusCode,
        'statusMessage': response?.statusMessage,
        'headers': response?.headers.map,
        'headersCount': response?.headers.map.length ?? 0,
        'data': responseData,
        'dataSize': responseDataSize,
        'realUri': response != null ? response.realUri.toString() : null,
        'extra': response?.extra,
      },
      'network': networkInfo,
      'user': {
        'userId': userId,
        'email': userEmail,
        'fullName': await _storageService.getUserFullName(),
        'phone': await _storageService.getUserPhone(),
      },
      'device': deviceInfo,
      'app': appInfo,
      'stackTrace': error.stackTrace.toString(),
      'dioErrorType': error.type.toString(),
    };
  }

  /// Sanitize headers to remove sensitive information
  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);
    final sensitiveKeys = ['authorization', 'cookie', 'x-api-key', 'api-key'];

    for (var key in sensitiveKeys) {
      if (sanitized.containsKey(key)) {
        sanitized[key] = '***REDACTED***';
      }
      // Case-insensitive check
      sanitized.removeWhere(
        (k, v) => k.toLowerCase() == key.toLowerCase() && k != key,
      );
    }

    return sanitized;
  }

  /// Sanitize request data to remove sensitive information
  dynamic _sanitizeData(dynamic data) {
    if (data == null) return null;

    if (data is FormData) {
      // For FormData, return a summary
      return {
        'type': 'FormData',
        'fields': data.fields.length,
        'files': data.files.length,
      };
    }

    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);
      final sensitiveKeys = [
        'password',
        'token',
        'secret',
        'apiKey',
        'api_key',
        'authorization',
      ];

      for (var key in sensitiveKeys) {
        if (sanitized.containsKey(key)) {
          sanitized[key] = '***REDACTED***';
        }
        // Case-insensitive check
        sanitized.removeWhere(
          (k, v) => k.toLowerCase().contains(key.toLowerCase()) && k != key,
        );
      }

      return sanitized;
    }

    if (data is String) {
      try {
        final parsed = jsonDecode(data);
        return _sanitizeData(parsed);
      } catch (e) {
        // If it's not JSON, check if it contains sensitive info
        final lowerData = data.toLowerCase();
        if (lowerData.contains('password') ||
            lowerData.contains('token') ||
            lowerData.contains('secret')) {
          return '***REDACTED - Contains sensitive data***';
        }
        return data;
      }
    }

    return data.toString();
  }

  /// Format error details as Teams message card
  Map<String, dynamic> _formatTeamsMessage(Map<String, dynamic> errorDetails) {
    final statusCode = errorDetails['statusCode'] ?? 'N/A';
    final errorType = errorDetails['errorType'] ?? 'Unknown';
    final errorMessage = errorDetails['errorMessage'] ?? 'No message';
    final method = errorDetails['request']?['method'] ?? 'N/A';
    final url = errorDetails['request']?['url'] ?? 'N/A';
    final environment = errorDetails['environment'] ?? 'Unknown';
    final timestamp = errorDetails['timestamp'] ?? 'Unknown';

    // Determine color based on status code
    String color = 'FF0000'; // Red for errors
    if (statusCode is int) {
      if (statusCode >= 500) {
        color = 'FF0000'; // Red for server errors
      } else if (statusCode >= 400) {
        color = 'FFA500'; // Orange for client errors
      } else {
        color = 'FFFF00'; // Yellow for other errors
      }
    }

    // Get additional details
    final errorCategory = errorDetails['errorCategory'] ?? 'Unknown';
    final errorSeverity = errorDetails['errorSeverity'] ?? 'Medium';
    final request = errorDetails['request'];
    final response = errorDetails['response'];
    final network = errorDetails['network'];
    final user = errorDetails['user'];
    final device = errorDetails['device'];
    final app = errorDetails['app'];

    // Build facts array for Teams card
    final facts = <Map<String, String>>[
      {'name': '🔴 Severity', 'value': errorSeverity},
      {'name': '📦 Category', 'value': errorCategory},
      {'name': '🌍 Environment', 'value': environment},
      {'name': '⏰ Timestamp', 'value': timestamp},
      {'name': '🔧 Error Type', 'value': errorType},
      {'name': '📊 Status Code', 'value': statusCode.toString()},
      {'name': '🔨 Method', 'value': method},
    ];

    // Add URL (truncate if too long)
    String displayUrl = url;
    if (displayUrl.length > 100) {
      displayUrl = '${displayUrl.substring(0, 100)}...';
    }
    facts.add({'name': '🔗 URL', 'value': displayUrl});

    // Add network connectivity
    if (network != null && network['isConnected'] != null) {
      final isConnected = network['isConnected'] as bool;
      final connectionTypes = network['connectionTypes'] as List?;
      facts.add({
        'name': '📡 Network',
        'value':
            isConnected
                ? 'Connected (${connectionTypes?.join(", ") ?? "Unknown"})'
                : 'Not Connected',
      });
    }

    // Add user info if available
    if (user != null) {
      if (user['userId'] != null) {
        facts.add({'name': '👤 User ID', 'value': user['userId']});
      }
      if (user['email'] != null) {
        facts.add({'name': '📧 Email', 'value': user['email']});
      }
      if (user['fullName'] != null) {
        facts.add({'name': '👥 Full Name', 'value': user['fullName']});
      }
      if (user['phone'] != null) {
        facts.add({'name': '📱 Phone', 'value': user['phone']});
      }
    }

    // Add device info
    if (device != null) {
      if (device['platform'] != null) {
        final platform = device['platform'] as String;
        final version =
            device['version']?['release'] ?? device['systemVersion'] ?? '';
        facts.add({'name': '📱 Platform', 'value': '$platform $version'});
      }
      if (device['model'] != null) {
        facts.add({'name': '📲 Device Model', 'value': device['model']});
      }
      if (device['manufacturer'] != null) {
        facts.add({'name': '🏭 Manufacturer', 'value': device['manufacturer']});
      }
      if (device['brand'] != null) {
        facts.add({'name': '🏷️ Brand', 'value': device['brand']});
      }
      if (device['isPhysicalDevice'] != null) {
        facts.add({
          'name': '💻 Device Type',
          'value':
              device['isPhysicalDevice'] == true
                  ? 'Physical Device'
                  : 'Emulator/Simulator',
        });
      }
    }

    // Add app version
    if (app != null) {
      if (app['version'] != null) {
        facts.add({
          'name': '📦 App Version',
          'value': '${app['version']} (Build ${app['buildNumber']})',
        });
      }
      if (app['packageName'] != null) {
        facts.add({'name': '📋 Package', 'value': app['packageName']});
      }
    }

    // Build sections
    final sections = <Map<String, dynamic>>[
      {
        'activityTitle': '🚨 API Error Alert - $errorSeverity',
        'activitySubtitle': errorMessage,
        'facts': facts,
        'markdown': true,
      },
    ];

    // Add comprehensive request details section
    if (request != null) {
      final requestFacts = <Map<String, String>>[];

      // URL Details
      if (request['fullUrl'] != null) {
        requestFacts.add({'name': '🔗 Full URL', 'value': request['fullUrl']});
      }
      if (request['scheme'] != null) {
        requestFacts.add({'name': '🔐 Scheme', 'value': request['scheme']});
      }
      if (request['host'] != null) {
        requestFacts.add({'name': '🌐 Host', 'value': request['host']});
      }
      if (request['port'] != null && request['port'] > 0) {
        requestFacts.add({
          'name': '🔌 Port',
          'value': request['port'].toString(),
        });
      }

      // Headers
      if (request['headersCount'] != null && request['headersCount'] > 0) {
        requestFacts.add({
          'name': '📋 Headers Count',
          'value': '${request['headersCount']} headers',
        });
        // Show some important headers
        final headers = request['headers'] as Map?;
        if (headers != null) {
          final importantHeaders = [
            'content-type',
            'accept',
            'user-agent',
            'x-requested-with',
          ];
          for (var headerKey in importantHeaders) {
            // Find header by case-insensitive key lookup
            String? headerValue;
            try {
              final entry = headers.entries.firstWhere(
                (e) => e.key.toString().toLowerCase() == headerKey,
              );
              headerValue = entry.value?.toString();
            } catch (e) {
              // Header not found, try direct lookup
              for (var key in headers.keys) {
                if (key.toString().toLowerCase() == headerKey) {
                  headerValue = headers[key]?.toString();
                  break;
                }
              }
            }
            if (headerValue != null && headerValue.isNotEmpty) {
              requestFacts.add({
                'name': '📄 ${headerKey.toUpperCase()}',
                'value': headerValue,
              });
            }
          }
        }
      }

      // Query Parameters
      if (request['queryParametersCount'] != null &&
          request['queryParametersCount'] > 0) {
        final queryParams = request['queryParameters'] as Map?;
        if (queryParams != null && queryParams.isNotEmpty) {
          String queryStr = jsonEncode(queryParams);
          if (queryStr.length > 300) {
            queryStr = '${queryStr.substring(0, 300)}... (truncated)';
          }
          requestFacts.add({'name': '🔍 Query Parameters', 'value': queryStr});
        }
      }

      // Request Data
      if (request['data'] != null) {
        final requestData = request['data'];
        String dataStr;
        if (requestData is Map || requestData is List) {
          dataStr = jsonEncode(requestData);
        } else {
          dataStr = requestData.toString();
        }
        // Show size if available
        if (request['dataSize'] != null) {
          final sizeKB = (request['dataSize'] as int) / 1024;
          requestFacts.add({
            'name': '📦 Request Size',
            'value': '${sizeKB.toStringAsFixed(2)} KB',
          });
        }
        // Truncate if too long
        if (dataStr.length > 800) {
          dataStr = '${dataStr.substring(0, 800)}... (truncated)';
        }
        requestFacts.add({'name': '📤 Request Body', 'value': dataStr});
      }

      // Timeouts
      if (request['connectTimeout'] != null ||
          request['receiveTimeout'] != null ||
          request['sendTimeout'] != null) {
        final timeouts = <String>[];
        if (request['connectTimeout'] != null) {
          timeouts.add('Connect: ${request['connectTimeout']}ms');
        }
        if (request['receiveTimeout'] != null) {
          timeouts.add('Receive: ${request['receiveTimeout']}ms');
        }
        if (request['sendTimeout'] != null) {
          timeouts.add('Send: ${request['sendTimeout']}ms');
        }
        requestFacts.add({'name': '⏱️ Timeouts', 'value': timeouts.join(', ')});
      }

      // Content Type
      if (request['contentType'] != null) {
        requestFacts.add({
          'name': '📄 Content Type',
          'value': request['contentType'],
        });
      }

      if (requestFacts.isNotEmpty) {
        sections.add({'title': '📤 Request Details', 'facts': requestFacts});
      }
    }

    // Add comprehensive response details section
    if (response != null) {
      final responseFacts = <Map<String, String>>[];

      // Status details
      if (response['statusCode'] != null) {
        responseFacts.add({
          'name': '📊 Status Code',
          'value':
              '${response['statusCode']} ${response['statusMessage'] ?? ''}',
        });
      }

      // Headers
      if (response['headersCount'] != null && response['headersCount'] > 0) {
        responseFacts.add({
          'name': '📋 Response Headers',
          'value': '${response['headersCount']} headers',
        });
        // Show some important response headers
        final headers = response['headers'] as Map?;
        if (headers != null) {
          final importantHeaders = [
            'content-type',
            'content-length',
            'server',
            'date',
          ];
          for (var headerKey in importantHeaders) {
            // Find header by case-insensitive key lookup
            String? headerValue;
            try {
              final entry = headers.entries.firstWhere(
                (e) => e.key.toString().toLowerCase() == headerKey,
              );
              headerValue = entry.value?.toString();
            } catch (e) {
              // Header not found, try direct lookup
              for (var key in headers.keys) {
                if (key.toString().toLowerCase() == headerKey) {
                  headerValue = headers[key]?.toString();
                  break;
                }
              }
            }
            if (headerValue != null && headerValue.isNotEmpty) {
              responseFacts.add({
                'name': '📄 ${headerKey.toUpperCase()}',
                'value': headerValue,
              });
            }
          }
        }
      }

      // Response Data
      if (response['data'] != null) {
        String responseData = response['data'].toString();

        // Show size if available
        if (response['dataSize'] != null) {
          final sizeKB = (response['dataSize'] as int) / 1024;
          responseFacts.add({
            'name': '📦 Response Size',
            'value': '${sizeKB.toStringAsFixed(2)} KB',
          });
        }

        // Truncate if too long
        if (responseData.length > 1000) {
          responseData = '${responseData.substring(0, 1000)}... (truncated)';
        }

        responseFacts.add({'name': '📥 Response Body', 'value': responseData});
      }

      // Check if it's a redirect status code
      if (response['statusCode'] != null) {
        final statusCode = response['statusCode'] as int;
        if (statusCode >= 300 && statusCode < 400) {
          responseFacts.add({
            'name': '🔄 Redirect',
            'value': 'Yes (Status: $statusCode)',
          });
        }
      }

      // Real URI (if different from request)
      if (response['realUri'] != null &&
          response['realUri'] != request?['fullUrl']) {
        responseFacts.add({
          'name': '🔗 Final URI',
          'value': response['realUri'],
        });
      }

      if (responseFacts.isNotEmpty) {
        sections.add({'title': '📥 Response Details', 'facts': responseFacts});
      }
    }

    // Add network details section
    if (network != null && network['isConnected'] != null) {
      final networkFacts = <Map<String, String>>[];
      networkFacts.add({
        'name': '📡 Connection Status',
        'value':
            network['isConnected'] == true ? '✅ Connected' : '❌ Not Connected',
      });

      if (network['connectionTypes'] != null) {
        final types = network['connectionTypes'] as List;
        if (types.isNotEmpty) {
          networkFacts.add({
            'name': '🔌 Connection Types',
            'value': types.join(', '),
          });
        }
      }

      if (network['hasWifi'] == true) {
        networkFacts.add({'name': '📶 WiFi', 'value': 'Available'});
      }
      if (network['hasMobile'] == true) {
        networkFacts.add({'name': '📱 Mobile Data', 'value': 'Available'});
      }
      if (network['hasEthernet'] == true) {
        networkFacts.add({'name': '🔌 Ethernet', 'value': 'Available'});
      }

      sections.add({'title': '🌐 Network Information', 'facts': networkFacts});
    }

    // Add device details section
    if (device != null && device['platform'] != null) {
      final deviceFacts = <Map<String, String>>[];

      if (device['platform'] != null) {
        deviceFacts.add({'name': '📱 Platform', 'value': device['platform']});
      }
      if (device['model'] != null) {
        deviceFacts.add({'name': '📲 Model', 'value': device['model']});
      }
      if (device['manufacturer'] != null) {
        deviceFacts.add({
          'name': '🏭 Manufacturer',
          'value': device['manufacturer'],
        });
      }
      if (device['brand'] != null) {
        deviceFacts.add({'name': '🏷️ Brand', 'value': device['brand']});
      }
      if (device['device'] != null) {
        deviceFacts.add({'name': '💻 Device', 'value': device['device']});
      }
      if (device['version'] != null) {
        final version = device['version'] as Map;
        if (version['release'] != null) {
          deviceFacts.add({
            'name': '🔢 OS Version',
            'value': version['release'],
          });
        }
        if (version['sdkInt'] != null) {
          deviceFacts.add({
            'name': '📊 SDK Version',
            'value': version['sdkInt'].toString(),
          });
        }
      } else if (device['systemVersion'] != null) {
        deviceFacts.add({
          'name': '🔢 OS Version',
          'value': device['systemVersion'],
        });
      }
      if (device['isPhysicalDevice'] != null) {
        deviceFacts.add({
          'name': '💻 Device Type',
          'value':
              device['isPhysicalDevice'] == true
                  ? 'Physical Device'
                  : 'Emulator/Simulator',
        });
      }

      if (deviceFacts.isNotEmpty) {
        sections.add({'title': '📱 Device Information', 'facts': deviceFacts});
      }
    }

    // Add stack trace if available
    if (errorDetails['stackTrace'] != null) {
      String stackTrace = errorDetails['stackTrace'].toString();
      // Truncate if too long but keep more
      if (stackTrace.length > 2000) {
        stackTrace = '${stackTrace.substring(0, 2000)}... (truncated)';
      }

      sections.add({'title': '🔍 Stack Trace', 'text': stackTrace});
    }

    return {
      '@type': 'MessageCard',
      '@context': 'https://schema.org/extensions',
      'summary': 'API Error: $method $url',
      'themeColor': color,
      'sections': sections,
    };
  }
}
