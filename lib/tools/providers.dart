import 'package:eexily/api/file_handler.dart';
import 'package:eexily/components/gas_questions.dart';
import 'package:eexily/components/notification.dart';
import 'package:eexily/components/order.dart';
import 'package:eexily/components/sale_report.dart';
import 'package:eexily/components/transaction.dart';
import 'package:eexily/components/user/attendant.dart';
import 'package:eexily/components/user/driver.dart';
import 'package:eexily/components/user/merchant.dart';
import 'package:eexily/components/user/support.dart';
import 'package:eexily/components/user/user.dart';
import 'package:eexily/database.dart';
import 'package:eexily/tools/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const UserBase dummyBase = UserBase();

const User dummyUser = User(
  lastName: "Doe",
  firstName: "John",
  email: "johndoe@mail.com",
  image: "https://picsum.com/photos/200",
);

const Attendant dummyAttendant = Attendant(
  image: "https://picsum.com/photos/200",
);

const Merchant dummyMerchant = Merchant(
  firstName: "John",
  lastName: "Doe",
  image: "https://picsum.com/photos/200",
);

const Support dummySupport = Support(
  image: "https://picsum.com/photos/200",
);

const Driver dummyDriver = Driver(
  image: "https://picsum.com/photos/200",
);

Order dummyOrder = const Order(
  id: "id",
  code: "code",
  price: 0,
  paymentUrl: "",
  paymentMethod: "",
  quantity: 0,
  reference: "",
  sellerType: "GAS_STATION",
  createdAt: "1960-01-01T00:00:00.000Z",
  states: [],
  status: "PENDING",
  metadata: OrderMetadata(
    userPhoneNumber: "userPhoneNumber",
    userName: "userName",
    riderPhoneNumber: "riderPhoneNumber",
    pickUpLocation: "pickupLocation",
    pickUpAddress: "pickUpAddress",
    merchantPhoneNumber: "merchantPhoneNumber",
    merchantName: "merchantName",
    merchantAddress: "merchantAddress",
    gasStationName: "gasStationName",
    gasStationLocation: "gasStationLocation",
    gasStationAddress: "gasStationAddress",
    riderName: "riderName",
  ),
);

List<Order> dummyOrders = List.filled(10, dummyOrder);

final List<Notification> dummyNotifications = List.generate(
  10,
  (_) => Notification(
    timestamp: DateTime.now(),
    actionLabel: "Action Label",
    read: false,
    message: loremIpsum.substring(0, 100),
    notificationType: "",
  ),
);

final StateProvider<UserBase> userProvider = StateProvider((ref) => dummyBase);

final StateProvider<bool> loadingInitialExpressOrdersProvider =
    StateProvider((ref) => true);

final StateProvider<bool> loadingInitialStandardOrdersProvider =
    StateProvider((ref) => true);

final StateProvider<List<Order>> initialExpressOrdersProvider =
    StateProvider((ref) => []);

final StateProvider<List<Order>> initialStandardOrdersProvider =
    StateProvider((ref) => []);

final StateProvider<List<Notification>> notificationsProvider =
    StateProvider((ref) => []);

final StateProvider<List<Order>> pendingOrdersProvider =
    StateProvider((ref) => []);

final StateProvider<List<Order>> driverOrdersProvider =
    StateProvider((ref) => []);

final StateProvider<List<Order>> orderHistoryProvider =
    StateProvider((ref) => []);

final StateProvider<List<Order>> attendantOrdersProvider =
    StateProvider((ref) => []);

final StateProvider<List<Order>> merchantOrdersProvider =
    StateProvider((ref) => []);

final StateProvider<List<Transaction>> transactionsProvider =
    StateProvider((ref) => []);

final StateProvider<List<SaleReport>> saleReportsProvider =
    StateProvider((ref) => []);

final StateProvider<int> gasCylinderSizeProvider = StateProvider((ref) => 0);

final StateProvider<String?> gasEndingDateProvider =
    StateProvider((ref) => null);

final StateProvider<int> gasLevelProvider = StateProvider((ref) => 0);

final StateProvider<int> pageIndexProvider = StateProvider((ref) => 0);

final StateProvider<bool> playGasAnimationProvider =
    StateProvider((ref) => false);

final StateProvider<IndividualGasQuestionsData> individualGasQuestionsProvider =
    StateProvider((ref) => const IndividualGasQuestionsData());

final StateProvider<BusinessGasQuestionsData> businessGasQuestionsProvider =
    StateProvider((ref) => const BusinessGasQuestionsData());

final StateProvider<double> revenueProvider = StateProvider((ref) => 0);

void logout(WidgetRef ref) {
  ref.invalidate(initialExpressOrdersProvider);
  ref.invalidate(initialStandardOrdersProvider);
  ref.invalidate(revenueProvider);
  ref.invalidate(gasEndingDateProvider);
  ref.invalidate(gasCylinderSizeProvider);
  ref.invalidate(playGasAnimationProvider);
  ref.invalidate(gasLevelProvider);
  ref.invalidate(businessGasQuestionsProvider);
  ref.invalidate(individualGasQuestionsProvider);
  ref.invalidate(driverOrdersProvider);
  ref.invalidate(saleReportsProvider);
  ref.invalidate(attendantOrdersProvider);
  ref.invalidate(pendingOrdersProvider);
  ref.invalidate(orderHistoryProvider);
  ref.invalidate(pageIndexProvider);
  ref.invalidate(userProvider);
  ref.invalidate(merchantOrdersProvider);
  ref.invalidate(notificationsProvider);
  ref.invalidate(loadingInitialExpressOrdersProvider);
  ref.invalidate(loadingInitialStandardOrdersProvider);
  DatabaseManager.clearAllMessages();
  FileHandler.saveAuthDetails(null);
}
