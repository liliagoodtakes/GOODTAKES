import 'package:com_goodtakes/model/base/base_model.dart';
import 'package:com_goodtakes/model/base/meta_tag.dart';
import 'package:com_goodtakes/model/base/transaction_summary/method.dart';
import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/model/payment_session.dart';
import 'package:com_goodtakes/model/restro/restro_extension.dart';
import 'package:com_goodtakes/model/transaction/transaction_detail.dart';
import 'package:com_goodtakes/service/exception/custom_platform_exception.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/firebase_ref_path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

Future<void> syncRestoProfile(Map<String, dynamic> restoProfile,
    [String? id]) async {
  final ref = DatabaseRoot.restroProfile.standardReference;
  if (id == null) {
    final newRef = ref.push();
    await newRef.set(restoProfile);
  } else {
    await ref.child(id).update(restoProfile);
  }
  return;
}

Future<void> syncUserProfile(Map<String, dynamic> userProfile,
    [String? id]) async {
  final ref = DatabaseRoot.user.standardReference;
  if (id == null) {
    final newRef = ref.push();
    await newRef.set(userProfile);
  } else {
    await ref.child(id).update(userProfile);
  }
  return;
}

/// Payment and Payment Sesssion Controll
Future<PaymentSession?> requestPaymentSession(
    TransactionDetail detail, Basket basket) async {
  try {
    // final lockItemCount =
    //     ((await metaLock.child("locked_item").get()).value as int?) ?? 0;

    if (basket.availableStock >= detail.subCount) {
      final metaLock = DatabaseRoot.restroProfile.standardReference.child([
        basket.restroId,
        DatabaseRoot.basket.name,
        basket.id,
        baseModelDBKeyMeta
      ].join("/"));
      debugPrint("meta ref: ${metaLock.path}");

      final newLock = (basket.meta["locked_item"] as int) + detail.subCount;
      debugPrint("Gate 0 newLock ::: $newLock ");
      final sessionRef =
          DatabaseRootMethod.configDBReference(ConfigRootReferenceType.session)
              .push();
      await metaLock.child("locked_item").set(newLock).catchError((e) {
        debugPrint("error $e");
      });

      final PaymentSession newSession = PaymentSession.create(
          amount: detail.subAmount,
          discount: detail.subDiscount,
          payable: detail.subPayable,
          count: detail.subCount,
          basketId: basket.id,
          restroId: basket.restroId,
          sessionId: sessionRef.key!,
          detail: detail,
          pickupTime: basket.pickupTime!);
      sessionRef.set(newSession.map);
      // debugPrint("lockItemCount ::: $newLock");
      return newSession;
    } else {
      throw PlatformExceptionType.outOfStock.exception;
    }
  } on PlatformException catch (e) {
    debugPrint("PlatformException catched");
    debugPrint("${e.message}");
    throw PlatformExceptionType.outOfStock.exception;
  } on FirebaseException catch (e) {
    debugPrint("FirebaseException catched");
    debugPrint("${e.message}");
    throw PlatformExceptionType.outOfStock.exception;
  } catch (e) {
    debugPrint("unknown Error $e");
    throw PlatformExceptionType.outOfStock.exception;
  }
}

Future<bool> requestPaymentProgressLock(PaymentSession session) async {
  final basketId = session.detail.basketId;
  final metaRef = DatabaseRoot.basket.standardReference.child("$basketId/meta");
  final stockRef = DatabaseRoot.basket.standardReference.child(basketId);
  final List<DataSnapshot> snaps = await Future.wait<DataSnapshot>([
    metaRef.child("in_payment_progress").get(),
    stockRef.child("stock").get(),
  ]);
  final int inProgress = ((snaps.first.value as int?) ?? 0);
  final int instantStock = ((snaps.last.value as int?) ?? 0);
  final int newInProgress = inProgress + session.itemCount;
  debugPrint("inProgress : $inProgress ... limitation: $instantStock");
  if (newInProgress < instantStock) {
    metaRef.child("in_payment_progress").set(newInProgress);
    return true;
  } else {
    return false;
  }
}

Future<void> releasePaymentProgressLock(PaymentSession session) async {
  final basketId = session.detail.basketId;
  try {
    final metaRef = DatabaseRoot.basket.standardReference
        .child("$basketId/meta/in_payment_progress");
    final inPaymentProgress = ((await metaRef.get()).value as int?) ?? 0;
    final newCount = inPaymentProgress - session.itemCount;
    debugPrint(
        "ori inPaymentProgress : $inPaymentProgress ::: new ${inPaymentProgress - session.itemCount}");

    metaRef.set(newCount);
  } on FirebaseException catch (e) {
    debugPrint("error catched");
    debugPrint("${e.message}");
  }
}

// Future<void> createRestro() async {
//   final dataStructure = <String, dynamic>{
//     RestroDBKey.name.dbKey: {"zh": "測試餐廳"},
//     RestroDBKey.district.dbKey: "zhone_1",
//     RestroDBKey.description.dbKey: {"zh": "測試餐廳描述"},
//     RestroDBKey.location.dbKey: const LatLng(22.312228, 114.223711).toJson(),
//     RestroDBKey.phone.dbKey: "+852 91234567",
//     RestroDBKey.type.dbKey: {"type_1": true},
//     RestroDBKey.image.dbKey:
//         "https://c.pxhere.com/photos/95/9c/cafe_coffee_woman_chair_table-8104.jpg!d",
//     RestroDBKey.transactionSummary.dbKey: {
//       TransactionSummaryDBKey.carbonEmissionReduction.dbKey: 0,
//       TransactionSummaryDBKey.foodSaved.dbKey: 0,
//       TransactionSummaryDBKey.moneySaved.dbKey: 0
//     },
//     RestroDBKey.email.dbKey: "abc@email.com",
//     "meta": {
//       dbMetaCreation: DateTime.now().millisecondsSinceEpoch,
//       dbMetaModify: DateTime.now().millisecondsSinceEpoch,
//       dbMetaStatus: "normal",
//       dbMetaRefId: "0001",
//       dbMetaBillCount: 0,
//       dbMetaOwner: RM.get<AuthenticationState>().state.user!.uid,
//     }
//   };
//   final DatabaseReference ref = DatabaseRoot.restroProfile.standardReference;
//   final resturantRef = ref.push();
//   debugPrint("ref.push complete");

//   resturantRef.set(dataStructure);
//   final index = {
//     "geo": dataStructure[RestroDBKey.location.dbKey],
//     "type": (dataStructure[RestroDBKey.type.dbKey] as Map).keys.toList(),
//     "area": dataStructure[RestroDBKey.district.dbKey]
//   };

//   DatabaseRootMethod.configDBReference(ConfigRootReferenceType.universal)
//       .child("place_index")
//       .update({resturantRef.key!: index});
// }
