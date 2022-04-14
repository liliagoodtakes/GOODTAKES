// import 'package:com_goodtakes/model/base/base_model.dart';
// import 'package:com_goodtakes/model/base/transaction_summary/transaction_summary.dart';
// import 'package:com_goodtakes/model/transaction/transaction_detail.dart';
// import 'package:com_goodtakes/model/transaction/transaction_extension.dart';
// import 'package:com_goodtakes/service/convertor/datetime.dart';
// import 'package:flutter/material.dart';

// class Transaction extends BaseModel {
//   final String restroId;
//   final List<String> items;
//   final String refId;
//   final double totalAmount;
//   final double totalDiscount;
//   final double totalPayable;
//   final int? completeTime;
//   final int? completeType;
//   final DateTimeRange pickupTime;
//   final TransactionSummary summary;
//   final List<TransactionDetail> itemDetails;
//   final Map<String, dynamic> completion;
//   final Map<String, String> payment;
//   final String uid;

//   const Transaction._(
//       {required this.itemDetails,
//       required this.payment,
//       required this.completion,
//       required this.restroId,
//       required this.items,
//       required this.refId,
//       required this.totalAmount,
//       required this.pickupTime,
//       required this.totalDiscount,
//       required this.totalPayable,
//       required this.completeTime,
//       required this.completeType,
//       required this.summary,
//       required this.uid,
//       required String recordId,
//       required Map<String, dynamic> meta})
//       : super(meta, recordId);

//   factory Transaction.build(Map content, String recordId) {
//     return Transaction._(
//         payment: (content[TransactionDBKey.payment.dbKey] as Map)
//             .cast<String, String>(),
//         pickupTime: DateTimeRange(
//             start: DateTime.fromMillisecondsSinceEpoch(
//                 content[TransactionDBKey.pickupTime.dbKey]['start']),
//             end: DateTime.fromMillisecondsSinceEpoch(
//                 content[TransactionDBKey.pickupTime.dbKey]['close'])),
//         itemDetails: (content[TransactionDBKey.detail.dbKey] as Map)
//             .entries
//             .map((e) => TransactionDetail.build(e.value, e.key))
//             .toList(),
//         restroId: content[TransactionDBKey.restroId.dbKey],
//         items: (content[TransactionDBKey.items.dbKey] as List).cast<String>(),
//         refId: content[TransactionDBKey.refId.dbKey],
//         completion: Map.castFrom<dynamic, dynamic, String, dynamic>(
//             content[TransactionDBKey.completion.dbKey] ?? {}),
//         totalAmount:
//             (content[TransactionDBKey.totalAmount.dbKey] as num).toDouble(),
//         totalDiscount:
//             (content[TransactionDBKey.totalDiscount.dbKey] as num).toDouble(),
//         totalPayable:
//             (content[TransactionDBKey.totalPayable.dbKey] as num).toDouble(),
//         completeTime: content[TransactionDBKey.completeTime.dbKey],
//         completeType: content[TransactionDBKey.completeType.dbKey],
//         recordId: recordId,
//         summary:
//             TransactionSummary.build(content[TransactionDBKey.summary.dbKey]),
//         uid: content[TransactionDBKey.uid.dbKey],
//         meta: (content[baseModelDBKeyMeta] as Map).cast<String, dynamic>());
//   }

//   static Transaction get demo =>
//       Transaction.build(transactionDemo, "demo_transaction");

//   String get pickupTimeDisplay {
//     final starting =
//         TimeOfDay.fromDateTime(pickupTime.start).formatAsTwoDigit();
//     final ending = TimeOfDay.fromDateTime(pickupTime.end).formatAsTwoDigit();
//     final now = DateTime.now();
//     if (now.isSameDay(pickupTime.start)) {
//       return "今日 $starting-$ending 提取";
//     } else {
//       return "${pickupTime.start.day}/${pickupTime.start.month} $starting-$ending 提取";
//     }
//   }
// }
