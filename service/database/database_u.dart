import 'package:com_goodtakes/model/base/base_model.dart';
import 'package:com_goodtakes/model/base/meta_tag.dart';
import 'package:com_goodtakes/model/base/receipt/receipt_extension.dart';
import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/model/basket/basket_extension.dart';
import 'package:com_goodtakes/model/payment_session.dart';
import 'package:com_goodtakes/model/receipt/user_receipt.dart';
import 'package:com_goodtakes/model/transaction/transaction.dart' as gt;
import 'package:com_goodtakes/states/my_restro_state.dart';
import 'package:com_goodtakes/static/firebase_ref_path.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:uuid/uuid.dart';

/// User Profile

Future<void> updateProfile(Map<String, dynamic> profile) async {
  final DatabaseReference? profileRef =
      DatabaseRootMethod.userDBReference(type: UserRootReferenceType.profile);

  await profileRef?.update(profile);
}

/// Basket Update
Future<Basket> updateBasket(
    {required Map<String, dynamic> basket,
    required String restroId,
    required String? basketId}) async {
  final root = DatabaseRootMethod.baseketRoot(restroId);
  final bid = basketId ?? const Uuid().v4().split("-").last;
  await root.update({bid: basket});
  DatabaseRoot.restroProfile.standardReference
      .child([restroId, baseModelDBKeyMeta, dbMetaModify].join("/"))
      .set(DateTime.now().millisecondsSinceEpoch);
  root.update({bid: basket});

  return Basket.build(basket, bid, restroId);
}

Future<void> unListBasket(
    {required String restroId, required String basketId}) async {
  final root = DatabaseRootMethod.baseketRoot(restroId)
      .child([basketId, "status"].join("/"));

  await root.set(BasketStatus.disable.name);
}

Future<void> completeTransaction({required UserReceipt receipt}) async {
  await Future.wait<void>([
    // DatabaseRootMethod.userDBReference()!
    //     .child(["receipt", receipt.id].join("/"))
    //     .update({
    //   ReceiptDbKey.status.dbKey: ReceiptStatus.complete.dbValue,
    //   ReceiptDbKey.completeType.dbKey: "manual"
    // }),
    DatabaseRoot.transaction.standardReference
        .child(receipt.meta["transaction_id"])
        .update({
      ReceiptDbKey.status.dbKey: ReceiptStatus.complete.dbValue,
      ReceiptDbKey.completeType.dbKey: "manual"
    }),
    // DatabaseRoot.restroReceipt.standardReference
    //     .child([receipt.meta["restro_id"], receipt.meta["order_id"]].join("/"))
    //     .update({
    //   ReceiptDbKey.status.dbKey: ReceiptStatus.complete.dbValue,
    //   ReceiptDbKey.completeType.dbKey: "manual"
    // })
  ]);
}

Future<void> releasePaymentSession(PaymentSession session) async {
  try {
    final sessionRef =
        DatabaseRootMethod.configDBReference(ConfigRootReferenceType.session)
            .child(session.sessionId);
    final data = await sessionRef.get();
    if (data.exists) {
      sessionRef.update({"status": "onKill"});
      final DatabaseReference m =
          DatabaseRoot.restroProfile.standardReference.child([
        session.restroId,
        DatabaseRoot.basket.name,
        session.detail.basketId,
        baseModelDBKeyMeta,
        "locked_item"
      ].join("/"));

      final lockItemCount = (await m.once()).snapshot.value as int;

      debugPrint("lockItemCount : $lockItemCount");
      final newTotal = lockItemCount - session.itemCount;
      Future.wait([m.set(newTotal), sessionRef.remove()]);
      return;
    }
  } on FirebaseException catch (e) {
    debugPrint("error catched");
    debugPrint("${e.message}");
  }
}

Future<void> updateMyNotificationReadMd() async {
  final md = DateTime.now().millisecondsSinceEpoch;
  DatabaseRootMethod.userDBReference(type: UserRootReferenceType.profile)
      ?.child("meta")
      .child(dbMetaNotificationReadMd)
      .set(md);
}

Future<void> updateRestroNotificationReadMd(String restroId) async {
  final md = DateTime.now().millisecondsSinceEpoch;
  DatabaseRootMethod.userDBReference(type: UserRootReferenceType.myRestro)
      ?.child(restroId)
      .child(dbMetaNotificationReadMd)
      .set(md);
  RM.get<MyRestroState>().setState(
      (s) => s.myRestroMeta?[restroId][dbMetaNotificationReadMd] = md);
}
