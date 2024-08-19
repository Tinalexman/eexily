import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String image;
  final UserRole role;
  final String address;

  const User({
    this.id = "",
    this.address = "",
    this.firstName = "",
    this.lastName = "",
    this.image = "",
    this.role = UserRole.nil,
  });

  @override
  List<Object?> get props => [id];
}

enum UserRole {
  nil,
  regular,
  premium,
  support,
  driver,
  attendant
}
