import 'package:equatable/equatable.dart';


class UserBase extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final UserRole role;

  const UserBase({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
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
  attendant,
}
