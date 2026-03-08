/// Signup Send OTP UseCase - Domain layer business logic
/// Single Responsibility: Handle signup OTP sending operation
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class SignupSendOtpUseCase {
  final AuthRepository repository;

  SignupSendOtpUseCase({required this.repository});

  /// Execute send OTP use case
  Future<Either<Failure, MessageResponse>> call(SignupSendOtpParams params) async {
    return await repository.sendOtpGmail(email: params.email);
  }
}

/// Signup Send OTP Parameters
class SignupSendOtpParams extends Equatable {
  final String email;

  const SignupSendOtpParams({required this.email});

  @override
  List<Object?> get props => [email];
}
