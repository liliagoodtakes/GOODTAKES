import 'method.dart';

class TransactionSummary {
  int foodSaved;
  double carbonEmissionReduction;
  double moneySaved;
  double incomeAmount;

  TransactionSummary._(
      {required this.carbonEmissionReduction,
      required this.foodSaved,
      required this.moneySaved,
      required this.incomeAmount});

  factory TransactionSummary.build(Map summary) {
    return TransactionSummary._(
        incomeAmount:
            (summary[TransactionSummaryDBKey.carbonEmissionReduction.dbKey]
                        as num?)
                    ?.toDouble() ??
                0.0,
        carbonEmissionReduction:
            (summary[TransactionSummaryDBKey.carbonEmissionReduction.dbKey]
                        as num?)
                    ?.toDouble() ??
                0.0,
        foodSaved: (summary[TransactionSummaryDBKey.foodSaved.dbKey] as num?)
                ?.toInt() ??
            0,
        moneySaved: (summary[TransactionSummaryDBKey.moneySaved.dbKey] as num?)
                ?.toDouble() ??
            0.0);
  }
}
