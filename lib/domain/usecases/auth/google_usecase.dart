/// Google Sign-In UseCase - Domain layer business logic
/// Single Responsibility: Handle Google Sign-In operation
import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class GoogleUseCase {
  final AuthRepository repository;

  GoogleUseCase({required this.repository});

  /// Execute Google Sign-In use case
  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInWithGoogle();
  }
}
