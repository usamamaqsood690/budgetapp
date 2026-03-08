/// Auth Remote DataSource - Data layer
/// Handles API calls for authentication
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/core/services/storage_service.dart';
import 'package:wealthnxai/core/services/firebase_service.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/auth/login_response_model/sign_in_response_model.dart';
import 'package:wealthnxai/data/models/auth/signup_response_model/signup_response_model.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/data/models/user_model/user_model.dart';
import 'package:wealthnxai/domain/datasources/remote/auth_remote_datasource/auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final StorageService _storageService = StorageService.instance;
  final FirebaseService _firebaseService = FirebaseService.instance;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final fcmToken = await _firebaseService.getFCMToken();
      final response = await apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
          'fcmToken': fcmToken ?? '',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final signInResponse = SignInResponseModel.fromJson(response.data);

        if (!signInResponse.status) {
          throw ServerException(
            message: signInResponse.message,
            statusCode: response.statusCode,
          );
        }
        // Save tokens to storage
        await _storageService.saveToken(signInResponse.body.token);
        await _storageService.saveRefreshToken(
          signInResponse.body.refreshToken,
        );

        final userModel = signInResponse.body.toUserModel();
        return userModel;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: 'Server error occurred');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final fcmToken = await _firebaseService.getFCMToken();
      final response = await apiClient.post(
        ApiConstants.register,
        data: {
          'fullName': name,
          'email': email,
          'password': password,
          'fcmToken': fcmToken ?? '',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final signUpResponse = SignUpResponse.fromJson(response.data);

        if (!signUpResponse.status!) {
          throw ServerException(
            message: signUpResponse.message ?? 'Registration failed',
            statusCode: response.statusCode,
          );
        }
        // Save tokens to storage
        try {
          if (signUpResponse.body?.token != null) {
            await _storageService.saveToken(signUpResponse.body!.token!);
          }
          if (signUpResponse.body?.refreshToken != null) {
            await _storageService.saveRefreshToken(
              signUpResponse.body!.refreshToken!,
            );
          }
        } catch (e) {
          print('Warning: Failed to save tokens: $e');
        }

        // Convert the body to UserModel
        if (signUpResponse.body != null) {
          return signUpResponse.body!.toUserModel();
        } else {
          throw ServerException(
            message: 'Registration response missing user data',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: 'Server error occurred');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Step 1: Sign out from Google Sign-In to force account picker dialog
      final googleSignIn = GoogleSignIn();
      try {
        await googleSignIn.signOut();
      } catch (e) {
        // Ignore errors if already signed out
        log('Google sign-out error (ignored): $e');
      }

      // Step 2: Google Sign-In (will show account picker dialog)
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw ServerException(
          message: 'Google sign-in cancelled by user',
          statusCode: 400,
        );
      }
      // Step 3: Get Google Auth tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 4: Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 5: Sign in to Firebase
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw ServerException(
          message: 'Failed to authenticate with Firebase',
          statusCode: 401,
        );
      }

      // Step 6: get FirebaseIdToken
      final String? firebaseIdToken = await user.getIdToken();

      // Determine if this is a new Firebase user
      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      // If this is a brand-new Google user, signal the presentation layer
      if (isNewUser) {
        throw ServerException(
          message:
              'NEW_GOOGLE_USER|${user.uid}|${user.displayName}|${user.email}|$firebaseIdToken',
          statusCode: 409,
        );
      }

      // Existing Google user → call shared completeGoogleAuth without password
      final String userName = user.displayName ?? '';
      final String userEmail = user.email ?? '';

      return await completeGoogleAuth(
        userId: user.uid,
        userName: userName,
        email: userEmail,
        password: '',
        idToken: firebaseIdToken ?? ''

      );
    } on PlatformException catch (e) {
      handlePlatformException(e, providerName: 'Google');
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: 'Server error occurred');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<UserModel> completeGoogleAuth({
    required String userId,
    required String userName,
    required String email,
    required String password,
    required String idToken,
  }) async {
    try {
      final fcmToken = await _firebaseService.getFCMToken();
      final response = await apiClient.post(
        ApiConstants.googleAuth,
        data: {
          'userId': userId,
          'userName': userName,
          'email': email,
          'fcmToken': fcmToken ?? '',
          'password': password,
          'idToken': idToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final signInResponse = SignInResponseModel.fromJson(response.data);

        if (!signInResponse.status) {
          throw ServerException(
            message: signInResponse.message,
            statusCode: response.statusCode,
          );
        }

        // Save tokens to storage
        try {
          await _storageService.saveToken(signInResponse.body.token);
          if (signInResponse.body.refreshToken.isNotEmpty) {
            await _storageService.saveRefreshToken(
              signInResponse.body.refreshToken,
            );
          }
        } catch (e) {
          log('Warning: Failed to save tokens: $e');
        }

        // Convert the body to UserModel
        return signInResponse.body.toUserModel();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Google authentication failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: 'Server error occurred');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<MessageResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyOtp,
        data: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final verifyOtpResponse = MessageResponse.fromJson(response.data);

        if (!verifyOtpResponse.status!) {
          throw ServerException(
            message: verifyOtpResponse.message ?? 'OTP verification failed',
            statusCode: response.statusCode,
          );
        }

        return verifyOtpResponse;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'OTP verification failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: 'OTP verification failed');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<UserModel> signInWithApple() async {
    try {
      // Step 1: Request Apple Sign-In credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Step 2: Create Firebase OAuth credential from Apple credentials
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Step 3: Sign in to Firebase with the Apple credential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(oauthCredential);

      final user = userCredential.user;
      if (user == null) {
        throw ServerException(
          message: 'Failed to authenticate with Firebase',
          statusCode: 401,
        );
      }

      // Step 4: Prepare user data for backend
      final String userName =
          appleCredential.givenName != null &&
                  appleCredential.familyName != null
              ? '${appleCredential.givenName} ${appleCredential.familyName}'
              : (user.displayName ?? '');

      final String userEmail = appleCredential.email ?? user.email ?? '';

      // Step 5: get FirebaseIdToken
      final String? firebaseIdToken = await user.getIdToken();


      // Determine if this is a new Firebase user
      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      // If this is a brand-new Apple user, signal the presentation layer
      if (isNewUser) {
        throw ServerException(
          message: 'NEW_APPLE_USER|${user.uid}|$userName|$userEmail|$firebaseIdToken',
          statusCode: 409,
        );
      }

      // Existing Apple user → call shared completeGoogleAuth without password
      return await completeGoogleAuth(
        userId: user.uid,
        userName: userName,
        email: userEmail,
        password: '',
        idToken: firebaseIdToken ?? ''
      );
    } on PlatformException catch (e) {
      handlePlatformException(e, providerName: 'Apple');
    } on DioException catch (e) {
      throw mapDioException(e, defaultServerMessage: 'Server error occurred');
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<MessageResponse> sendOtpForgetPassword({required String email}) async {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.post,
      endpoint: ApiConstants.forgotPassword,
      data: {'email': email},
      defaultFailureMessage: 'Failed to send OTP',
      apiClient: apiClient,
    );
  }

  @override
  Future<MessageResponse> newPassword({
    required String email,
    required String newPassword,
  }) async {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.post,
      endpoint: ApiConstants.resetPassword,
      data: {'email': email, 'newPassword': newPassword},
      defaultFailureMessage: 'Failed to set new password',
      apiClient: apiClient,
    );
  }

  @override
  Future<MessageResponse> sendOtpGmail({required String email}) async {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.post,
      endpoint: ApiConstants.sendOtpGmail,
      data: {'email': email},
      defaultFailureMessage: 'Failed to send OTP',
      apiClient: apiClient,
    );
  }

  @override
  Future<MessageResponse> logout() async {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.post,
      endpoint: ApiConstants.logout,
      data: {},
      defaultFailureMessage: 'Failed to logout',
      apiClient: apiClient,
    );
  }

  @override
  Future<MessageResponse> sendRecoverAccountOtpGmail({required String email}) {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.post,
      endpoint: ApiConstants.recoverAccountOtpGmail,
      data: {'email': email},
      defaultFailureMessage: 'Failed to send OTP',
      apiClient: apiClient,
    );
  }

  @override
  Future<MessageResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.post,
      endpoint: ApiConstants.changePassword,
      data: {'oldPassword': currentPassword, 'newPassword': newPassword},
      defaultFailureMessage: 'Failed to change password',
      apiClient: apiClient,
    );
  }

  @override
  Future<MessageResponse> deleteAccount()async {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.delete,
      endpoint: ApiConstants.deleteAccount,
      includeUserId: true,
      data: {},
      defaultFailureMessage: 'Failed to delete account',
      apiClient: apiClient,
    );
  }
}
