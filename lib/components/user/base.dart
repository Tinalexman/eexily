import 'package:equatable/equatable.dart';


class UserBase extends Equatable {
  final String id;
  final String name;
  final UserRole role;

  const UserBase({
    this.id = "",
    this.name = "",
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
