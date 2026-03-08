/// User Entity - Domain layer business object
/// This is a pure Dart class with no dependencies on external packages
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
    this.avatar
  });

  /// Create a copy with modified fields
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email ,avatar, createdAt];

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email , avatar: $avatar, createdAt: $createdAt)';
  }
}