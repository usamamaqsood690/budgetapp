/// Signup Send OTP UseCase - Domain layer business logic
/// Single Responsibility: Handle signup OTP sending operation
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class DeleteAccountOtpUseCase {
  final AuthRepository repository;

  DeleteAccountOtpUseCase({required this.repository});

  /// Execute delete account use case
  Future<Either<Failure, MessageResponse>> call() async {
    return await repository.deleteAccount();
  }
}
