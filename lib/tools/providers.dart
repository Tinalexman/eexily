import 'dart:math';

import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/components/notification.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/sale_report.dart';
import 'package:eexily/components/transaction.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/components/user/driver.dart';
import 'package:eexily/components/user/support.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/tools/functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const UserBase dummyBase = UserBase(
  email: "test@mail.com",
  role: UserRole.individual,
);

const User dummyUser = User(
  firstName: "John",
  lastName: "Doe",
  image: "assets/images/man.png",
  role: UserRole.individual,
  address: "House 12, Camp Junction, Abeokuta",
);

const Attendant dummyAttendant = Attendant(
  gasStation: "Texxon Gas",
  balance: 250450,
  retailGasPrice: 800,
  regularGasPrice: 900,
);

const Support dummySupport = Support(
  firstName: "Abigeal",
  lastName: "Mabinuori",
  email: "abigail0908@mail.com",
  supportRole: "Customer Service Rep 1",
);

const Driver dummyDriver = Driver(
  firstName: "Mide",
  lastName: "Martins",
  image: "assets/images/man.png",
);

final StateProvider<UserBase> userProvider = StateProvider((ref) => dummyUser);

final StateProvider<bool> shownGasToast = StateProvider((ref) => false);

final StateProvider<List<Notification>> notificationsProvider =
    StateProvider((ref) {
  String name = ref.watch(userProvider.select((u) => u.firstName));
  return [
    Notification(
      message: "Hello $name, your gas has been exhausted completely.",
      read: false,
      timestamp: DateTime.now(),
    ),
    Notification(
      message: "Hello $name, your gas level is currently low.",
      read: true,
      timestamp: DateTime.now(),
    ),
  ];
});

final StateProvider<List<Order>> pendingOrdersProvider = StateProvider(
  (ref) => List.generate(
    15,
    (_) => Order(
      deliveryDate: DateTime.now(),
      code: randomGCode,
      name: "Habeeb Lawal",
      phone: "09012345678",
      address: "No 12, Babylon Street, Accord",
      deliveryIssue: "Delivery bike broke down",
      riderBike: "360-HG",
      price: 3000,
      riderName: "Dina Martins",
      riderImage: "assets/images/man.png",
    ),
  ),
);

final StateProvider<List<Order>> driverOrdersProvider = StateProvider(
  (ref) => List.generate(
    15,
    (index) => Order(
      deliveryDate: DateTime.now(),
      code: randomGCode,
      id: "$index",
      gasQuantity: 10,
      name: "Habeeb Lawal",
      phone: "09012345678",
      address: "No 12, Babylon Street, Accord",
      deliveryIssue: "Delivery bike broke down",
      riderBike: "360-HG",
      price: 3000,
      riderName: "Dina Martins",
      riderImage: "assets/images/man.png",
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
      phone: "09012345678",
      address: "No 12, Babylon Street, Accord",
      deliveryIssue: "Delivery bike broke down",
      riderBike: "360-HG",
      price: 3000,
      status: OrderStatus.completed,
      riderName: "Dina Martins",
      riderImage: "assets/images/man.png",
    ),
  ),
);

final StateProvider<List<Order>> attendantOrdersProvider = StateProvider(
  (ref) => List.generate(
    30,
    (_) => Order(
      id: randomOrderID,
      deliveryDate: DateTime.now(),
      code: randomGCode,
      name: "Habeeb Lawal",
      phone: "09012345678",
      address: "No 12, Babylon Street, Accord",
      deliveryIssue: "Delivery bike broke down",
      riderBike: "360-HG",
      status: OrderStatus.pending,
      price: 5000,
      riderName: "Dina Martins",
      riderImage: "assets/images/man.png",
    ),
  ),
);

final StateProvider<List<Transaction>> transactionsProvider = StateProvider(
  (ref) => List.generate(10, (index) {
    Random random = Random();
    return Transaction(
      id: "Transaction $index",
      timestamp: DateTime.now(),
      header: "Transfer from Eexily",
      amount: min(1000, random.nextInt(100000)).toDouble(),
      credit: random.nextBool(),
    );
  }),
);

final StateProvider<List<SaleReport>> saleReportsProvider = StateProvider(
  (ref) => List.generate(
    5,
    (index) {
      Random random = Random();
      DateTime dateTime = DateUtilities.getDaysAgo(4 - index);
      return SaleReport(
        timestamp: dateTime,
        id: "Sale Report $index",
        regularPrice: 950,
        retailPrice: 800,
        orders: List.generate(
          min(2, random.nextInt(7)),
          (i) {
            return Order(
              deliveryDate: dateTime,
              id: randomOrderID,
              price: 5000,
              code: randomGCode,
              name: "Habeeb Lawal",
              phone: "09012345678",
              address: "No 12, Babylon Street, Accord",
              deliveryIssue: "Delivery bike broke down",
              riderBike: "360-HG",
              status: OrderStatus.completed,
              riderName: "Dina Martins",
              riderImage: "assets/images/man.png",
            );
          },
        ),
      );
    },
  ),
);

final StateProvider<UserOrder?> currentUserOrderProvider =
    StateProvider((ref) => null);

final StateProvider<List<UserOrder>> previousUserOrdersProvider = StateProvider(
  (ref) => List.generate(
    10,
    (index) => UserOrder(
      gasAmount: 5,
      price: 6000,
      id: "$index",
      username: "John Doe",
      code: randomGCode,
      states: [
        OrderDeliveryData(
          state: OrderState.pickedUp,
          timestamp: DateUtilities.getMinutesBefore(20),
        ),
        OrderDeliveryData(
          state: OrderState.refilled,
          timestamp: DateUtilities.getMinutesBefore(15),
        ),
        OrderDeliveryData(
          state: OrderState.dispatched,
          timestamp: DateUtilities.getMinutesBefore(10),
        ),
        OrderDeliveryData(
          state: OrderState.delivered,
          timestamp: DateUtilities.getMinutesBefore(2),
        ),
      ],
    ),
  ),
);

final StateProvider<int> gasCylinderSizeProvider = StateProvider((ref) => 12);

final StateProvider<int> gasLevelProvider = StateProvider((ref) => 65);

final StateProvider<int> pageIndexProvider = StateProvider((ref) => 0);

final StateProvider<bool> playGasAnimationProvider =
    StateProvider((ref) => false);

final StateProvider<IndividualGasQuestionsData> individualGasQuestionsProvider =
    StateProvider((ref) => const IndividualGasQuestionsData());

void logout(WidgetRef ref) {
  ref.invalidate(gasCylinderSizeProvider);
  ref.invalidate(previousUserOrdersProvider);
  ref.invalidate(currentUserOrderProvider);
  ref.invalidate(playGasAnimationProvider);
  ref.invalidate(gasLevelProvider);
  ref.invalidate(individualGasQuestionsProvider);
  ref.invalidate(driverOrdersProvider);
  ref.invalidate(saleReportsProvider);
  ref.invalidate(attendantOrdersProvider);
  ref.invalidate(pendingOrdersProvider);
  ref.invalidate(orderHistoryProvider);
  ref.invalidate(pageIndexProvider);
  ref.invalidate(shownGasToast);
  ref.invalidate(userProvider);
  ref.invalidate(notificationsProvider);
}
