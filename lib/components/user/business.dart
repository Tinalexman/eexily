import 'package:eexily/components/user/base.dart';

class Business extends UserBase {
  final String address;
  final String businessName;
  final bool hasCompletedGasQuestions;

  const Business({
    super.id,
    super.email,
    super.dateJoined,
    super.role,
    super.image,
    super.firstName,
    super.lastName,
    super.phoneNumber,
    this.hasCompletedGasQuestions = false,
    this.businessName = "",
    this.address = "",
  });

  Business copyWith({
    bool? hasCompletedGas,
    String? address,
    String? firstName,
    String? image,
    String? lastName,
    String? phoneNumber,
    String? businessName,
  }) {
    return Business(
      hasCompletedGasQuestions: hasCompletedGas ?? hasCompletedGasQuestions,
      address: address ?? this.address,
      dateJoined: dateJoined,
      email: email,
      firstName: firstName ?? this.firstName,
      id: id,
      image: image ?? this.image,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      businessName: businessName ?? this.businessName,
    );
  }

  Business copyFrom(Business otherBusiness) {
    String email =
        otherBusiness.email.isEmpty ? this.email : otherBusiness.email;
    String address =
        otherBusiness.address.isEmpty ? this.address : otherBusiness.address;
    String businessName = otherBusiness.businessName.isEmpty
        ? this.businessName
        : otherBusiness.businessName;
    String firstName = otherBusiness.firstName.isEmpty
        ? this.firstName
        : otherBusiness.firstName;
    String lastName =
        otherBusiness.lastName.isEmpty ? this.lastName : otherBusiness.lastName;
    String dateJoined = otherBusiness.dateJoined.isEmpty
        ? this.dateJoined
        : otherBusiness.dateJoined;
    String phoneNumber = otherBusiness.phoneNumber.isEmpty
        ? this.phoneNumber
        : otherBusiness.phoneNumber;
    String image =
        otherBusiness.image.isEmpty ? this.image : otherBusiness.image;
    bool completed = otherBusiness.hasCompletedGasQuestions;

    return Business(
      email: email,
      dateJoined: dateJoined,
      id: id,
      address: address,
      businessName: businessName,
      lastName: lastName,
      firstName: firstName,
      image: image,
      hasCompletedGasQuestions: completed,
      phoneNumber: phoneNumber,
    );
  }
}
