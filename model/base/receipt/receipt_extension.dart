enum ReceiptStatus { waitingForVerify, verified, complete }

extension ReceiptStatusMethod on ReceiptStatus {
  String get dbValue {
    switch (this) {
      case ReceiptStatus.waitingForVerify:
        return "waiting_for_verify";
      default:
        return name;
    }
  }

  static ReceiptStatus valueAt(String status) {
    switch (status) {
      case "waiting_for_verify":
        return ReceiptStatus.waitingForVerify;
      case "complete":
        return ReceiptStatus.complete;
      case "verified":
        return ReceiptStatus.verified;
      default:
        throw ArgumentError.value(status);
    }
  }
}

enum ReceiptDbKey {
  detail,
  transactionSummary,
  amount,
  discount,
  payable,
  pickupTime,
  restroAddress,
  restroName,
  userName,
  status,
  payment,
  paymentMethod,
  completeType
}

extension ReceiptDbKeyMethod on ReceiptDbKey {
  String get dbKey {
    switch (this) {
      case ReceiptDbKey.detail:
        return "detail";
      case ReceiptDbKey.transactionSummary:
        return "transaction_summary";
      case ReceiptDbKey.restroAddress:
        return "restro_address";
      case ReceiptDbKey.restroName:
        return "restro_name";
      case ReceiptDbKey.pickupTime:
        return "pick_up_time";
      case ReceiptDbKey.paymentMethod:
        return "payment_method";
      case ReceiptDbKey.userName:
        return "user_name";
      case ReceiptDbKey.completeType:
        return "complete_type";

      default:
        return name;
    }
  }
}
