import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/data/models/user_model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<UserModel> completeGoogleAuth({
    required String userId,
    required String userName,
    required String email,
    required String password,
    required String idToken
  });
  Future<MessageResponse> sendOtpGmail({required String email});
  Future<MessageResponse> sendRecoverAccountOtpGmail({required String email});
  Future<MessageResponse> sendOtpForgetPassword({required String email});
  Future<MessageResponse> verifyOtp({
    required String email,
    required String otp,
  });
  Future<MessageResponse> newPassword({
    required String email,
    required String newPassword,
  });
  Future<MessageResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<MessageResponse> logout();
  Future<MessageResponse> deleteAccount();
}
