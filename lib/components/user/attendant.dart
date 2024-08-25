import 'base.dart';

class Attendant extends UserBase {
  const Attendant({
    super.firstName,
    super.lastName,
    super.id,
  }) : super(role: UserRole.attendant);
}
