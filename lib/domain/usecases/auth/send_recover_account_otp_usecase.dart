/// Signup Send OTP UseCase - Domain layer business logic
/// Single Responsibility: Handle signup OTP sending operation
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class RecoverAccountOtpUseCase {
  final AuthRepository repository;

  RecoverAccountOtpUseCase({required this.repository});

  /// Execute send OTP use case
  Future<Either<Failure, MessageResponse>> call(RecoverAccountOtpParams params) async {
    return await repository.sendRecoverAccountOtpGmail(email: params.email);
  }
}

/// Recover Send OTP Parameters
class RecoverAccountOtpParams extends Equatable {
  final String email;

  const RecoverAccountOtpParams({required this.email});

  @override
  List<Object?> get props => [email];
}
