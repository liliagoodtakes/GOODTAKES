import 'dart:convert';

import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/model/basket/basket_extension.dart';
import 'package:com_goodtakes/model/in_app_notification/in_app_notification.dart';
import 'package:com_goodtakes/model/receipt/restro_receipt.dart';
import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/model/restro/restro_extension.dart';
import 'package:com_goodtakes/model/user/user_extension.dart';
import 'package:com_goodtakes/service/database/helper.dart';
import 'package:com_goodtakes/service/runtime_properties.dart';
import 'package:com_goodtakes/states/authentication_state.dart';
import 'package:com_goodtakes/static/firebase_ref_path.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:http/http.dart' as http;

// Future<List<Restro>> get fullRestro async {
//   final ref = DatabaseRoot.restroProfile.standardReference;
//   final refData = await ref.get();
//   if (refData.exists) {
//     final data = refData.value as Map;
//     return List.generate(data.length, (index) {
//       return Restro.build(data.entries.elementAt(index).value as Map,
//           data.entries.elementAt(index).key);
//     });
//   } else {
//     return [];
//   }
// }

Future<List<Restro>> get availableRestro async {
  final ref = DatabaseRoot.restroProfile.standardReference;
  final refData = await ref.get();
  if (refData.exists) {
    final data = refData.value as Map;
    return List.generate(data.length, (index) {
      return Restro.build(data.entries.elementAt(index).value as Map,
          data.entries.elementAt(index).key);
    });
  } else {
    return [];
  }
}

Future<Iterable<Restro>> get availableRestroUpdate async {
  final ref = DatabaseRoot.restroProfile.standardReference;
  final dt = RM.get<RuntimeProperties>().state.runtimeVersion;
  final refData =
      await ref.orderByChild(orderByCreationPath).startAfter(dt).once();
  if (refData.snapshot.exists) {
    // debugPrint(
    //     "availableRestroUpdate refData.snapshot : ${refData.snapshot.value} ");
    final mapped = refData.snapshot.value as Map;
    return mapped.entries.map((e) => Restro.build(e.value as Map, e.key));
  } else {
    return [];
  }
}

// Future<List<Restro>> get myRestro async {
//   final ref = DatabaseRoot.restroProfile.standardReference;
//   final refData = ref
//       .orderByChild("meta/owner")
//       .equalTo(RM.get<AuthenticationState>().state.user!.uid);
//   final d = await refData.once();
//   for (var i in d.snapshot.children) {
//     debugPrint(i.key);
//   }
//   return [];

//   // final data = refData.value as Map;
//   // return List.generate(data.length, (index) {
//   //   return Restro.build(data.entries.elementAt(index).value as Map,
//   //       data.entries.elementAt(index).key);
//   // });
// }

Stream<DatabaseEvent> basketStockMonitoring(Basket basket) {
  final ref = DatabaseRootMethod.baseketRoot(basket.restroId)
      .child([basket.id, BasketDBKey.stock].join("/"))
      .onChildChanged;

  return ref;
}

Future<List<Restro>> get newRestro async {
  final ref = DatabaseRoot.restroProfile.standardReference;
  final refData = ref.orderByChild("meta").limitToLast(10);
  final d = await refData.once();
  // for (var i in d.snapshot.children) {
  //   debugPrint("${(i.value as Map?)?["meta"]["creation"]}");
  // }
  return d.snapshot.children.map((e) {
    return Restro.build(e.value as Map, e.key!);
  }).toList();

  // final data = refData.value as Map;
  // return List.generate(data.length, (index) {
  //   return Restro.build(data.entries.elementAt(index).value as Map,
  //       data.entries.elementAt(index).key);
  // });
}

Future<List<Restro>> get nearByRestro async {
  final ref = DatabaseRoot.restroProfile.standardReference;
  final refData = ref.orderByChild("meta").limitToLast(10);
  final d = await refData.once();
  for (var i in d.snapshot.children) {
    debugPrint("${(i.value as Map?)?["meta"]["creation"]}");
  }
  return [];

  // final data = refData.value as Map;
  // return List.generate(data.length, (index) {
  //   return Restro.build(data.entries.elementAt(index).value as Map,
  //       data.entries.elementAt(index).key);
  // });
}

Future<List<Restro>> restros(Iterable<String> ids, {int limit = 10}) async {
  final ref = DatabaseRoot.restroProfile.standardReference;
  final refData = await Future.wait(List.generate(
      limit > ids.length ? ids.length : limit,
      (index) => ref.child(ids.elementAt(index)).get()));

  return refData
      .map((e) => Restro.build(e.value as Map, e.key as String))
      .toList();
}

Future<Map?> rawRestro(String id) async {
  final ref = DatabaseRoot.restroProfile.standardReference;
  final refData = await ref.child(id).get();
  // debugPrint("rawRestro got ${refData.value} ${ref.child(id).path}");
  return refData.value as Map?;
}

/// Universial Data getter
Future<Map> get appUniversal async {
  final DatabaseReference ref =
      DatabaseRootMethod.configDBReference(ConfigRootReferenceType.universal);
  final universal = await ref.get();
  return universal.value as Map;
}

