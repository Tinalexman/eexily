import 'base.dart';

class Attendant extends UserBase {
  final String gasStation;

  const Attendant({
    super.firstName,
    super.lastName,
    super.id,
    required this.gasStation,
  }) : super(role: UserRole.attendant);
}
