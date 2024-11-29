import 'base.dart';

class Attendant extends UserBase {
  final String gasStationName;

  final double retailGasPrice;
  final double regularGasPrice;

  final bool isOpened;
  final String accountName;
  final String accountNumber;
  final String bankName;

  final String gasStationId;
  final String regCode;


  const Attendant({
    super.firstName,
    super.lastName,
    super.id,
    super.image,
    super.location,
    super.address,
    super.dateJoined,
    super.email,
    super.phoneNumber,
    this.regCode = "",
    this.bankName = "",
    this.accountNumber = "",
    this.isOpened = false,
    this.gasStationId = "",
    this.accountName = "",
    this.retailGasPrice = 0,
    this.regularGasPrice = 0,
    this.gasStationName = '',
  }) : super(role: UserRole.attendant);


  Attendant copyWith({
    String? firstName,
    String? lastName,
    String? id,
    String? image,
    String? phoneNumber,
    String? dateJoined,
    String? email,
    double? balance,
    double? retailGasPrice,
    double? regularGasPrice,
    bool? isOpened,
    String? address,
    String? gasStationName,
    String? accountName,
    String? accountNumber,
    String? bankName,
    String? gasStationId,
    String? location,
    String? regCode,
  }) {
    return Attendant(
      regCode: regCode ?? this.regCode,
      gasStationId: gasStationId ?? this.gasStationId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      id: id ?? this.id,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateJoined: dateJoined ?? this.dateJoined,
      email: email ?? this.email,
      regularGasPrice: regularGasPrice ?? this.regularGasPrice,
      retailGasPrice: retailGasPrice ?? this.retailGasPrice,
      isOpened: isOpened ?? this.isOpened,
      address: address ?? this.address,
      gasStationName: gasStationName ?? this.gasStationName,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      location: location ?? this.location,
    );
  }
}
