import 'package:com_goodtakes/model/base/meta_tag.dart';
import 'package:com_goodtakes/model/base/receipt/receipt_extension.dart';
import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/model/in_app_notification/in_app_notification.dart';
import 'package:com_goodtakes/model/receipt/restro_receipt.dart';
import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/model/restro/restro_extension.dart';
import 'package:com_goodtakes/service/database/database_r.dart';
import 'package:flutter/material.dart';

class MyRestroState {
  final List<InAppNotification> _notifications = [];
  final List<RestroReceipt> _receipts = [];

  late Restro? _restro;
  late Map? myRestroMeta;
  late Map? _raw;

  // bool get haveUnreadMessage =>
  //     _notifications.any((element) => element.status == 1);

  List<InAppNotification> get notifications => _notifications;
  Restro? get restro => _restro;
  List<RestroReceipt> get receipts => _receipts;
  int get uncompletedCount {
    return receipts
        .where((element) => element.status != ReceiptStatus.complete)
        .length;
  }

  bool get haveUnreadNotification {
    return notifications.any((element) =>
        element.meta[dbMetaCreation] >
        (myRestroMeta?.values.first as Map).values.first);
  }

  String get addressEN => _raw?[RestroDBKey.address.dbKey]?["en"] ?? "";
  String get nameEN => _raw?[RestroDBKey.name.dbKey]?["en"] ?? "";

  Future<void> init() async {
    myRestroMeta = await myRestroList;

    final String? restroId = myRestroMeta?.entries.first.key;
    if (restroId != null) {
      final List datas = await Future.wait([
        myRestroReceipt(restroId).catchError((e) {
          debugPrint("myRestroReceipt:: $e");
        }),
        myRestroNotification(restroId).catchError((e) {
          debugPrint("myRestroTransactionCompleted");
        }),
        rawRestro(restroId).catchError((e) {
          debugPrint("rawRestro $e");
        })
      ]);

      // debugPrint("way point 1");

      _notifications.addAll(datas[1]);
      _restro = Restro.build(datas[2] as Map, restroId);
      _raw = datas[2];
      _receipts.addAll(datas[0]);
      debugPrint("""MyRestroState INIT:::
        data Lengths: _notifications : ${_notifications.length} ///
        _receipt: ${_receipts.length} ///
        _restro : ${_restro?.id}
        """);
    }
  }

  void readNotification(InAppNotification notification) {
    // if (notification.meta[dbMetaStatus] == 1) {
    //   debugPrint("update notification.status");
    //   notification.status = 0;
    // }
  }

  void updateBasket(Basket newBasket) {
    final current = restro!.baskets.map((e) => e.id).toSet();
    if (current.contains(newBasket.id)) {
      restro!.baskets.removeWhere((element) => element.id == newBasket.id);
    }
    restro!.baskets.insert(0, newBasket);
  }

  void clear() {
    _notifications.clear();
    _restro = null;
  }
}
