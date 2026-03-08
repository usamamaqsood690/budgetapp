/// Feedback UseCase - Domain layer business logic
/// Single Responsibility: Handle feedback submission operation
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import '../../repositories/drawer_repository/feedback_repository/feedback_repository.dart';

class FeedbackUseCase {
  final FeedbackRepository repository;

  FeedbackUseCase({required this.repository});

  /// Execute feedback submission use case
  Future<Either<Failure, MessageResponse>> call(FeedbackParams params) async {
    return await repository.submitFeedback(
      feedType: params.feedType,
      feedDescription: params.feedDescription,
    );
  }
}

/// Feedback Parameters
class FeedbackParams extends Equatable {
  final String feedType;
  final String? feedDescription;

  const FeedbackParams({
    required this.feedType,
    this.feedDescription,
  });

  @override
  List<Object?> get props => [feedType, feedDescription];
}
