import 'base.dart';
export 'base.dart';

class User extends UserBase {

  final String image;
  final String address;
  final bool hasCompletedGasQuestions;

  const User({
    super.id,
    super.role,
    super.email,
    super.firstName,
    super.lastName,
    super.dateJoined,
    super.phoneNumber,
    this.address = "",
    this.image = "",
    this.hasCompletedGasQuestions = false,
  });


  String get fullName => "$firstName $lastName";

  @override
  List<Object?> get props => [id];


  User copyWith(User otherUser) {
    String email = otherUser.email.isEmpty ? this.email : otherUser.email;
    String firstName = otherUser.firstName.isEmpty ? this.firstName : otherUser.firstName;
    String lastName = otherUser.lastName.isEmpty ? this.lastName : otherUser.lastName;
    String dateJoined = otherUser.dateJoined.isEmpty ? this.dateJoined : otherUser.dateJoined;
    String address = otherUser.address.isEmpty ? this.address : otherUser.address;
    String image = otherUser.image.isEmpty ? this.image : otherUser.image;
    bool completed = otherUser.hasCompletedGasQuestions;

    return User(
      role: UserRole.individual,
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
