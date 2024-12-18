import 'base.dart';

class Merchant extends UserBase {
  final double regularGasPrice;
  final bool isOpened;
  final String storeName;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String merchantId;

  const Merchant({
    super.firstName,
    super.lastName,
    super.id,
    super.phoneNumber,
    super.dateJoined,
    super.email,
    super.image,
    super.location,
    super.address,
    this.merchantId = "",
    this.isOpened = false,
    this.regularGasPrice = 0,
    this.bankName = "",
    this.accountNumber = "",
    this.accountName = "",
    this.storeName = "",
  }) : super(role: UserRole.merchant);

  Merchant copyWith({
    String? firstName,
    String? lastName,
    String? id,
    String? image,
    String? phoneNumber,
    String? dateJoined,
    String? email,
    double? balance,
    double? regularGasPrice,
    bool? isOpened,
    String? address,
    String? storeName,
    String? accountName,
    String? accountNumber,
    String? bankName,
    String? merchantId,
    String? location,
  }) {
    return Merchant(
      merchantId: merchantId ?? this.merchantId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      id: id ?? this.id,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateJoined: dateJoined ?? this.dateJoined,
      email: email ?? this.email,
      regularGasPrice: regularGasPrice ?? this.regularGasPrice,
      isOpened: isOpened ?? this.isOpened,
      address: address ?? this.address,
      storeName: storeName ?? this.storeName,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      location: location ?? this.location,
    );
  }
}
