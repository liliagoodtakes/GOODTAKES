import 'package:com_goodtakes/model/transaction/transaction_detail.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

enum PaymentSessionStatus {
  canceled,
  processing,
  loading,
  billConfirm,
  paying,
  completed
}

class PaymentSession {
  final String sessionId;
  final int itemCount;
  final DateTime expiry;
  final String userId;
  final PaymentSessionStatus status;
  final TransactionDetail detail;
  final String restroId;
  final double amount;
  final double discount;
  final double payable;
  final DateTimeRange pickupTime;
  PaymentSession._({
    required this.amount,
    required this.discount,
    required this.payable,
    required this.detail,
    required this.expiry,
    required this.itemCount,
    required this.sessionId,
    required this.status,
    required this.userId,
    required this.restroId,
    required this.pickupTime,
  });

  /// The Payment Session is used To controll whole payment process
  factory PaymentSession.create(
      {required int count,
      required double amount,
      required double discount,
      required double payable,
      required String basketId,
      required String sessionId,
      required String restroId,
      required DateTimeRange pickupTime,
      required TransactionDetail detail}) {
    final expiry = DateTime.now();
    expiry.add(const Duration(minutes: 10));
    return PaymentSession._(
        restroId: restroId,
        payable: payable,
        amount: amount,
        discount: discount,
        expiry: expiry,
        itemCount: count,
        sessionId: sessionId,
        detail: detail,
        status: PaymentSessionStatus.billConfirm,
        pickupTime: pickupTime,
        userId: RM.get<AuthenticationState>().state.user!.uid);
  }

  String get generalPickUpTimeRangeStatement {
    final starting =
        TimeOfDay.fromDateTime(pickupTime.start).formatAsTwoDigit();
    final ending = TimeOfDay.fromDateTime(pickupTime.end).formatAsTwoDigit();
    final now = DateTime.now();
    if (now.isSameDay(pickupTime.start)) {
      return "今日 $starting-$ending 提取";
    } else {
      return "${pickupTime.start.day}/${pickupTime.start.month} $starting-$ending 提取";
    }
  }

  Map<String, dynamic> get map {
    return {
      "expiry": expiry.millisecondsSinceEpoch,
      "item_count": itemCount,
      "session_id": sessionId,
      "status": status.name,
      "payable": payable,
      "amount": amount,
      "discount": discount,
      "uid": userId,
      "restro_id": restroId,
      "detail": detail.map,
      "pickup_time": {
        "start": pickupTime.start.millisecondsSinceEpoch,
        "close": pickupTime.end.millisecondsSinceEpoch
      }
    };
  }
}
