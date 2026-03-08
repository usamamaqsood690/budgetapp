import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';
import 'package:wealthnxai/domain/repositories/auth_repository/auth_repository.dart';

class CompleteGoogleAuthParams {
  final String userId;
  final String userName;
  final String email;
  final String password;
  final String idToken;


  CompleteGoogleAuthParams({
    required this.userId,
    required this.userName,
    required this.email,
    required this.password,
    required this.idToken
  });
}

class CompleteGoogleAuthUseCase {
  final AuthRepository repository;

  CompleteGoogleAuthUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call(
    CompleteGoogleAuthParams params,
  ) async {
    return await repository.completeGoogleAuth(
      userId: params.userId,
      userName: params.userName,
      email: params.email,
      password: params.password,
      idToken: params.idToken
    );
  }
}

