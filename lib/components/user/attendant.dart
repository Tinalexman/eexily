import 'base.dart';

class Attendant extends UserBase {
  final String gasStationName;
  final double balance;
  final double retailGasPrice;
  final double regularGasPrice;

  const Attendant({
    super.firstName,
    super.lastName,
    super.id,
    super.image,
    super.location,
    super.address,
    this.balance = 0,
    this.retailGasPrice = 0,
    this.regularGasPrice = 0,
    this.gasStationName = '',
  }) : super(role: UserRole.attendant);
}
