import 'package:eexily/components/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const User dummyUser = User(
  firstName: "John",
  lastName: "Doe",
  role: UserRole.regular,
);

final StateProvider<User> userProvider = StateProvider((ref) => dummyUser);
final StateProvider<bool> shownGasToast = StateProvider((ref) => false);

void logout(WidgetRef ref) {
  ref.invalidate(userProvider);
}
