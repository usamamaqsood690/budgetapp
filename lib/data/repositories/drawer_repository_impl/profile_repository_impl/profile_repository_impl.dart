import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/drawer/profile/user_profile_response_model/user_profile_response_model.dart';
import 'package:wealthnxai/domain/datasources/remote/drawer_remote_datasource/profile_remote_datasource/profile_remote_datasource.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/drawer_repository/profile_repository/profile_repository.dart';

/// Profile Repository Implementation - data layer
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileBody>> getUserProfile() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await remoteDataSource.getUserProfile();
      return Right(response.body);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
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
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await remoteDataSource.updateUserProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNo: phoneNo,
        dob: dob,
        address: address,
        gender: gender,
        maritalState: maritalState,
        profilePic: profilePic,
        socialLink: socialLink,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }
}
