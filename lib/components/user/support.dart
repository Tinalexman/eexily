import 'base.dart';

class Support extends UserBase {
  final String email;
  final String supportRole;

  const Support({
    super.firstName,
    super.lastName,
    super.id,
    this.email = "",
    this.supportRole = "",
  }) : super(role: UserRole.support);
}
