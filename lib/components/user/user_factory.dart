import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/components/user/business.dart';
import 'package:eexily/components/user/driver.dart';
import 'package:eexily/components/user/support.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/providers.dart';

import 'merchant.dart';

class UserFactory {
  static UserBase createUser(Map<String, dynamic> map, {
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
        return Driver(
          email: map["email"],
          id: map["_id"],
          dateJoined: map["createdAt"],
          firstName: typeData?["firstName"] ?? "",
          lastName: typeData?["lastName"] ?? "",
          address: typeData?["address"] ?? "",
          image: map["image"] ??
              "https://gravatar.com/avatar/${map["_id"].hashCode
                  .toString()}?s=400&d=robohash&r=x",
        );
      case "CUSTOMER_SERVICE":
        return Support(
          email: map["email"],
          id: map["_id"],
        );
      case "GAS_STATION":
        return Attendant(
          id: map["_id"],
        );
      case "MERCHANT":
        return Merchant(
          id: map["_id"],
          firstName: typeData?["firstName"] ?? "",
          lastName: typeData?["lastName"] ?? "",
          regularGasPrice: (typeData?["regularPrice"] as num).toDouble() ??
              0.0,
          retailGasPrice: (typeData?["retailPrice"] as num).toDouble() ?? 0.0,
          balance: 000,
          isOpened: typeData?["isOpened"] ?? false,
          bankName: typeData?["bankName"] ?? "",
          accountNumber: typeData?["accountNumber"] ?? "",
          accountName: typeData?["accountName"] ?? "",
          address: typeData?["address"] ?? "",
          storeName: typeData?["storeName"] ?? "",
          phoneNumber: map["phoneNumber"] ?? "",
          dateJoined: map["createdAt"] ?? "",
          email: map["email"] ?? "",
        );
      case "INDIVIDUAL":
        return User(
          email: map["email"] ?? "",
          id: map["_id"] ?? "",
          firstName: typeData?["firstName"] ?? "",
          lastName: typeData?["lastName"] ?? "",
          address: typeData?["address"] ?? "",
          phoneNumber: map["phoneNumber"] ?? "",
          dateJoined: map["createdAt"] ?? "",
          image: map["image"] ??
              "https://gravatar.com/avatar/${map["_id"].hashCode
                  .toString()}?s=400&d=robohash&r=x",
          hasCompletedGasQuestions: map["isGas"],
        );
      default:
        return dummyBase;
    }
  }
}