import 'package:com_goodtakes/model/base/receipt/receipt_extension.dart';
import 'package:com_goodtakes/model/receipt/user_receipt.dart';
import 'package:com_goodtakes/static/firebase_ref_path.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyReceiptState {
  final List<UserReceipt> _receipt = [];

  List<UserReceipt> get receipt => _receipt;

  Future<void> init() async {
    debugPrint("MY RECEIPT STATE INIT:::");
    final DatabaseEvent? res =
        await DatabaseRootMethod.userDBReference()?.child("receipt").once();
    _receipt.addAll(res?.snapshot.children
            .map(((e) => UserReceipt.build(e.value as Map, e.key!))) ??
        []);
    debugPrint(
        "datas _completedTransaction: ${_receipt.length} /// datas onProcessTransaction: ${_receipt.length}");
  }

  Future<void> complete(UserReceipt userReceipt) async {
    userReceipt.status = ReceiptStatus.complete;
    debugPrint("on complete called");
    // completeTransaction(receipt: userReceipt);
    userReceipt.status = ReceiptStatus.complete;
    // _receipt.removeWhere((e) {
    //   return e.id == userReceipt.id;
    // });

    debugPrint("current receipt count ${_receipt.length}");
    return;
  }

  // void clear() {
  //   _completedTransaction.clear();
  //   _onProcessTransaction.clear();
  // }
}
