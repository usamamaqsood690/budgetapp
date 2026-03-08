import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';

abstract class FeedbackRemoteDataSource {
  /// Submit feedback to the server
  Future<MessageResponse> submitFeedback({
    required String feedType,
    String? feedDescription,
  });
}
