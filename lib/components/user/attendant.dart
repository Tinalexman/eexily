import 'base.dart';

class Attendant extends UserBase {
  const Attendant({
    super.name,
    super.id,
  }) : super(role: UserRole.attendant);
}
