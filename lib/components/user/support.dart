import 'base.dart';

class Support extends UserBase {

  final String supportRole;

  const Support({
    super.firstName,
    super.lastName,
    super.id,
    super.email,
    super.image,
    super.location,
    super.address,
    this.supportRole = "",
  }) : super(role: UserRole.support);
}
