import 'base.dart';

class Driver extends UserBase {
  final String address;
  final String image;
  final String licenseNumber;
  final String licenseExpiry;
  final String accountName;
  final String accountNumber;
  final String bankName;


  const Driver({
    super.firstName,
    super.lastName,
    super.id,
    super.dateJoined,
    super.email,
    this.address = "",
    this.image = "",
    this.licenseExpiry = "",
    this.licenseNumber = "",
    this.accountName = "",
    this.accountNumber = "",
    this.bankName = "",
  }) : super(role: UserRole.driver);

  Driver copyWith({
    String? firstName,
    String? lastName,
    String? address,
    String? image,
    String? licenseExpiry,
    String? licenseNumber,
    String? accountName,
    String? accountNumber,
    String? bankName,
  }) {
    return Driver(
      address: address ?? this.address,
      firstName: firstName ?? this.address,
      id: id,
      lastName: lastName ?? this.lastName,
      email: email,
      dateJoined: dateJoined,
      image: image ?? this.image,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      bankName: bankName ?? this.bankName,
    );
  }
}
