import 'package:com_goodtakes/states/my_restro_state.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/views/transaction_view/transaction_view.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/scr/state_management/state_management.dart';

class MyRestroTransaction extends StatelessWidget {
  const MyRestroTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: StaticAppBar(
          title: StandardInappContentType.myRestroTransactionAppbarTitle.label,
          foregroundColor: StandardColor.white,
          background: StandardColor.green,
        ),
        body: OnBuilder(
            listenTo: (RM.get<MyRestroState>()),
            builder: () {
              final model = RM.get<MyRestroState>();

              debugPrint(
                  "OnBuilder ::: TransactionListView ${model.state.receipts.length}");
              return TransactionListView(
                  isRestro: true, receipts: model.state.receipts);
            }));
  }
}
