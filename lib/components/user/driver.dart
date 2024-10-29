import 'base.dart';

class Driver extends UserBase {

  final String address;
  final String image;

  const Driver({
    super.firstName,
    super.lastName,
    super.id,
    super.dateJoined,
    super.email,
    this.address = "",
    this.image = "",
  }) : super(role: UserRole.driver);
}
