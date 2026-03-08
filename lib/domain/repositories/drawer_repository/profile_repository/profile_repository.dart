import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/drawer/profile/user_profile_response_model/user_profile_response_model.dart';

/// Profile Repository - domain contract
abstract class ProfileRepository {
  /// Get the current logged-in user's profile.
  Future<Either<Failure, ProfileBody>> getUserProfile();

  /// Update the current logged-in user's profile.
  Future<Either<Failure, ProfileResponse>> updateUserProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
    required String dob,
    required String address,
    required String gender,
    required String maritalState,
    required File? profilePic,
    required String socialLink,
  });
}
