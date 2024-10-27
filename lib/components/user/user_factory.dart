import 'package:eexily/components/user/business.dart';
import 'package:eexily/components/user/user.dart';

class UserFactory {
  static UserBase createUser(
    Map<String, dynamic> map, {
    Map<String, dynamic>? typeData,
  }) {
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
        return User(
          email: map["email"] ?? "",
          id: map["_id"] ?? "",
          firstName: typeData?["firstName"] ?? "",
          lastName: typeData?["lastName"] ?? "",
          address: typeData?["address"] ?? "",
          phoneNumber: map["phoneNumber"] ??"",
          dateJoined: map["createdAt"] ?? "",
          image: map["image"] ?? "https://gravatar.com/avatar/${map["_id"].hashCode.toString()}?s=400&d=robohash&r=x",
          role: UserRole.individual,
          hasCompletedGasQuestions: map["isGas"],
        );
      default:
        return const UserBase(
          role: UserRole.nil,
        );
    }
  }
}
