import 'package:eexily/components/user/base.dart';

class Business extends UserBase {
  final String address;
  final String businessName;

  const Business({
    super.id,
    super.email,
    super.dateJoined,
    super.role,
    super.image,
    this.businessName = "",
    this.address = "",
  });

  Business copyWith(Business otherBusiness) {
    String email =
        otherBusiness.email.isEmpty ? this.email : otherBusiness.email;
    String address =
        otherBusiness.address.isEmpty ? this.address : otherBusiness.address;
    String businessName = otherBusiness.businessName.isEmpty
        ? this.businessName
        : otherBusiness.businessName;
    String dateJoined = otherBusiness.dateJoined.isEmpty
        ? this.dateJoined
        : otherBusiness.dateJoined;

    return Business(
        role: UserRole.business,
        email: email,
        dateJoined: dateJoined,
        id: id,
        address: address,
        businessName: businessName);
  }
}
