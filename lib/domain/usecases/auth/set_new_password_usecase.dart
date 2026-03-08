/// Change Password UseCase - Domain layer business logic
/// Single Responsibility: Handle password reset operation for forgot-password flow
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class NewPasswordUseCase {
  final AuthRepository repository;

  NewPasswordUseCase({required this.repository});

  /// Execute new password use case
  Future<Either<Failure, MessageResponse>> call(
      NewPasswordUseCaseParams params,
  ) async {
    return await repository.newPassword(
      email: params.email,
      newPassword: params.newPassword,
    );
  }
}

/// new Password Parameters
class NewPasswordUseCaseParams extends Equatable {
  
  final String email;
  final String newPassword;

  const NewPasswordUseCaseParams({
    required this.email,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, newPassword];
}
