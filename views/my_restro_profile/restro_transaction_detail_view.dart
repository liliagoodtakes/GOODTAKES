import 'package:com_goodtakes/model/base/receipt/receipt_extension.dart';
import 'package:com_goodtakes/model/receipt/restro_receipt.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/states/my_receipt_state.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/display/decorated_title.dart';
import 'package:com_goodtakes/widgets/display/transaction/transaction_amount_summary.dart';
import 'package:com_goodtakes/widgets/display/widget_credit_card_with_four_digit.dart';
import 'package:com_goodtakes/widgets/display/order/order_heading.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:flutter/material.dart';

class RestroTransactionDetailView extends StatelessWidget {
  final RestroReceipt receipt;
  const RestroTransactionDetailView({Key? key, required this.receipt})
      : super(key: key);

  Widget get headlineColSeperator => const SizedBox(height: 20);
  Widget get inlineColSeperator => const SizedBox(height: 10);
  Widget get inlineSeperator => const SizedBox(height: 5, width: 5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: StaticAppBar(
          title: StandardInappContentType
              .myRestroTransactionDetailAppbarTitle.label,
          foregroundColor: StandardColor.white,
          background: StandardColor.green,
        ),
        body: ListView(padding: StandardSize.generalViewPadding, children: [
          OrderHeader(
              orderNumber: receipt.id,
              completed: receipt.status == ReceiptStatus.complete),
          headlineColSeperator,
          Container(
              padding: StandardSize.generalViewPadding,
              decoration: const BoxDecoration(
                  borderRadius: StandardSize.generalChipBorderRadius,
                  color: StandardColor.white),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  const Icon(Icons.person,
                      color: StandardColor.yellow, size: 20),
                  inlineSeperator,
                  SizedBox(
                      height: 22,
                      child: Text(receipt.userName,
                          style: StandardTextStyle.black14SB))
                ]),
                inlineSeperator,
                Row(children: [
                  const ImageIcon(AssetImage(StandardAssetImage.iconShop),
                      color: StandardColor.yellow, size: 20),
                  inlineSeperator,
                  Text(receipt.pickupTime.generalPickUpTimeRangeStatement,
                      style: StandardTextStyle.black14R)
                ])
              ])),
          headlineColSeperator,
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DecoratedTitle(
                title: StandardInappContentType.paymentBillSummaryTitle.label),
            inlineColSeperator,
            TransactionAmountSummary(detail: receipt.detail)
            // OrderDetail(showTotal: true, basketCountor: {Basket.demo: 1}),
          ]),
          headlineColSeperator,
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DecoratedTitle(
                title:
                    StandardInappContentType.generalPaymentMethodTitle.label),
            inlineColSeperator,
            CreditCardWithFourDigit(
                totalPayable: receipt.payable,
                lastFour: "",
                agent: receipt.paymentMethod)
          ])
        ]));
  }
}
