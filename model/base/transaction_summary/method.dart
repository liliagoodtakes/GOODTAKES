enum TransactionSummaryDBKey { foodSaved, carbonEmissionReduction, moneySaved }

extension TransactionSummaryDBKeyMethod on TransactionSummaryDBKey {
  static TransactionSummaryDBKey typeOf(String type) {
    switch (type) {
      case "meal_saved":
        return TransactionSummaryDBKey.foodSaved;
      case "carbon_emission_reduction":
        return TransactionSummaryDBKey.carbonEmissionReduction;
      case "money_saved":
        return TransactionSummaryDBKey.moneySaved;
      case "income_amount":
        return TransactionSummaryDBKey.moneySaved;

      default:
        throw ArgumentError.value(type);
    }
  }

  String get dbKey {
    switch (this) {
      case TransactionSummaryDBKey.foodSaved:
        return "meal_saved";
      case TransactionSummaryDBKey.carbonEmissionReduction:
        return "carbon_emission_reduction";
      case TransactionSummaryDBKey.moneySaved:
        return "money_saved";
      default:
        throw ArgumentError.value(this);
    }
  }
}
