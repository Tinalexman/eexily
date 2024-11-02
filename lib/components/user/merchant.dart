import 'base.dart';

class Merchant extends UserBase {
  final double balance;
  final double retailGasPrice;
  final double regularGasPrice;

  const Merchant({
    super.firstName,
    super.lastName,
    super.id,
    this.balance = 0,
    this.retailGasPrice = 0,
    this.regularGasPrice = 0,
  }) : super(role: UserRole.merchant);
}
