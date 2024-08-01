import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photo;
  final bool isVerified;

  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
    required this.isVerified,
  });

  // Add a copyWith method to help update the user properties
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photo,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  static const empty = User(id: '', isVerified: false);

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, email, name, photo, isVerified];
}
