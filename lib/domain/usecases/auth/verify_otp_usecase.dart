/// Verify OTP UseCase - Domain layer business logic
/// Single Responsibility: Handle OTP verification operation
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  /// Execute verify OTP use case
  Future<Either<Failure, MessageResponse>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(email: params.email, otp: params.otp,);
  }
}

/// Verify OTP Parameters
class VerifyOtpParams extends Equatable {
  final String email;
  final String otp;


  const VerifyOtpParams({required this.email, required this.otp,});

  @override
  List<Object?> get props => [email, otp,];
}
