import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/domain/datasources/remote/drawer_remote_datasource/feedback_remote_datasource/feedback_remote_datasource.dart';

class FeedbackRemoteDataSourceImpl extends BaseRemoteDataSource
    implements FeedbackRemoteDataSource {
  final ApiClient apiClient;

  FeedbackRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MessageResponse> submitFeedback({
    required String feedType,
    String? feedDescription,
  }) async {
    try {
      final response = await apiClient.post(
        includeUserId: true,
        ApiConstants.feedback,
        data: {'feedType': feedType, 'feedDescription': feedDescription},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final verifyOtpResponse = MessageResponse.fromJson(response.data);

        if (!verifyOtpResponse.status!) {
          throw ServerException(
            message: verifyOtpResponse.message ?? 'Failed to submit feedback',
            statusCode: response.statusCode,
          );
        }

        return verifyOtpResponse;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to submit feedback',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: 'Failed to submit feedback');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }
}
