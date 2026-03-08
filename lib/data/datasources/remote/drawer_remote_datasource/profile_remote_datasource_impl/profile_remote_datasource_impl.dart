import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/drawer/profile/user_profile_response_model/user_profile_response_model.dart';
import 'package:wealthnxai/domain/datasources/remote/drawer_remote_datasource/profile_remote_datasource/profile_remote_datasource.dart';

/// ProfileRemoteDataSource implementation - talks to HTTP APIs
class ProfileRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileResponse> getUserProfile() async {
    try {
      final response = await apiClient.get(ApiConstants.userProfile,includeUserId: true);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final profileResponse = ProfileResponse.fromJson(response.data);

        if (!profileResponse.status) {
          throw ServerException(
            message: profileResponse.message,
            statusCode: response.statusCode,
          );
        }

        return profileResponse;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to fetch profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: 'Failed to fetch profile');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
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
  }) async {
    try {
      final formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNo': phoneNo,
        'dob': dob,
        'address': address,
        'gender': gender,
        'maritalState': maritalState,
        'socialLink': socialLink,
        if (profilePic != null)
          'profilePicture': await MultipartFile.fromFile(
            profilePic.path,
            filename: profilePic.path.split('/').last,
          ),
      });
      
      final response = await apiClient.put(
        ApiConstants.updateProfile,
        includeUserId: true,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final profileResponse = ProfileResponse.fromJson(response.data);

        if (!profileResponse.status) {
          throw ServerException(
            message: profileResponse.message,
            statusCode: response.statusCode,
          );
        }

        return profileResponse;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to update profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: 'Failed to update profile');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

}
