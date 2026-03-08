import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';

abstract class FeedbackRepository {
  /// Submit feedback
  Future<Either<Failure, MessageResponse>> submitFeedback({
    required String feedType,
    String? feedDescription,
  });
}
