import 'package:com_goodtakes/model/base/base_model.dart';
import 'package:com_goodtakes/model/base/receipt/receipt_extension.dart';
import 'package:com_goodtakes/model/base/transaction_summary/transaction_summary.dart';

import 'package:com_goodtakes/model/transaction/transaction_detail.dart';

import 'package:flutter/material.dart';

abstract class ReceiptBase extends BaseModel {
  final TransactionDetail detail;
  final double amount;
  final double discount;
  final double payable;
  final DateTimeRange pickupTime;
  final TransactionSummary transactionSummary;

  ReceiptStatus status;

  ReceiptBase(
      {required this.amount,
      required this.detail,
      required this.discount,
      required this.payable,
      required this.pickupTime,
      required this.transactionSummary,
      required Map<String, dynamic> meta,
      required this.status,
      required String id})
      : super(meta, id);
}
