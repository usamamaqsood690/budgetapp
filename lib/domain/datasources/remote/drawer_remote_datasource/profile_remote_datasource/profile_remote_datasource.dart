import 'dart:io';

import 'package:wealthnxai/data/models/drawer/profile/user_profile_response_model/user_profile_response_model.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';

/// Profile Remote Data Source - contract
/// Responsible only for profile-related HTTP APIs.
abstract class ProfileRemoteDataSource {
  /// Get the current logged-in user's profile.
  Future<ProfileResponse> getUserProfile();

  /// Update the current logged-in user's profile.
  Future<ProfileResponse> updateUserProfile({
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
