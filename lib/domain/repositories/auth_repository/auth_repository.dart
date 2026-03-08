/// Auth Repository Interface - Domain layer
/// Defines the contract for authentication operations
import 'package:dartz/dartz.dart';
import 'package:wealthnxai/core/errors/failure.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Send OTP to email for signup
  Future<Either<Failure, MessageResponse>> sendOtpGmail({
    required String email,
  });

  /// Send OTP to email for recover account
  Future<Either<Failure, MessageResponse>> sendRecoverAccountOtpGmail({
    required String email,
  });

  /// Send OTP to email for forget password
  Future<Either<Failure, MessageResponse>> sendOtpForgotPassword({
    required String email,
  });

  /// Set new password of Forget password user
  Future<Either<Failure, MessageResponse>> newPassword({
    required String email,
    required String newPassword,
  });

  /// change password of Forget password user
  Future<Either<Failure, MessageResponse>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Verify OTP
  Future<Either<Failure, MessageResponse>> verifyOtp({
    required String email,
    required String otp,
  });

  /// Sign in with Google
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Sign in with Apple
  Future<Either<Failure, UserEntity>> signInWithApple();

  /// Complete Google auth for a new social user with a chosen password
  Future<Either<Failure, UserEntity>> completeGoogleAuth({
    required String userId,
    required String userName,
    required String email,
    required String password,
    required String idToken
  });

  ///logout User
  Future<Either<Failure, MessageResponse>> logout();

  ///delete account
  Future<Either<Failure, MessageResponse>> deleteAccount();
}
