import 'package:com_goodtakes/model/base/base_model.dart';

class PaymentMethod extends BaseModel {
  final String last4;
  final String issuer;
  final bool isDefault;

  const PaymentMethod._(
      {required Map<String, dynamic> meta,
      required String id,
      required this.last4,
      required this.issuer,
      required this.isDefault})
      : super(meta, id);

  factory PaymentMethod.build(Map paymentMethod, String id) {
    return PaymentMethod._(
        isDefault: paymentMethod["is_default"] as bool,
        id: id,
        last4: paymentMethod["last4"] as String,
        issuer: paymentMethod["issuer"] as String,
        meta:
            (paymentMethod[baseModelDBKeyMeta] as Map).cast<String, dynamic>());
  }
}
