import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String image;

  const User({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.image = "",
  });

  @override
  List<Object?> get props => [id];
}
