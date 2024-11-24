class GasData {
  int gasSize;
  bool isPaused;
  double gasAmountLeft;
  String? completionDate;

  GasData({
    this.isPaused = true,
    this.gasSize = 0,
    this.gasAmountLeft = 0.0,
    this.completionDate,
  });
}
