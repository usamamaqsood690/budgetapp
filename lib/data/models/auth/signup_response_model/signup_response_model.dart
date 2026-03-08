import 'package:wealthnxai/data/models/user_model/user_model.dart';

class SignUpResponse {
  bool? status;
  String? message;
  UserBody? body;

  SignUpResponse({this.status, this.message, this.body});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      status: json['status'],
      message: json['message'],
      body: json['body'] != null ? UserBody.fromJson(json['body']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class UserBody {
  String? userId;
  String? name;
  String? email;
  String? token;
  String? refreshToken;

  UserBody({this.userId, this.name, this.email, this.token, this.refreshToken});

  factory UserBody.fromJson(Map<String, dynamic> json) {
    return UserBody(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    return data;
  }

  /// Convert to UserModel
  UserModel toUserModel() {
    return UserModel(id: userId ?? '', name: name ?? '', email: email ?? '');
  }
}
