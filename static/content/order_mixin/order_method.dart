import 'package:com_goodtakes/model/basket/basket.dart';

mixin OrderSummary {
  Map<Basket, int> get basketCounter;

  late final double totalDiscount = basketCounter.entries
      .map((e) => (e.key.originalPrice - e.key.promotionPrice) * e.value)
      .reduce((a, b) => a + b);
  late final double totalAmount = basketCounter.entries
      .map((e) => ((e.key.originalPrice) * e.value) * e.value)
      .reduce((a, b) => a + b);
  late final double totalPayable = totalAmount - totalDiscount;
}
