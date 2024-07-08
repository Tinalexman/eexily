import 'package:eexily/components/usage.dart';
import 'package:eexily/components/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const User dummyUser = User(
  firstName: "John",
  lastName: "Doe",
  image: "assets/images/user.png",
  role: UserRole.regular,
);

final StateProvider<User> userProvider = StateProvider((ref) => dummyUser);
final StateProvider<bool> shownGasToast = StateProvider((ref) => false);
final StateProvider<bool> startGasTimerProvider = StateProvider((ref) => false);

final StateProvider<List<UsageData>> dailyUsages = StateProvider(
  (ref) => [
    UsageData(
      initialVolume: 12.0,
      finalVolume: 11.5,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    ),
    UsageData(
      initialVolume: 11.5,
      finalVolume: 10.6,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    ),
    UsageData(
      initialVolume: 10.6,
      finalVolume: 9.0,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    ),
    UsageData(
      initialVolume: 9.0,
      finalVolume: 5.1,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    ),
  ],
);
final StateProvider<List<UsageData>> weeklyUsages = StateProvider(
  (ref) => [
    UsageData(
      initialVolume: 12.0,
      finalVolume: 11.5,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    ),
    UsageData(
      initialVolume: 11.5,
      finalVolume: 10.6,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    ),
    UsageData(
      initialVolume: 10.6,
      finalVolume: 9.0,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    ),
    UsageData(
      initialVolume: 9.0,
      finalVolume: 5.1,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
    ),
  ],
);
final StateProvider<UsageData> monthlyUsages = StateProvider(
  (ref) => UsageData(
    initialVolume: 12.0,
    finalVolume: 11.5,
    startTime: DateTime.now(),
    endTime: DateTime.now(),
  ),
);

void logout(WidgetRef ref) {
  ref.invalidate(shownGasToast);
  ref.invalidate(startGasTimerProvider);
  ref.invalidate(userProvider);
  ref.invalidate(dailyUsages);
  ref.invalidate(weeklyUsages);
  ref.invalidate(monthlyUsages);
}
