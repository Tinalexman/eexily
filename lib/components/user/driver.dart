import 'base.dart';

class Driver extends UserBase {

  final String image;

  const Driver({
    super.firstName,
    super.lastName,
    super.id,
    required this.image,
  }) : super(role: UserRole.driver);
}
