/// Google Sign-In UseCase - Domain layer business logic
/// Single Responsibility: Handle Apple Sign-In operation
import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class AppleUseCase {
  final AuthRepository repository;

  AppleUseCase({required this.repository});

  /// Execute Apple Sign-In use case
  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInWithApple();
  }
}
