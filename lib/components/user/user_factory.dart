import 'dart:developer';

import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/components/user/business.dart';
import 'package:eexily/components/user/driver.dart';
import 'package:eexily/components/user/support.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/providers.dart';

import 'merchant.dart';

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
      case "DRIVER":
        Type type = Type.nil;
        String? riderType = typeData?["riderType"];
        if (riderType != null && riderType == "DRIVER") {
          type = Type.driver;
        } else if (riderType != null && riderType == "RIDER") {
          type = Type.rider;
        }

        return Driver(
          email: map["email"],
          id: map["_id"],
          type: type,
          dateJoined: map["createdAt"],
          riderId: typeData?["_id"] ?? "",
          firstName: typeData?["firstName"] ?? "",
          lastName: typeData?["lastName"] ?? "",
          address: typeData?["address"] ?? "",
          licenseNumber: typeData?["driverLicense"] ?? "",
          licenseExpiry: typeData?["expiryDate"] ?? "",
          accountName: typeData?["accountName"] ?? "",
          accountNumber: typeData?["accountNumber"] ?? "",
          bankName: typeData?["bankName"] ?? "",
          location: typeData?["location"] ?? "",
          image: map["image"] ??
              "https://gravatar.com/avatar/${map["_id"].hashCode.toString()}?s=400&d=robohash&r=x",
        );
      case "CUSTOMER_SERVICE":
        return Support(
          email: map["email"],
          id: map["_id"],
        );
      case "GAS_STATION":
        double regular = 0.0, retail = 0.0;
        if (typeData != null) {
          double? parsedRegular = typeData["regularPrice"] == null
              ? null
              : double.tryParse(typeData["regularPrice"]);
          double? parsedRetail = typeData["retailPrice"] == null
              ? null
              : double.tryParse(typeData["retailPrice"]);
          if (parsedRegular != null) regular = parsedRegular;
          if (parsedRetail != null) retail = parsedRetail;
        }

        return Attendant(
          id: map["_id"],
          email: map["email"] ?? "",
          firstName: typeData?["firstName"] ?? "",
          lastName: typeData?["lastName"] ?? "",
          address: typeData?["address"] ?? "",
          phoneNumber: map["phoneNumber"] ?? "",
          dateJoined: map["createdAt"] ?? "",
          image: map["image"] ??
              "https://gravatar.com/avatar/${map["_id"].hashCode.toString()}?s=400&d=robohash&r=x",
          location: typeData?["location"] ?? "",
          gasStationName: typeData?["gasStationName"] ?? "",
          bankName: typeData?["bankName"] ?? "",
          accountNumber: typeData?["accountNumber"] ?? "",
          accountName: typeData?["accountName"] ?? "",
          gasStationId: typeData?["_id"] ?? "",
          isOpened: typeData?["isOpened"] ?? false,
          regularGasPrice: regular,
          retailGasPrice: retail,
          regCode: typeData?["regCode"] ?? "",
        );
      case "MERCHANT":
        return Merchant(
          id: map["_id"],
          firstName: typeData?["firstName"] ?? "",
          lastName: typeData?["lastName"] ?? "",
          regularGasPrice: (typeData?["regularPrice"] as num).toDouble() ?? 0.0,
          merchantId: typeData?["_id"] ?? "",
          isOpened: typeData?["isOpened"] ?? false,
          bankName: typeData?["bankName"] ?? "",
          accountNumber: typeData?["accountNumber"] ?? "",
          accountName: typeData?["accountName"] ?? "",
          address: typeData?["address"] ?? "",
          storeName: typeData?["storeName"] ?? "",
          phoneNumber: map["phoneNumber"] ?? "",
          dateJoined: map["createdAt"] ?? "",
          location: typeData?["location"] ?? "",
          email: map["email"] ?? "",
          image: map["image"] ??
              "https://gravatar.com/avatar/${map["_id"].hashCode.toString()}?s=400&d=robohash&r=x",
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
              "https://gravatar.com/avatar/${map["_id"].hashCode.toString()}?s=400&d=robohash&r=x",
          hasCompletedGasQuestions: map["isGas"],
          location: typeData?["location"] ?? "",
        );
      default:
        return dummyBase;
    }
  }
}
