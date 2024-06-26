import 'package:eexily/components/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const User dummyUser = User(
  firstName: "John",
  lastName: "Doe",
);

final StateProvider<User> userProvider = StateProvider((ref) => dummyUser);

void logout(WidgetRef ref) {
  ref.invalidate(userProvider);
}
