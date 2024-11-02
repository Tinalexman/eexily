// final uniqueTransRef = PayWithPayStack().generateUuidV4()
//
// PayWithPayStack().now(
// context: context
// secretKey:
// "sk_live_XXXXXXXXXXXXXXXXXXXXXXXXXXXX",
// customerEmail: "your@email.com",
// reference:uniqueTransRef,
// callbackUrl: "setup in your paystack dashboard"
// currency: "GHS",
// paymentChannel:["mobile_money", "card"],
// amount: 2000,
// transactionCompleted: () {
// print("Transaction Successful");
// },
// transactionNotCompleted: () {
// print("Transaction Not Successful!");
// });