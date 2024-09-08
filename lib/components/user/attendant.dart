import 'base.dart';

class Attendant extends UserBase {
  final String gasStation;
  final double balance;
  final double retailGasPrice;
  final double regularGasPrice;

  const Attendant({
    super.firstName,
    super.lastName,
    super.id,
    required this.balance,
    required this.retailGasPrice,
    required this.regularGasPrice,
    required this.gasStation,
  }) : super(role: UserRole.attendant);
}
