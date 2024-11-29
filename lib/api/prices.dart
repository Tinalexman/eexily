import "base.dart";

class GasPrices {
  final int expressDeliveryFee;
  final int standardDeliveryFee;
  final int merchantGasPrice;
  final int gasPrice;

  const GasPrices({
    this.expressDeliveryFee = 0,
    this.standardDeliveryFee = 0,
    this.gasPrice = 0,
    this.merchantGasPrice = 0,
  });
}

Future<EexilyResponse<GasPrices?>> getPrices() async {
  try {
    Response response = await dio.get(
      "/prices",
      options: configuration,
    );

    if (response.statusCode! == 200) {
      Map<String, dynamic> data = response.data;

      return EexilyResponse(
        message: "Gas Prices Retrieved",
        payload: GasPrices(
          expressDeliveryFee: (data["expressDeliveryFee"] as num).toInt(),
          standardDeliveryFee: (data["standardDeliveryFee"] as num).toInt(),
          gasPrice: (data["gasPrice"] as num).toInt(),
          merchantGasPrice: (data["merchantGasPrice"] as num).toInt(),
        ),
        status: true,
      );
    }
  } on DioException catch (e) {
    return EexilyResponse(
      message: e.response?.data["message"] ?? "An error occurred.",
      payload: null,
      status: false,
    );
  } catch (e) {
    log("Get Prices: $e");
  }

  return const EexilyResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: false,
  );
}
