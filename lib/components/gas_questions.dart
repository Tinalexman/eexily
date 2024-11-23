import 'package:eexily/main.dart';

class IndividualGasQuestionsData {
  final int gasFilledPerTime;
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
    this.gasFilledPerTime = -1,
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
    int? gasFilledPerTime,
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

  Map<String, dynamic> toJson() {
    return {
      "usualAmountValue": gasFilledPerTime,
      "daysofUse": consumptionDuration,
      "frequentUsage": gasUsagePeriod,
      "dailyMeals": householdMeals,
      "typeOfCooking": cookingType,
      "houseHoldSize": householdSize,
      "typeOfHouseHold": householdType,
      "genderComposition": householdGender,
      "usageAsideCooking": gasUsageAsidesCooking == "true",
      "isOvenUsage": false,
      "frequentRefillPerMonth": gasMonthlyRefill,
      "lastRefill": lastGasFilledPeriod,
      "amountValue": lastGasFilledQuantity,
    };
  }
}

class BusinessGasQuestionsData {
  final bool useBackupCylinders;
  final String mainCylinderSize;
  final String mainCylinderDuration;
  final int numberOfBackupCylinders;
  final List<String> backupCylinderSizes;
  final String dailyGasUsage;
  final String refillPreference;
  final String refillTimes;
  final String customerRange;

  const BusinessGasQuestionsData({
    this.backupCylinderSizes = const [],
    this.customerRange = "",
    this.dailyGasUsage = "",
    this.mainCylinderDuration = "",
    this.mainCylinderSize = "",
    this.numberOfBackupCylinders = 0,
    this.refillPreference = "",
    this.refillTimes = "",
    this.useBackupCylinders = false,
  });

  BusinessGasQuestionsData copyWith({
    bool? useBackupCylinders,
    String? mainCylinderSize,
    String? mainCylinderDuration,
    int? numberOfBackupCylinders,
    List<String>? backupCylinderSizes,
    String? dailyGasUsage,
    String? refillPreference,
    String? refillTimes,
    String? customerRange,
  }) {
    return BusinessGasQuestionsData(
      useBackupCylinders: useBackupCylinders ?? this.useBackupCylinders,
      mainCylinderSize: mainCylinderSize ?? this.mainCylinderSize,
      mainCylinderDuration: mainCylinderDuration ?? this.mainCylinderDuration,
      numberOfBackupCylinders: numberOfBackupCylinders ?? this.numberOfBackupCylinders,
      backupCylinderSizes: backupCylinderSizes ?? this.backupCylinderSizes,
      dailyGasUsage: dailyGasUsage ?? this.dailyGasUsage,
      refillPreference: refillPreference ?? this.refillPreference,
      refillTimes: refillTimes ?? this.refillTimes,
      customerRange: customerRange ?? this.customerRange,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "useBackupCylinders" : useBackupCylinders,
      "mainCylinderSize": mainCylinderSize,
      "mainCylinderDuration": mainCylinderDuration,
      "numberOfBackupCylinders": numberOfBackupCylinders,
      "backupCylinderSizes": backupCylinderSizes,
      "dailyGasUsage": dailyGasUsage,
      "refillPreference": refillPreference,
      "refillTimes": refillTimes,
      "customerRange": customerRange,
    };
  }
}
