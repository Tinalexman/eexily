import 'package:eexily/api/base.dart';

Future<EexilyResponse<dynamic>> getBankInfo(
  String accountNumber,
  String bankCode,
) async {
  Dio bankDio = Dio(
    BaseOptions(
      baseUrl: "https://app.nuban.com.ng/api",
    ),
  );

  try {
    Response response = await bankDio.get(
      "/NUBAN-BUEOFPVS2352",
      queryParameters: {
        "bank_code": bankCode,
        "acc_no": accountNumber,
      },
    );
    return EexilyResponse(
      message: "Success",
      payload: response.data as List<dynamic>,
      status: true,
    );
  } catch (e) {
    log("Bank Details Error: $e");
  }

  return const EexilyResponse(
    message: "An error occurred",
    payload: null,
    status: false,
  );
}
