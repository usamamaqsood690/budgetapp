import 'package:wealthnxai/data/models/user_model/user_model.dart';

/// Sign In Response Model - Data layer
/// Maps the complete sign-in API response
class SignInResponseModel {
  final bool status;
  final String message;
  final SignInBodyModel body;

  const SignInResponseModel({
    required this.status,
    required this.message,
    required this.body,
  });

  /// Factory constructor - Create from JSON
  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      body: SignInBodyModel.fromJson(json['body'] ?? {}),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'body': body.toJson()};
  }
}

/// Sign In Body Model - Contains the actual user data and tokens
class SignInBodyModel {
  final String userId;
  final String name;
  final String email;
  final String token;
  final String refreshToken;
  final int expiresIn;

  const SignInBodyModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
  });

  /// Factory constructor - Create from JSON
  factory SignInBodyModel.fromJson(Map<String, dynamic> json) {
    return SignInBodyModel(
      userId: json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      expiresIn: json['expiresIn'] ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'token': token,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }

  /// Convert to UserModel
  UserModel toUserModel() {
    return UserModel(id: userId, name: name, email: email);
  }
}
