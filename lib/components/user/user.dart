import 'base.dart';
export 'base.dart';

class User extends UserBase {
  final String firstName;
  final String lastName;
  final String image;
  final String address;

  const User({
    super.id,
    super.role,
    this.address = "",
    this.firstName = "",
    this.lastName = "",
    this.image = "",
  });

  @override
  List<Object?> get props => [id];
}
