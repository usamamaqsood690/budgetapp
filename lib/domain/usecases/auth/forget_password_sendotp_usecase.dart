/// Signup Send OTP UseCase - Domain layer business logic
/// Single Responsibility: Handle signup OTP sending operation
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/domain/usecases/auth/signup_sendotp_usecase.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class ForgetPasswordSendOtpUseCase {
  final AuthRepository repository;

  ForgetPasswordSendOtpUseCase({required this.repository});

  /// Execute send OTP use case
  Future<Either<Failure, MessageResponse>> call(SignupSendOtpParams params) async {
    return await repository.sendOtpForgotPassword(email: params.email);
  }
}

/// Forget Send OTP Parameters
class ForgetPasswordSendOtpParams extends Equatable {
  final String email;

  const ForgetPasswordSendOtpParams({required this.email});

  @override
  List<Object?> get props => [email];
}
