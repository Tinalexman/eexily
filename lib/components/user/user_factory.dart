import 'package:eexily/components/user/business.dart';
import 'package:eexily/components/user/user.dart';

class UserFactory {
  static UserBase createUser(Map<String, dynamic> map) {
    String role = map["type"]!;

    switch (role) {
      case "BUSINESS":
        return Business(
          email: map["email"],
          id: map["_id"],
          dateJoined: map["createdAt"],
          role: UserRole.business,
        );
      case "RIDER":
        return Business(
          email: map["email"],
          id: map["_id"],
          dateJoined: map["createdAt"],
          role: UserRole.driver,
        );
      case "CUSTOMER_SERVICE":
        return Business(
          email: map["email"],
          id: map["_id"],
          dateJoined: map["createdAt"],
          role: UserRole.support,
        );
      case "GAS_STATION":
        return Business(
          email: map["email"],
          id: map["_id"],
          dateJoined: map["createdAt"],
          role: UserRole.attendant,
        );
      case "INDIVIDUAL":
        return Business(
          email: map["email"],
          id: map["_id"],
          dateJoined: map["createdAt"],
          role: UserRole.individual,
        );
      default:
        return const UserBase(
          role: UserRole.nil,
        );
    }
  }
}
