import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/drawer/profile/user_profile_response_model/user_profile_response_model.dart';
import 'package:wealthnxai/domain/repositories/drawer_repository/profile_repository/profile_repository.dart';

/// Update User Profile UseCase - domain layer
class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase({required this.repository});

  Future<Either<Failure, ProfileResponse>> call(UpdateUserProfileParams params) {
    return repository.updateUserProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phoneNo: params.phoneNo,
      dob: params.dob,
      address: params.address,
      gender: params.gender,
      maritalState: params.maritalState,
      profilePic: params.profilePic,
      socialLink: params.socialLink,
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final String dob;
  final String address;
  final String gender;
  final String maritalState;
  final File? profilePic;
  final String socialLink;

  const UpdateUserProfileParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.dob,
    required this.address,
    required this.gender,
    required this.maritalState,
    required this.profilePic,
    required this.socialLink,
  });

  @override
  List<Object?> get props => [

        firstName,
        lastName,
        email,
        phoneNo,
        dob,
        address,
        gender,
        maritalState,
        profilePic,
        socialLink,
      ];
}

