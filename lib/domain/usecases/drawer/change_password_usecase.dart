/// Change Password UseCase - Domain layer business logic
/// Single Responsibility: Handle password reset operation for forgot-password flow
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase({required this.repository});

  /// Execute change password use case
  Future<Either<Failure, MessageResponse>> call(
      ChangePasswordUseCaseParams params,
      ) async {
    return await repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}

/// Change Password Parameters
class ChangePasswordUseCaseParams extends Equatable {

  final String currentPassword;
  final String newPassword;

  const ChangePasswordUseCaseParams({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}
