import 'package:com_goodtakes/model/base/meta_tag.dart';
import 'package:com_goodtakes/model/base/receipt/receipt_extension.dart';
import 'package:com_goodtakes/service/launcher_service.dart';
import 'package:com_goodtakes/states/my_receipt_state.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/display/decorated_title.dart';
import 'package:com_goodtakes/widgets/display/transaction/transaction_achievement_summary.dart';
import 'package:com_goodtakes/widgets/display/transaction/transaction_amount_summary.dart';
import 'package:com_goodtakes/widgets/display/widget_credit_card_with_four_digit.dart';
import 'package:com_goodtakes/widgets/display/widget_order_restro_info.dart';
import 'package:com_goodtakes/widgets/display/order/order_heading.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/confirmation_slider.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class TransactionDetailView extends StatelessWidget {
  final String receiptId;
  const TransactionDetailView({Key? key, required this.receiptId})
      : super(key: key);

  Widget get headlineColSeperator => const SizedBox(height: 20);
  Widget get inlineColSeperator => const SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    return OnBuilder(
        listenTo: RM.get<MyReceiptState>(),
        builder: () {
          final model = RM.get<MyReceiptState>();

          final receipt = RM
              .get<MyReceiptState>()
              .state
              .receipt
              .singleWhere((element) => element.id == receiptId);
          final completion = receipt.status == ReceiptStatus.complete;
          final completed = receipt.status == ReceiptStatus.complete;
          return Scaffold(
              appBar: StaticAppBar(actions: [
                GestureDetector(
                  onTap: () {
                    standardLauncher(LauncherType.email);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        StandardInteractionTextType.generalHelpLabel.label,
                        style: StandardTextStyle.black14U,
                      )),
                ),
                const SizedBox(width: 9)
              ], title: StandardInappContentType.transactionDetailTitle.label),
              body: Stack(children: [
                SafeArea(
                    child: ListView(
                        padding: StandardSize.generalViewPadding,
                        children: [
                      OrderHeader(
                          orderNumber:
                              receipt.meta[dbMetaReciptNo] ?? "order_id",
                          completed: completion),
                      headlineColSeperator,
                      OrderRestroInfo(receipt: receipt, showNavigator: true),
                      headlineColSeperator,
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DecoratedTitle(
                                title: StandardInappContentType
                                    .paymentBillSummaryTitle.label),
                            inlineColSeperator,
                            TransactionAmountSummary(detail: receipt.detail)
                            // OrderDetail(showTotal: true, basketCountor: {Basket.demo: 1}),
                          ]),
                      headlineColSeperator,
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DecoratedTitle(
                                title: StandardInappContentType
                                    .generalPaymentMethodTitle.label),
                            inlineColSeperator,
                            CreditCardWithFourDigit(
                                totalPayable: receipt.payable,
                                lastFour: receipt.payment["payment_card"] ?? "",
                                agent: receipt.payment["payment_method"] ?? ""),
                          ]),
                      Offstage(
                          offstage: completed,
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: StandardTextStyle.grey12R,
                                  children: [
                                    TextSpan(
                                        text: StandardInappContentType
                                            .transactionDetailCompletionStatement
                                            .label),
                                    TextSpan(
                                        text: StandardInappContentType
                                            .generalUserRegulation.label,
                                        style: StandardTextStyle.yellow12U)
                                  ]))),
                      headlineColSeperator,
                      const SizedBox(
                          height: StandardSize.generalBottomEdgeWithButton)
                    ])),
                AnimatedPositioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: completed ? 0 : -120,
                    child: TransactionAchievementSummary(
                        summary: receipt.transactionSummary),
                    duration: const Duration(milliseconds: 250)),
                Positioned(
                    bottom: 0,
                    child: Offstage(
                        offstage: completed,
                        child: SafeArea(
                            child: Container(
                                // padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                                foregroundDecoration: BoxDecoration(
                                    borderRadius:
                                        StandardSize.generalChipBorderRadius,
                                    border: Border.all(color: Colors.black)),
                                // padding: StandardSize.generalViewPadding,
                                margin: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: ConfirmationSlider(
                                  excluded: 40,
                                  onConfirmation: () async {
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    model.setState(
                                        (s) async => await s.complete(receipt));
                                  },
                                  initCompletion: false,
                                )))))
              ]));
        });
  }
}
