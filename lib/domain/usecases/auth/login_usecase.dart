import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';
import '../../repositories/auth_repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  /// Execute login use case
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return  await repository.login(email: params.email, password: params.password,);
  }
}

/// Login Parameters
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}