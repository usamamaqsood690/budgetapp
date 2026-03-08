import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';

class BaseRemoteDataSource {
  Exception mapDioException(
    DioException e, {
    required String defaultServerMessage,
  }) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? defaultServerMessage;
      return ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } else {
      String networkMessage = 'No internet connection';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        networkMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        networkMessage =
            'Unable to connect to server. Please check your internet connection.';
      }
      return NetworkException(message: networkMessage);
    }
  }

  /// Rethrows known exceptions or wraps any other error in [ServerException].
  Never rethrowOrWrap(Object e) {
    if (e is ServerException || e is NetworkException) {
      throw e;
    }
    throw ServerException(message: 'Unexpected error: $e');
  }

  /// Handle PlatformException from Google Sign-In or other platform-specific errors
  Never handlePlatformException(
    PlatformException e, {
    required String providerName,
  }) {
    String errorMessage;
    final errorCode = e.code;
    // Google Sign-In error codes
    // Error code 7 = SIGN_IN_NETWORK_ERROR
    // Error code 8 = SIGN_IN_INTERNAL_ERROR
    // Error code 10 = SIGN_IN_CANCELLED
    // Error code 12500 = SIGN_IN_FAILED

    if (errorCode == 'network_error' ||
        errorCode == '7' ||
        e.message?.contains('ApiException: 7') == true) {
      errorMessage =
          'Network error. Please check your internet connection and try again.';
    } else if (errorCode == 'sign_in_cancelled' || errorCode == '10') {
      errorMessage = '$providerName sign-in was cancelled';
    } else if (errorCode == 'sign_in_failed' || errorCode == '12500') {
      errorMessage = '$providerName sign-in failed. Please try again.';
    } else if (errorCode == 'sign_in_required') {
      errorMessage = 'Please sign in to your Google account';
    } else if (errorCode == 'api_not_available') {
      errorMessage =
          'Platform Services is not available. Please update Google Play Services.';
    } else {
      errorMessage =
          e.message ?? '$providerName sign-in error. Please try again.';
    }
    throw ServerException(message: errorMessage, statusCode: 400);
  }

  /// Helper for simple `MessageResponse`-based POST calls to the backend.
  Future<MessageResponse> apiMessageResponse({
    required String endpoint,
    required dynamic data,
    required String defaultFailureMessage,
    required ApiClient apiClient,
    required ApiCRUDType apiCrudType,
    includeUserId = false,
  }) async {
    try {
      final response = await _callApi(
        apiClient: apiClient,
        endpoint: endpoint,
        apiCrudType: apiCrudType,
        data: data,
        includeUserId: includeUserId
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final messageResponse = MessageResponse.fromJson(response.data);

        if (!(messageResponse.status ?? false)) {
          throw ServerException(
            message: messageResponse.message ?? defaultFailureMessage,
            statusCode: response.statusCode,
          );
        }

        return messageResponse;
      } else {
        throw ServerException(
          message: response.data['message'] ?? defaultFailureMessage,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: defaultFailureMessage);
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  Future<Response> _callApi({
    required ApiClient apiClient,
    required String endpoint,
    required ApiCRUDType apiCrudType,
    dynamic data,
    bool includeUserId = false,
  }) {
    switch (apiCrudType) {
      case ApiCRUDType.get:
        return apiClient.get(endpoint, includeUserId: includeUserId);
      case ApiCRUDType.post:
        return apiClient.post(
          endpoint,
          data: data,
          includeUserId: includeUserId,
        );
      case ApiCRUDType.put:
        return apiClient.put(
          endpoint,
          includeUserId: includeUserId,
          data: data,
        );
      case ApiCRUDType.delete:
        return apiClient.delete(
          endpoint,
          includeUserId: includeUserId,
          data: data,
        );
    }
  }
}
