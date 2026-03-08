import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';

/// User Model - Data layer
/// Extends UserEntity and adds JSON serialization

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    String? avatar,
    super.createdAt,
  });

  /// Factory constructor - Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Create from Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatar: entity.avatar,
      createdAt: entity.createdAt,
    );
  }

  /// Convert to Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt,
      avatar: avatar
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, avatar: $avatar)';
  }
}
