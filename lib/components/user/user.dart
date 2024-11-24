import 'base.dart';
export 'base.dart';

class User extends UserBase {
  final bool hasCompletedGasQuestions;

  const User({
    super.id,
    super.email,
    super.firstName,
    super.lastName,
    super.dateJoined,
    super.phoneNumber,
    super.image,
    super.location,
    super.address,
    this.hasCompletedGasQuestions = false,
  }) : super(role: UserRole.individual);

  @override
  List<Object?> get props => [id];

  User copyWith({
    bool? hasCompletedGas,
    String? address,
    String? firstName,
    String? image,
    String? lastName,
    String? phoneNumber,
  }) {
    return User(
      hasCompletedGasQuestions: hasCompletedGas ?? hasCompletedGasQuestions,
      address: address ?? this.address,
      dateJoined: dateJoined,
      email: email,
      firstName: firstName ?? this.firstName,
      id: id,
      image: image ?? this.image,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  User copyFrom(User otherUser) {
    String email = otherUser.email.isEmpty ? this.email : otherUser.email;
    String firstName =
        otherUser.firstName.isEmpty ? this.firstName : otherUser.firstName;
    String lastName =
        otherUser.lastName.isEmpty ? this.lastName : otherUser.lastName;
    String dateJoined =
        otherUser.dateJoined.isEmpty ? this.dateJoined : otherUser.dateJoined;
    String address =
        otherUser.address.isEmpty ? this.address : otherUser.address;
    String phoneNumber =
        otherUser.phoneNumber.isEmpty ? this.phoneNumber : otherUser.phoneNumber;
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
      phoneNumber: phoneNumber,
    );
  }
}
