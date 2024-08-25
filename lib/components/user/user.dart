import 'base.dart';
export 'base.dart';

class User extends UserBase {

  final String image;
  final String address;

  const User({
    super.id,
    super.role,
    super.firstName,
    super.lastName,
    this.address = "",
    this.image = "",
  });

  @override
  List<Object?> get props => [id];
}
