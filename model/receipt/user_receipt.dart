import 'package:com_goodtakes/model/base/base_model.dart';
import 'package:com_goodtakes/model/base/meta_tag.dart';
import 'package:com_goodtakes/model/base/receipt/receipt_base.dart';
import 'package:com_goodtakes/model/base/receipt/receipt_extension.dart';
import 'package:com_goodtakes/model/transaction/transaction_detail.dart';
import 'package:com_goodtakes/model/base/transaction_summary/transaction_summary.dart';
import 'package:flutter/material.dart';

class UserReceipt extends ReceiptBase {
  final String restroName;
  final String restroAddress;
  final Map<String, dynamic> payment;
  UserReceipt._(
      {required this.restroAddress,
      required this.payment,
      required this.restroName,
      required ReceiptStatus status,
      required double amount,
      required TransactionDetail detail,
      required double discount,
      required double payable,
      required DateTimeRange pickupTime,
      required TransactionSummary transactionSummary,
      required Map<String, dynamic> meta,
      required String id})
      : super(
            status: status,
            amount: amount,
            detail: detail,
            discount: discount,
            payable: payable,
            pickupTime: pickupTime,
            transactionSummary: transactionSummary,
            meta: meta,
            id: id);

  factory UserReceipt.build(Map map, String id) {
    return UserReceipt._(
        payment:
            (map[ReceiptDbKey.payment.dbKey] as Map).cast<String, dynamic>(),
        restroAddress: map[ReceiptDbKey.restroAddress.dbKey],
        restroName: map[ReceiptDbKey.restroName.dbKey],
        status: ReceiptStatusMethod.valueAt((map[ReceiptDbKey.status.dbKey])),
        amount: (map[ReceiptDbKey.amount.dbKey] as num).toDouble(),
        detail: TransactionDetail.build(map[ReceiptDbKey.detail.dbKey],
            map[ReceiptDbKey.detail.dbKey]["basket_id"]),
        discount: (map[ReceiptDbKey.discount.dbKey] as num).toDouble(),
        payable: (map[ReceiptDbKey.payable.dbKey] as num).toDouble(),
        pickupTime: DateTimeRange(
            start: DateTime.fromMillisecondsSinceEpoch(
                map[ReceiptDbKey.pickupTime.dbKey][dbDatetimeRangeStartTag]),
            end: DateTime.fromMillisecondsSinceEpoch(
                map[ReceiptDbKey.pickupTime.dbKey][dbDatetimeRangeCloseTag])),
        transactionSummary: TransactionSummary.build(
            map[ReceiptDbKey.transactionSummary.dbKey]),
        meta: (map[baseModelDBKeyMeta] as Map).cast<String, dynamic>(),
        id: id);
  }
}
