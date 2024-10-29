import 'base.dart';
export 'base.dart';

class User extends UserBase {
  final String image;
  final String address;
  final bool hasCompletedGasQuestions;

  const User({
    super.id,
    super.email,
    super.firstName,
    super.lastName,
    super.dateJoined,
    super.phoneNumber,
    this.address = "",
    this.image = "",
    this.hasCompletedGasQuestions = false,
  }) : super(role: UserRole.individual);

  @override
  List<Object?> get props => [id];

  User withFields({
    int? gasSize,
    bool? hasCompletedGas,
    String? address,
    String? dateJoined,
    String? email,
    String? firstName,
    String? image,
    String? lastName,
    String? phoneNumber,
  }) {
    return User(
      hasCompletedGasQuestions: hasCompletedGas ?? hasCompletedGasQuestions,
      address: address ?? this.address,
      dateJoined: dateJoined ?? this.dateJoined,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      id: id,
      image: image ?? this.image,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  User copyWith(User otherUser) {
    String email = otherUser.email.isEmpty ? this.email : otherUser.email;
    String firstName =
        otherUser.firstName.isEmpty ? this.firstName : otherUser.firstName;
    String lastName =
        otherUser.lastName.isEmpty ? this.lastName : otherUser.lastName;
    String dateJoined =
        otherUser.dateJoined.isEmpty ? this.dateJoined : otherUser.dateJoined;
    String address =
        otherUser.address.isEmpty ? this.address : otherUser.address;
    String image = otherUser.image.isEmpty ? this.image : otherUser.image;
    bool completed = otherUser.hasCompletedGasQuestions;

    return User(
      email: email,
      firstName: firstName,
      lastName: lastName,
      dateJoined: dateJoined,
      image: image,
      id: id,
      address: address,
      hasCompletedGasQuestions: completed,
    );
  }
}
