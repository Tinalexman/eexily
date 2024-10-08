class IndividualGasQuestionsData {
  final String gasFilledPerTime;
  final String consumptionDuration;
  final String gasUsagePeriod;
  final String householdMeals;
  final String cookingType;
  final String householdSize;
  final String householdType;
  final String householdGender;
  final String gasUsageAsidesCooking;
  final String grillOrOvenGasCooker;
  final String gasMonthlyRefill;
  final String lastGasFilledPeriod;
  final String lastGasFilledQuantity;

  const IndividualGasQuestionsData({
    this.gasFilledPerTime = "",
    this.consumptionDuration = "",
    this.gasUsagePeriod = "",
    this.cookingType = "",
    this.householdMeals = "",
    this.householdGender = "",
    this.householdSize = "",
    this.householdType = "",
    this.gasUsageAsidesCooking = "",
    this.grillOrOvenGasCooker = "",
    this.gasMonthlyRefill = "",
    this.lastGasFilledPeriod = "",
    this.lastGasFilledQuantity = "",
  });

  IndividualGasQuestionsData copyWith({
    String? gasFilledPerTime,
    String? consumptionDuration,
    String? gasUsagePeriod,
    String? householdMeals,
    String? cookingType,
    String? householdSize,
    String? householdType,
    String? householdGender,
    String? grillOrOvenGasCooker,
    String? gasUsageAsidesCooking,
    String? gasMonthlyRefill,
    String? lastGasFilledPeriod,
    String? lastGasFilledQuantity,
  }) {
    return IndividualGasQuestionsData(
      gasFilledPerTime: gasFilledPerTime ?? this.gasFilledPerTime,
      consumptionDuration: consumptionDuration ?? this.consumptionDuration,
      gasUsagePeriod: gasUsagePeriod ?? this.gasUsagePeriod,
      householdMeals: householdMeals ?? this.householdMeals,
      cookingType: cookingType ?? this.cookingType,
      householdSize: householdSize ?? this.householdSize,
      householdType: householdType ?? this.householdType,
      householdGender: householdGender ?? this.householdGender,
      gasUsageAsidesCooking:
          gasUsageAsidesCooking ?? this.gasUsageAsidesCooking,
      grillOrOvenGasCooker: grillOrOvenGasCooker ?? this.grillOrOvenGasCooker,
      gasMonthlyRefill: gasMonthlyRefill ?? this.gasMonthlyRefill,
      lastGasFilledPeriod: lastGasFilledPeriod ?? this.lastGasFilledPeriod,
      lastGasFilledQuantity:
          lastGasFilledQuantity ?? this.lastGasFilledQuantity,
    );
  }
}
