import 'package:eexily/components/notification.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/points.dart';
import 'package:eexily/components/usage.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/components/user/support.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const User dummyRegularUser = User(
  firstName: "John",
  lastName: "Doe",
  image: "assets/images/user.png",
  role: UserRole.regular,
  address: "House 12, Camp Junction, Abeokuta",
);

const User dummyPremiumUser = User(
  firstName: "John",
  lastName: "Doe",
  image: "assets/images/user.png",
  role: UserRole.premium,
  address: "House 12, Camp Junction, Abeokuta",
);

const Attendant dummyAttendant = Attendant();

const Support dummySupport = Support(
  firstName: "Abigeal",
  lastName: "Mabinuori",
  email: "abigail0908@mail.com",
  supportRole: "Customer Service Rep 1",
);

final StateProvider<UserBase> userProvider =
    StateProvider((ref) => dummySupport);
final StateProvider<bool> shownGasToast = StateProvider((ref) => false);
final StateProvider<bool> startGasTimerProvider = StateProvider((ref) => false);
final StateProvider<List<int>> saverPointsProvider =
    StateProvider((ref) => [25, 30]);
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
final StateProvider<List<Notification>> notificationsProvider =
    StateProvider((ref) {
  String name = ref.watch(userProvider.select((u) => u.firstName));
  return [
    Notification(
      message: "Hello $name, your gas has been exhausted completely.",
      read: false,
    ),
    Notification(
      message: "Hello $name, your gas level is currently low.",
      read: true,
    ),
  ];
});
final StateProvider<List<PointsSaved>> leaderPointsProvider = StateProvider(
  (ref) => List.generate(
    15,
    (_) => const PointsSaved(
      image: "assets/images/user.png",
      name: "John Doe",
      gas: 256,
      belly: 226,
    ),
  ),
);

final StateProvider<PointType> pointTypeProvider =
    StateProvider((ref) => PointType.gas);

final StateProvider<List<PointsTransaction>> pointsTransaction = StateProvider(
  (ref) => [
    PointsTransaction(
      timestamp: DateTime.now(),
      transactionType: PointTransactionType.earned,
      pointType: ref.watch(pointTypeProvider),
      amount: 25,
      total: 45,
    ),
    PointsTransaction(
      timestamp: DateTime.now(),
      transactionType: PointTransactionType.earned,
      pointType: ref.watch(pointTypeProvider),
      amount: 20,
      total: 20,
    ),
    PointsTransaction(
      timestamp: DateTime.now(),
      transactionType: PointTransactionType.expired,
      pointType: ref.watch(pointTypeProvider),
      amount: -25,
      total: 0,
    ),
  ],
);

final StateProvider<List<Order>> pendingOrdersProvider = StateProvider(
  (ref) => List.generate(
    15,
    (_) => Order(
      deliveryDate: DateTime.now(),
      code: randomGCode,
      name: "Habeeb Lawal",
      phone: "+2349012345678",
      address: "No 12, Babylon Street, Accord",
      cylinderSize: 5.0,
      deliveryIssue: "Delivery bike broke down",
      riderBike: "360-HG",
      riderName: "Dina Martins",
    ),
  ),
);

final StateProvider<List<Order>> orderHistoryProvider = StateProvider(
  (ref) => List.generate(
    30,
    (_) => Order(
      deliveryDate: DateTime.now(),
      code: randomGCode,
      name: "Habeeb Lawal",
      phone: "+2349012345678",
      address: "No 12, Babylon Street, Accord",
      cylinderSize: 5.0,
      deliveryIssue: "Delivery bike broke down",
      riderBike: "360-HG",
      status: OrderStatus.completed,
      riderName: "Dina Martins",
    ),
  ),
);

final StateProvider<int> pageIndexProvider = StateProvider((ref) => 0);

void logout(WidgetRef ref) {
  ref.invalidate(pendingOrdersProvider);
  ref.invalidate(orderHistoryProvider);
  ref.invalidate(pageIndexProvider);
  ref.invalidate(shownGasToast);
  ref.invalidate(startGasTimerProvider);
  ref.invalidate(userProvider);
  ref.invalidate(dailyUsages);
  ref.invalidate(weeklyUsages);
  ref.invalidate(monthlyUsages);
  ref.invalidate(notificationsProvider);
  ref.invalidate(saverPointsProvider);
  ref.invalidate(leaderPointsProvider);
  ref.invalidate(pointsTransaction);
  ref.invalidate(pointTypeProvider);
}
