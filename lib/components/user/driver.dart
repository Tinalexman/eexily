import 'base.dart';

enum Type {
  nil,
  rider,
  driver
}

class Driver extends UserBase {
  final String licenseNumber;
  final String licenseExpiry;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String riderId;
  final Type type;


  const Driver({
    super.firstName,
    super.lastName,
    super.id,
    super.dateJoined,
    super.email,
    super.image,
    super.location,
    super.address,
    this.riderId = "",
    this.type = Type.nil,
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
    String? riderId,
    Type? type,
  }) {
    return Driver(
      riderId: riderId ?? this.riderId,
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
      type: type ?? this.type,
    );
  }
}
