import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/service/runtime_properties.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class TransactionDetail {
  final String basketId;
  final int subCount;
  final double subAmount;
  final double subDiscount;
  final double subPayable;
  final String basketName;
  final String basketDescription;
  final String restroId;

  TransactionDetail._(
      {required this.restroId,
      required this.basketId,
      required this.basketName,
      required this.basketDescription,
      required this.subAmount,
      required this.subCount,
      required this.subDiscount,
      required this.subPayable});

  factory TransactionDetail.build(Map itemCount, String id) {
    return TransactionDetail._(
        basketId: id,
        basketDescription: (itemCount["basket_description"] as String?) ??
            "測試 Basket Description",
        restroId: (itemCount["restro_id"] as String?) ?? "test_7282471",
        basketName: (itemCount["basket_name"] as String?) ?? "測試三文治",
        subCount: (itemCount["sub_count"] as num).toInt(),
        subAmount: (itemCount["sub_amount"] as num).toDouble(),
        subPayable: (itemCount["sub_payable"] as num).toDouble(),
        subDiscount: (itemCount["sub_discount"] as num).toDouble());
  }

  Map<String, dynamic> get map => {
        "basket_id": basketId,
        "basket_name": basketName,
        "sub_count": subCount,
        "sub_amount": subAmount,
        "sub_payable": subPayable,
        "sub_discount": subDiscount,
        "basket_description": basketDescription
      };

  Restro? get restro => RM.get<RuntimeProperties>().state.restroAt(restroId);
}
