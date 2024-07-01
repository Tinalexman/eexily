import 'package:eexily/components/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const User dummyUser = User(
  firstName: "John",
  lastName: "Doe",
);

final StateProvider<User> userProvider = StateProvider((ref) => dummyUser);
final StateProvider<bool> shownGasToast = StateProvider((ref) => false);

void logout(WidgetRef ref) {
  ref.invalidate(userProvider);
}