Future<Map> get adminPortalUniversal async {
  const url =
      "https://goodtakes-9e17c-default-rtdb.firebaseio.com/config/universal.json";
  final http.Response res = await http.get(Uri.parse(url));

  return json.decode(res.body);
}

Future<String> restroDetail(String id, RestroDBKey restroDBKey) async {
  late final List<String> paths;
  if (restroDBKey == RestroDBKey.address || restroDBKey == RestroDBKey.name) {
    final langTag = RM.get<AuthenticationState>().state.locale;
    paths = [id, restroDBKey.dbKey, langTag.languageCode];
  } else {
    paths = [id, restroDBKey.dbKey];
  }
  final DatabaseReference ref =
      DatabaseRoot.restroProfile.standardReference.child(paths.join("/"));
  return (await ref.get()).value as String;
}

Future<String> userProfileDetail(String id, UserDBKey userDBKey) async {
  late final List<String> paths;
  if (userDBKey == UserDBKey.name) {
    final langTag = RM.get<AuthenticationState>().state.locale;
    paths = [id, "profile", userDBKey.dbKey, langTag.languageCode];
  } else {
    paths = [id, "profile", userDBKey.dbKey];
  }
  final DatabaseReference ref =
      DatabaseRoot.user.standardReference.child(paths.join("/"));
  return (await ref.get()).value as String;
}

// Future<List<gt.Transaction>> get myTransactionCompleted async {
//   final uid = RM.get<AuthenticationState>().state.user?.uid;
//   if (uid == null) {
//     return [];
//   } else {
//     final DatabaseReference ref = DatabaseRoot.transaction.standardReference;
//     final Iterable<DataSnapshot> snaps = (await ref
//             .orderByChild("index/user")
//             .equalTo("${uid}_completed")
//             .once())
//         .snapshot
//         .children;
//     return snaps
//         .map((e) => gt.Transaction.build(e.value as Map, e.key!))
//         .toList();
//   }
// }

// Future<List<gt.Transaction>> get myTransactionOnProgress async {
//   final uid = RM.get<AuthenticationState>().state.user?.uid;
//   if (uid == null) {
//     return [];
//   } else {
//     final DatabaseReference ref = DatabaseRoot.transaction.standardReference;
//     final Iterable<DataSnapshot> snaps =
//         (await ref.orderByChild("index/user").equalTo("${uid}_progress").once())
//             .snapshot
//             .children;

//     return snaps
//         .map((e) => gt.Transaction.build(e.value as Map, e.key!))
//         .toList();
//   }
// }

/// My Restro

Future<Map?> get myRestroList async {
  return (await DatabaseRootMethod.userDBReference(
              type: UserRootReferenceType.myRestro)
          ?.get())
      ?.value as Map?;
}

Future<List<InAppNotification>> myRestroNotification(String restroId) async {
  final DatabaseReference ref =
      DatabaseRoot.restroNotification.standardReference.child(restroId);
  final data = await ref.get();
  debugPrint("myRestroNotification::: ${data.value}");
  return (data.children)
      .map((e) => InAppNotification.build(e.value as Map, e.key!))
      .toList();
}

Future<List<RestroReceipt>> myRestroReceipt(String restroId) async {
  final DataSnapshot data =
      await DatabaseRoot.restroReceipt.standardReference.child(restroId).get();

  return (data.children)
      .map((e) => RestroReceipt.build(e.value as Map, e.key!))
      .toList();
}

// Future<List<gt.Transaction>> myRestroTransactionCompleted(
//     String restroId) async {
//   final DatabaseReference ref = DatabaseRoot.transaction.standardReference;
//   final Iterable<DataSnapshot> snaps = (await ref
//           .orderByChild("index/restro")
//           .equalTo("${restroId}_completed")
//           .once())
//       .snapshot
//       .children;
//   return snaps
//       .map((e) => gt.Transaction.build(e.value as Map, e.key!))
//       .toList();
// }

/// Async
Stream<DatabaseEvent>? get myNotificationStream {
  final int dt = DateTime.now().millisecondsSinceEpoch;
  return DatabaseRootMethod.userDBReference()
      ?.child("notification")
      .orderByChild(orderByCreationPath)
      .startAfter(dt)
      .onChildAdded;
}

// Stream<DatabaseEvent>? get receiptStream {
//   return DatabaseRootMethod.userDBReference()?.child("receipt").onChildAdded;
// }

Stream<DatabaseEvent>? get myReceiptStream {
  return DatabaseRootMethod.userDBReference()
      ?.child("receipt")
      .limitToLast(50)
      .onChildChanged;
}

Stream<DatabaseEvent> get myProfileStream {
  return DatabaseRootMethod.userDBReference(
          type: UserRootReferenceType.profile)!
      .onChildChanged;
}

/// Restro ref

Query myRestroNotificationStreamQuery({required String restroId}) {
  return DatabaseRoot.restroNotification.standardReference
      .child(restroId)
      .orderByChild(orderByCreationPath)
      .startAfter(DateTime.now().millisecondsSinceEpoch)
      .limitToLast(1);
}

Query myRestroReceiptStreamQuery({required String restroId}) {
  return DatabaseRoot.restroReceipt.standardReference
      .child(restroId)
      .orderByChild(orderByCreationPath)
      .startAfter(DateTime.now().millisecondsSinceEpoch)
      .limitToLast(1);
}
