import 'package:equatable/equatable.dart';


class UserBase extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String dateJoined;
  final UserRole role;

  const UserBase({
    this.id = "",
    this.dateJoined = "",
    this.email = "",
    this.firstName = "",
    this.lastName = "",
    this.role = UserRole.nil,
  });

  @override
  List<Object?> get props => [id];
}

UserRole convertToRole(String role) {
  switch(role) {
    case "BUSINESS": return UserRole.business;
    case "RIDER": return UserRole.driver;
    case "CUSTOMER_SERVICE": return UserRole.support;
    case "GAS_STATION": return UserRole.attendant;
    case "INDIVIDUAL": return UserRole.individual;
    default: return UserRole.nil;
  }
}

enum UserRole {
  nil,
  individual,
  business,
  support,
  driver,
  attendant,
}
