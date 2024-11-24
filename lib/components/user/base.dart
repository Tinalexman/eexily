import 'package:equatable/equatable.dart';


class UserBase extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String dateJoined;
  final String phoneNumber;
  final String image;
  final UserRole role;
  final String address;
  final String location;

  const UserBase({
    this.id = "",
    this.address = "",
    this.location = "",
    this.image = "",
    this.phoneNumber = "",
    this.dateJoined = "",
    this.email = "",
    this.firstName = "",
    this.lastName = "",
    this.role = UserRole.nil,
  });

  String get fullName => "$firstName $lastName";

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
    case "MERCHANT": return UserRole.merchant;
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
  merchant,
}
