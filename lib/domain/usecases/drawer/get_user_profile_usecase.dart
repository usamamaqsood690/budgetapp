import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/drawer/profile/user_profile_response_model/user_profile_response_model.dart';
import 'package:wealthnxai/domain/repositories/drawer_repository/profile_repository/profile_repository.dart';

/// Get User Profile UseCase - domain layer
class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase({required this.repository});

  Future<Either<Failure, ProfileBody>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}

/// No parameters for this use case, but keep a type for consistency
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
