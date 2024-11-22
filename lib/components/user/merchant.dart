import 'base.dart';

class Merchant extends UserBase {
  final double balance;
  final double retailGasPrice;
  final double regularGasPrice;
  final bool isOpened;
  final String address;
  final String storeName;
  final String accountName;
  final String accountNumber;
  final String bankName;

  const Merchant({
    super.firstName,
    super.lastName,
    super.id,
    super.phoneNumber,
    super.dateJoined,
    super.email,
    super.image,
    this.isOpened = false,
    this.balance = 0,
    this.retailGasPrice = 0,
    this.regularGasPrice = 0,
    this.address = "",
    this.bankName = "",
    this.accountNumber = "",
    this.accountName = "",
    this.storeName = "",
  }) : super(role: UserRole.merchant);

  Merchant copyWith({
    String? firstName,
    String? lastName,
    String? id,
    String? phoneNumber,
    String? dateJoined,
    String? email,
    double? balance,
    double? retailGasPrice,
    double? regularGasPrice,
    bool? isOpened,
    String? address,
    String? storeName,
    String? accountName,
    String? accountNumber,
    String? bankName,
  }) {
    return Merchant(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateJoined: dateJoined ?? this.dateJoined,
      email: email ?? this.email,
      balance: balance ?? this.balance,
      retailGasPrice: retailGasPrice ?? this.retailGasPrice,
      regularGasPrice: regularGasPrice ?? this.regularGasPrice,
      isOpened: isOpened ?? this.isOpened,
      address: address ?? this.address,
      storeName: storeName ?? this.storeName,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
    );
  }
}
