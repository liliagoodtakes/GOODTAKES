// enum TransactionDBKey {
//   uid,
//   userName,
//   restroId,
//   items,
//   refId,
//   completion,
//   totalAmount,
//   totalDiscount,
//   totalPayable,
//   summary,
//   completeTime,
//   completeType,
//   detail,
//   payment,
//   pickupTime
// }

// extension TransactionDBKeyMethod on TransactionDBKey {
//   static TransactionDBKey typeOf(String type) {
//     switch (type) {
//       case "pickup_time":
//         return TransactionDBKey.pickupTime;
//       case "completion":
//         return TransactionDBKey.completion;
//       case "payment":
//         return TransactionDBKey.payment;
//       case "restro_id":
//         return TransactionDBKey.restroId;
//       case "items":
//         return TransactionDBKey.items;
//       case "total_amount":
//         return TransactionDBKey.totalAmount;
//       case "total_discount":
//         return TransactionDBKey.totalDiscount;
//       case "total_payable":
//         return TransactionDBKey.totalPayable;
//       case "ref_id":
//         return TransactionDBKey.refId;
//       case "uid":
//         return TransactionDBKey.uid;
//       case "complete_time":
//         return TransactionDBKey.completeTime;
//       case "complete_type":
//         return TransactionDBKey.completeType;
//       case "summary":
//         return TransactionDBKey.summary;
//       case "detail":
//         return TransactionDBKey.detail;
//       default:
//         throw ArgumentError.value(type);
//     }
//   }

//   String get dbKey {
//     switch (this) {
//       case TransactionDBKey.uid:
//         return "uid";
//       case TransactionDBKey.pickupTime:
//         return "pickup_time";
//       case TransactionDBKey.completion:
//         return "completion";
//       case TransactionDBKey.payment:
//         return "payment";
//       case TransactionDBKey.summary:
//         return "summary";
//       case TransactionDBKey.restroId:
//         return "restro_id";
//       case TransactionDBKey.items:
//         return "items";
//       case TransactionDBKey.totalAmount:
//         return "total_amount";
//       case TransactionDBKey.totalDiscount:
//         return "total_discount";
//       case TransactionDBKey.totalPayable:
//         return "total_payable";
//       case TransactionDBKey.refId:
//         return "ref_id";
//       case TransactionDBKey.completeTime:
//         return "complete_time";
//       case TransactionDBKey.completeType:
//         return "complete_type";
//       case TransactionDBKey.detail:
//         return "detail";
//       default:
//         throw ArgumentError.value(this);
//     }
//   }
// }

// const transactionDemo = {
//   "completion": {"md": 1646618861590, "type": "manual"},
//   "index": {
//     "restro": "-MwHTC2mCko9K008AEL0_completed",
//     "user": "MmwSSEgR23UR6K2KdPpLD3u2eXC2_completed"
//   },
//   "detail": {
//     "52030ea1a74b": {
//       "sub_amount": 264,
//       "sub_count": 3,
//       "sub_discount": 216,
//       "sub_payable": 48
//     }
//   },
//   "items": ["52030ea1a74b"],
//   "meta": {"creation": 1646614800000, "md": 1646614800000, "status": "valid"},
//   "payment": {
//     "payment_id": "test",
//     "payment_method": "visa",
//     "payment_card": "4312"
//   },
//   "pickup_time": {"close": 1646625600000, "start": 1646618400000},
//   "ref_id": "101-001",
//   "restro_id": "-MwHTC2mCko9K008AEL0",
//   "session_id": "-MvNWWJxQ5RJVJtvXebM",
//   "summary": {
//     "carbon_emission_reduction": 132.0,
//     "meal_saved": 264,
//     "money_saved": 216
//   },
//   "total_amount": 264,
//   "total_discount": 216,
//   "total_payable": 48,
//   "uid": "MmwSSEgR23UR6K2KdPpLD3u2eXC2"
// };
